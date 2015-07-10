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
    
    var menu : [Dish]!
    var dishes: Dishes!
    var signUpViewControllerDelegate: SignUpViewControllerDelegate?
    let styles = Styles()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    @IBOutlet weak var restMenuButton: UIButton!
    @IBOutlet weak var foodTinderMenuButton: UIButton!
    @IBOutlet weak var myPrefMenuButton: UIButton!
    @IBOutlet weak var sustInfoMenuButton: UIButton!
    @IBOutlet weak var food4ThoughtLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "MainMenuBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
//        //sets nav bar to be non see through
//        let bar:UINavigationBar! =  self.navigationController?.navigationBar
//        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        bar.shadowImage = UIImage()
//        bar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        
       // restMenuButton.backgroundColor = styles.buttonBackgoundColor
       // restMenuButton.layer.cornerRadius = styles.buttonCornerRadius
       // restMenuButton.layer.borderWidth = 1
        restMenuButton.setTitle(" See All Restaurants", forState: .Normal)
        foodTinderMenuButton.setTitle(" Food Tinder", forState: .Normal)
        myPrefMenuButton.setTitle(" My Preferences", forState: .Normal)
        sustInfoMenuButton.setTitle(" Sustainability Info", forState: .Normal)
        
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

        food4ThoughtLabel.layer.shadowColor = UIColor.blackColor().CGColor
        food4ThoughtLabel.layer.shadowOffset = CGSizeMake(5, 5)
        food4ThoughtLabel.layer.shadowRadius = 5
        food4ThoughtLabel.layer.shadowOpacity = 1.0

        restMenuButton.frame = styles.buttonFrame
        myPrefMenuButton.frame = styles.buttonFrame
        foodTinderMenuButton.frame = styles.buttonFrame
        sustInfoMenuButton.frame = styles.buttonFrame

        //change the backbutton title
        let backButton = UIBarButtonItem(
            title: "Log out",
            style: UIBarButtonItemStyle.Plain,
            target: nil,
            action: nil
        )
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        self.fetchPreferenceData()
        self.fetchDislikeData()
        //self.refreshMenu()
    }
    
 
    
    
    /**
    Logs out and clears the text field when go back
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            PFUser.logOut()
            println("Logged out")
            signUpViewControllerDelegate?.clearTextField()
        }
    }
    
    
    /**
    Sets the states of dishes to default when relog in
    */
    func refreshMenu(){
        for dish: Dish in menu{
            dish.like = false
            dish.dislike = false
        }
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
    
    
    func addDishWithName(location: String, name: String, like : Bool, dislike: Bool){
        var query = PFQuery(className:"dishInfo")
        query.whereKey("name", equalTo: name)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil{
                if let objectsArray = objects{
                    for object: AnyObject in objectsArray{
                        if let name = object["name"] as? String {
                            if let userImageFile = object["image"] as? PFFile{
                                userImageFile.getDataInBackgroundWithBlock {
                                    (imageData: NSData?, error: NSError?) ->Void in
                                    if error == nil {                               if let data = imageData{                                                if let image = UIImage(data: data){
                                        if let location = object["location"] as? String{
                                            if let ingredients = object["ingredients"] as? [String]{
                                                if let labels = object["labels"] as? [[String]]{
                                                    if let type = object["type"] as? String{
                                                        let dish = Dish(name: name, image: image, location: location, type: type, ingredients: ingredients, labels: labels)
                                                        dish.like = like
                                                        dish.dislike = dislike
                                                        self.dishes.addDish(location, dish: dish)
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
    
    
    @IBAction func showRestaurants(sender: AnyObject) {
        performSegueWithIdentifier("mainToRestaurantsSegue", sender: sender)
    }
    
    
    @IBAction func foodTinderAction(sender: AnyObject) {
        performSegueWithIdentifier("foodTinderSegue", sender: sender)
    }
 
    
    /**
    Prepares for segues
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "foodTinderSegue"{
            let foodTinderViewController = segue.destinationViewController as! FoodTinderViewController
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

