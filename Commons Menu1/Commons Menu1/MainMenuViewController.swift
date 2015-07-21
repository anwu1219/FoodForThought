//
//  MainMenuViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 16/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

/**
Welcome page view controller and search type for user
*/

class MainMenuViewController: UIViewController {
    
    var dishes: Dishes!
    var signUpViewControllerDelegate: SignUpViewControllerDelegate?
    let styles = Styles()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    @IBOutlet weak var restMenuButton: UIButton!
    @IBOutlet weak var foodTinderMenuButton: UIButton!
    @IBOutlet weak var myPrefMenuButton: UIButton!
    @IBOutlet weak var sustInfoMenuButton: UIButton!
    @IBOutlet weak var topDishesMenuButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "MainMenuBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        restMenuButton.setTitle(" See All Restaurants", forState: .Normal)
        foodTinderMenuButton.setTitle("Food For Thought", forState: .Normal)
        myPrefMenuButton.setTitle(" My Favorites", forState: .Normal)
        sustInfoMenuButton.setTitle(" Sustainability Info", forState: .Normal)
        topDishesMenuButton.setTitle(" Top Dishes", forState: .Normal)
        
        restMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        restMenuButton.layer.shadowRadius = 5
        restMenuButton.layer.shadowOpacity = 1.0
        
        foodTinderMenuButton.layer.shadowOffset = CGSizeMake(4, 4)
        foodTinderMenuButton.layer.shadowRadius = 5
        foodTinderMenuButton.layer.shadowOpacity = 1.0
        
        myPrefMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        myPrefMenuButton.layer.shadowRadius = 5
        myPrefMenuButton.layer.shadowOpacity = 1.0
        
        sustInfoMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        sustInfoMenuButton.layer.shadowRadius = 5
        sustInfoMenuButton.layer.shadowOpacity = 1.0
        
        topDishesMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        topDishesMenuButton.layer.shadowRadius = 5
        topDishesMenuButton.layer.shadowOpacity = 1.0
        
        restMenuButton.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
        restMenuButton.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
        restMenuButton.titleLabel?.layer.shadowRadius = 2
        restMenuButton.titleLabel?.layer.shadowOpacity = 1.0
        
        foodTinderMenuButton.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
        foodTinderMenuButton.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
        foodTinderMenuButton.titleLabel?.layer.shadowRadius = 2
        foodTinderMenuButton.titleLabel?.layer.shadowOpacity = 1.0
        
        myPrefMenuButton.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
        myPrefMenuButton.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
        myPrefMenuButton.titleLabel?.layer.shadowRadius = 2
        myPrefMenuButton.titleLabel?.layer.shadowOpacity = 1.0
        
        sustInfoMenuButton.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
        sustInfoMenuButton.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
        sustInfoMenuButton.titleLabel?.layer.shadowRadius = 2
        sustInfoMenuButton.titleLabel?.layer.shadowOpacity = 1.0
        
        topDishesMenuButton.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
        topDishesMenuButton.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
        topDishesMenuButton.titleLabel?.layer.shadowRadius = 2
        topDishesMenuButton.titleLabel?.layer.shadowOpacity = 1.0
        
        restMenuButton.frame = styles.buttonFrame
        myPrefMenuButton.frame = styles.buttonFrame
        foodTinderMenuButton.frame = styles.buttonFrame
        sustInfoMenuButton.frame = styles.buttonFrame
        topDishesMenuButton.frame = styles.buttonFrame
        
        
        //change the backbutton title (hides it)
        let backButton = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain,
            target: nil,
            action: nil
        )
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.fetchPreferenceData()
        self.fetchDislikeData()
        
        if let user =  PFUser.currentUser() {
        if let tinderViewed = user["tinderViewed"] as? Bool {
            if let menuViewed = PFUser.currentUser()!["menuViewed"] as? Bool {
                self.dishes.learned["tinder"] = tinderViewed
                self.dishes.learned["menuSwipe"] = menuViewed
                println("Logged in successfully")
                }
            }
        }
    }
    
    //creates the log out alert
    @IBAction func logoutAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Log Out?",
            message: "Are you sure you want to Log Out?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Destructive,
            handler: { alertAction in self.logOutSegue() }
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
    
    
    /**
    Logs out and clears the text field when go back
    */
    func logOutSegue(){
        PFUser.logOut()
        println("Logged out")
        signUpViewControllerDelegate?.clearTextField()
        for restaurant : RestProfile in dishes.dishes.keys {
            dishes.dishes[restaurant]?.removeAll(keepCapacity: false)
        }//needs update to cache
        
        performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
    Fetches preference data from Parse and sets the corresponding dish object like to true
    */
    func fetchPreferenceData(){
        if let currentUser = PFUser.currentUser(){
            var user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            var query = PFQuery(className:"Preference")
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
    func addDishWithName(location: String, name: String, like : Bool, dislike: Bool){
        var query = PFQuery(className:"dishInfo")
        query.whereKey("name", equalTo: name)
        query.getFirstObjectInBackgroundWithBlock{
            (object: PFObject?, error: NSError?) -> Void in
            if let object = object{
                if let name = object["name"] as? String {
                    if let location = object["location"] as? String{
                        if let ingredients = object["ingredients"] as? [String]{
                            if let labels = object["labels"] as? [[String]]{
                                if let type = object["type"] as? String{
                                    if let susLabels = object["susLabels"] as? [String]{
                                        if let index = object["index"] as? Int{
                                            if let eco = object["eco"] as? [String] {
                                                if let fair = object["fair"] as? [String]{
                                                    if let humane = object["humane"] as? [String] {
                                            if let price = object["price"] as? String{
                                                if let userImageFile = object["image"] as? PFFile{
                                                                let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels, eco: eco, fair: fair, humane: humane, imageFile: userImageFile)
                                                                dish.like = like
                                                                dish.dislike = dislike
                                                                self.dishes.addToDealtWith(index)
                                                                self.dishes.addDish(location, dish: dish)
                                                                self.dishes.addPulled(index)
                                                } else{
                                                    let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels, eco: eco, fair: fair, humane: humane)
                                                    dish.like = like
                                                    dish.dislike = dislike
                                                    self.dishes.addToDealtWith(index)
                                                    self.dishes.addDish(location, dish: dish)
                                                    self.dishes.addPulled(index)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
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
    Fetches dislike data from Parse and sets the corresponding dish object's dislike to true
    */
    func fetchDislikeData(){
        if let currentUser = PFUser.currentUser(){
            var user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            var query = PFQuery(className:"Disliked")
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
    
    
    func getNumberOfDishes(){
        var query = PFQuery(className:"Constants")
        query.whereKey("name", equalTo: "dishNumber")
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let object = object {
                if let value = object["value"] as? Int {
                    self.dishes.setNumberOfDishes(value)
                }
            }
        }
    }
    
    
    @IBAction func showRestaurants(sender: AnyObject) {
        performSegueWithIdentifier("mainToRestaurantsSegue", sender: sender)
    }
    
    
    @IBAction func foodTinderAction(sender: AnyObject) {
        self.performSegueWithIdentifier("foodTinderSegue", sender: sender)
    }
    
   
    
    
    /**
    Prepares for segues
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "foodTinderSegue"{
            let foodTinderViewController = segue.destinationViewController as! FoodTinderViewController
            self.getNumberOfDishes()
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

