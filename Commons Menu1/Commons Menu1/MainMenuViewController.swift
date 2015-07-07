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
    var restaurants : [String: [Dish]]!
    var restauranto : [RestProfile]!
    var preferences : [String: [String]]!
    var dislikes : [String : [String]]!
    var restauranten = [RestProfile: [Dish]]()
    var signUpViewControllerDelegate: SignUpViewControllerDelegate?
    let styles = Styles()
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
               
       // restMenuButton.backgroundColor = styles.buttonBackgoundColor
       // restMenuButton.layer.cornerRadius = styles.buttonCornerRadius
       // restMenuButton.layer.borderWidth = 1
        restMenuButton.setTitle(" See All Restaurants", forState: .Normal)
        foodTinderMenuButton.setTitle(" Food Tinder", forState: .Normal)
        myPrefMenuButton.setTitle(" My Preferences", forState: .Normal)
        sustInfoMenuButton.setTitle(" Sustainability Info", forState: .Normal)

        /* Not working right now..
        restMenuButton.setTitleShadowColor(UIColor.blackColor(), forState: UIControlState.Normal)
        restMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        restMenuButton.layer.shadowRadius = 5
        restMenuButton.layer.shadowOpacity = 1.0
        
        foodTinderMenuButton.setTitleShadowColor(UIColor.blackColor(), forState: UIControlState.Normal)
        foodTinderMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        foodTinderMenuButton.layer.shadowRadius = 5
        foodTinderMenuButton.layer.shadowOpacity = 1.0

        myPrefMenuButton.setTitleShadowColor(UIColor.blackColor(), forState: UIControlState.Normal)
        myPrefMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        myPrefMenuButton.layer.shadowRadius = 5
        myPrefMenuButton.layer.shadowOpacity = 1.0

        sustInfoMenuButton.setTitleShadowColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sustInfoMenuButton.layer.shadowOffset = CGSizeMake(5, 5)
        sustInfoMenuButton.layer.shadowRadius = 5
        sustInfoMenuButton.layer.shadowOpacity = 1.0
        */

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
        self.applyPreferences()
        self.applyDislikes()
        self.refreshMenu()
        self.makeRestauranten()
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
    
    
    /**
    Sets the like attribute to true for each dish object in preferences
    */
    func applyPreferences(){
        for key in preferences.keys{
            for dishName: String in preferences[key]!{
                for dish in restaurants[key]!{
                    if dish.name == dishName {
                        dish.like = true
                    }
                }
            }
        }
    }
    
    
    /**
    Sets the dislike attribute to true for each dish object in dislikes
    */
    func applyDislikes(){
        for key in dislikes.keys{
            for dishName: String in dislikes[key]!{
                for dish in restaurants[key]!{
                    if dish.name == dishName{
                        dish.dislike = true
                    }
                }
            }
        }
    }
    
    
    /**
    Creates a map of RestProfile to its Dishes
    */
    func makeRestauranten() {
        for restaurant: RestProfile in restauranto{
            restauranten[restaurant] = restaurants[restaurant.name]
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
                                        self.addToPreferenceList(restaurant, dishName: dishName)
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
    Sets the like attribute of a dish object to true
    */
    func addToPreferenceList(restaurant: String, dishName: String){
        for dish: Dish in restaurants[restaurant]!{
            if dish.name == dishName {
                dish.like = true
            }
        }
    }
    
    
    /**
    Fetches dislike data from Parse and sets the corresponding dish object's dislike to true
    */
    func fetchDislikeData(){
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
                                        self.addToDislike(restaurant, dishName: dishName)
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
    Sets the dealWith attribute of a dish object to true
    */
    func addToDislike(restaurant: String, dishName: String){
        for dish: Dish in restaurants[restaurant]!{
            if dish.name == dishName {
                dish.dislike = true
            }
        }
    }
    
    
    /**
    Deletes the preference list class in parse
    */
    func deletePreferenceList(){
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
                                pFObject.deleteInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        println("Successfully deleted")
                                    } else {
                                        println("Failed")
                                    }
                                })
                                //pFObject.pinInBackground({})
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
            menu.sort({$0.name<$1.name})
            foodTinderViewController.menuLoad = menu
        }
        if segue.identifier == "mainToRestaurantsSegue" {
            let restMenuViewController = segue.destinationViewController as! RestMenuViewController
            menu.sort({$0.name<$1.name})
            restMenuViewController.restauranten = restauranten
        }
        if segue.identifier == "mainToAllPreferencesSegue"{
            let allPreferenceListViewController = segue.destinationViewController as! AllPreferenceListViewController
            //self.deletePreferenceList()
            allPreferenceListViewController.restaurants = restaurants
        }
    }
    
}

