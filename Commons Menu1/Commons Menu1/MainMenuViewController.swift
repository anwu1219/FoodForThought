//
//  MainMenuViewController.swift
//  Foodscape
//
//  Created by Bjorn Ordoubadian on 16/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

/**
Welcome page view controller and search type for user
*/

class MainMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var dishes: Dishes!
    final private let screenSize: CGRect = UIScreen.mainScreen().bounds
    @IBOutlet weak var restMenuButton: UIButton!
    @IBOutlet weak var foodTinderMenuButton: UIButton!
    @IBOutlet weak var myPrefMenuButton: UIButton!
    @IBOutlet weak var sustInfoMenuButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    let instructButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground("MainMenuBackground")
        restMenuButton.setTitle(" See All Restaurants", forState: .Normal)
        foodTinderMenuButton.setTitle(" Food For Thought", forState: .Normal)
        myPrefMenuButton.setTitle(" My Favorites", forState: .Normal)
        sustInfoMenuButton.setTitle(" Sustainability Info", forState: .Normal)
        
        func buttonStyle(button: UIButton, title: String){
            button.setTitle(title, forState: .Normal)
            button.layer.shadowOffset = CGSizeMake(5, 5)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 1.0
            button.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
            button.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
            button.titleLabel?.layer.shadowRadius = 2
            button.titleLabel?.layer.shadowOpacity = 1.0
        }

        buttonStyle(restMenuButton, " See All Restaurants")
        buttonStyle(foodTinderMenuButton, " Food For Thought")
        buttonStyle(myPrefMenuButton, " My Favorites")
        buttonStyle(sustInfoMenuButton, " About Sustainability")
        
        
        //change the backbutton title (hides it)
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain,
            target: nil,
            action: nil
        )
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        instructButton.frame = CGRect(x: 0.9 * view.frame.width, y: 0.915 * view.frame.height, width: 0.06 * view.frame.width, height: 0.06 * view.frame.width)
        instructButton.tintColor = UIColor.whiteColor()
        instructButton.addTarget(self, action: "viewInstructPage:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(instructButton)
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
            self.fetchPreferenceData()
            self.fetchDislikeData()
            self.getNumberOfDishes()
            if let user =  PFUser.currentUser() {
                if let tinderViewed = user["tinderViewed"] as? Bool {
                    if let menuViewed = PFUser.currentUser()!["menuViewed"] as? Bool {
                        self.dishes.learned["tinder"] = tinderViewed
                        self.dishes.learned["menuSwipe"] = menuViewed
                    }
                }
            }
        }
    }
    
    
    
    // :-Button Actions
    func viewInstructPage(sender : UIButton){
        performSegueWithIdentifier("viewInstructSegue", sender: sender)
    }
    
    
    //creates the log out alert
    @IBAction func logoutAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Log Out?",
            message: "Are you sure you want to Log Out?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Destructive,
            handler: { alertAction in self.logOut() }
            )
        )
        alert.addAction(UIAlertAction(
            title: "No",
            style: UIAlertActionStyle.Cancel,
            handler: nil
            )
        )
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction private func showRestaurants(sender: AnyObject) {
        performSegueWithIdentifier("mainToRestaurantsSegue", sender: sender)
    }
    
    
    @IBAction private func foodTinderAction(sender: AnyObject) {
        self.performSegueWithIdentifier("foodTinderSegue", sender: sender)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        super.viewWillAppear(animated)
    }
    
    
   
    
    /**
    Logs out and clears the text field when go back
    */
    private func logOut(){
        PFUser.logOut()
        for restaurant : RestProfile in dishes.dishes.keys {
            dishes.dishes[restaurant]?.removeAll(keepCapacity: false)
        }//needs update to cache
        
        performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    
    private func getNumberOfDishes(){
        let query = PFQuery(className:"Constants")
        query.whereKey("name", equalTo: "dishNumber")
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let object = object {
                if let value = object["value"] as? Int {
                    self.dishes.setNumberOfDishes(value)
                }
            }
        }
    }
   
    
    /**
    Fetches preference data from Parse and sets the corresponding dish object like to true
    */
    private func fetchPreferenceData(){
        if let currentUser = PFUser.currentUser(){
            let user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            let query = PFQuery(className:"Preference")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                if let restaurant = pFObject["location"] as?String{
                                    if let dishName = pFObject["dishName"] as? String{
                                        self.addDishWithName(restaurant, name: dishName, like: true, dislike: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /**
    Add a dish with specific location and name to the dishes object
    */
    private func addDishWithName(location: String, name: String, like : Bool, dislike: Bool){
        let query = PFQuery(className:"dishInfo")
        query.whereKey("name", equalTo: name)
        query.getFirstObjectInBackgroundWithBlock{
            (object: PFObject?, error: NSError?) -> Void in
            if let object = object {
                let dish = object as! Dish
                dish.like = like
                dish.dislike = dislike
                dish.getDishData(object)
                self.dishes.addToDealtWith(dish.index)
                self.dishes.addDish(location, dish: dish)
                self.dishes.addPulled(dish)
            }
        }
    }
    
    
    /**
    Fetches dislike data from Parse and sets the corresponding dish object's dislike to true
    */
    private func fetchDislikeData(){
        if let currentUser = PFUser.currentUser(){
            let user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            let query = PFQuery(className:"Disliked")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                if let restaurant = pFObject["location"] as?String{
                                    if let dishName = pFObject["dishName"] as? String{
                                        self.addDishWithName(restaurant, name: dishName, like: false, dislike: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    Prepares for segues
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "foodTinderSegue"{
            let foodTinderViewController = segue.destinationViewController as! FoodTinderViewController
            foodTinderViewController.dishes = dishes
        }
        if segue.identifier == "mainToRestaurantsSegue" {
            let restMenuViewController = segue.destinationViewController as! RestMenuViewController
            restMenuViewController.dishes = dishes
        }
        if segue.identifier == "mainToAllPreferencesSegue"{
            let allPreferenceListViewController = segue.destinationViewController as! AllPreferenceListViewController
            allPreferenceListViewController.dishes = dishes
        }
    }
}


extension MainMenuViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .FullScreen
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let vc = controller.presentedViewController
        let nav = UINavigationController(rootViewController: vc)
        let b = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissHelp:")
        vc.navigationItem.rightBarButtonItem = b
        return nav
    }
    
    func dismissHelp(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

