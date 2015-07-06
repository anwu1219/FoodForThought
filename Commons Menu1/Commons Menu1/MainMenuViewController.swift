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
    

    @IBAction func showRestaurants(sender: AnyObject) {
        performSegueWithIdentifier("mainToRestaurantsSegue", sender: sender)
    }
    
    @IBAction func foodTinderAction(sender: AnyObject) {
        performSegueWithIdentifier("foodTinderSegue", sender: sender)
    }
    
   
    @IBOutlet weak var restMenuButton: UIButton!
    @IBOutlet weak var foodTinderMenuButton: UIButton!
    @IBOutlet weak var myPrefMenuButton: UIButton!
    @IBOutlet weak var sustInfoMenuButton: UIButton!
    @IBOutlet weak var food4ThoughtLabel: UILabel!
    
    
    let styles = Styles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        food4ThoughtLabel.layer.shadowColor = UIColor.blackColor().CGColor
        food4ThoughtLabel.layer.shadowOffset = CGSizeMake(5, 5)
        food4ThoughtLabel.layer.shadowRadius = 5
        food4ThoughtLabel.layer.shadowOpacity = 1.0

        
        restMenuButton.frame = styles.buttonFrame
        myPrefMenuButton.frame = styles.buttonFrame
        foodTinderMenuButton.frame = styles.buttonFrame
        sustInfoMenuButton.frame = styles.buttonFrame

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
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            PFUser.logOut()
            println("Logged out")
            signUpViewControllerDelegate?.clearTextField()
        }
    }
    
    func refreshMenu(){
        for dish: Dish in menu{
            dish.like = false
            dish.dealtWith = false
        }
    }
    
    func applyPreferences(){
        for key in preferences.keys{
            for dishName: String in preferences[key]!{
                for dish in restaurants[key]!{
                    if dish.name == dishName {
                        dish.like = true
                        dish.dealtWith = true
                    }
                }
            }
        }
    }
    
    func applyDislikes(){
        for key in dislikes.keys{
            for dishName: String in dislikes[key]!{
                for dish in restaurants[key]!{
                    if dish.name == dishName{
                        dish.dealtWith = true
                    }
                }
            }
        }
    }
    
    
    func makeRestauranten() {
        for restaurant: RestProfile in restauranto{
            restauranten[restaurant] = restaurants[restaurant.name]
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            self.deletePreferenceList()
            allPreferenceListViewController.restaurants = restaurants
            allPreferenceListViewController.menu = menu
        }
    }
    

    
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
    Update the preference list with data pulled in parse
    */
    func addToPreferenceList(restaurant: String, dishName: String){
        for dish: Dish in restaurants[restaurant]!{
            if dish.name == dishName {
                dish.like = true
                dish.dealtWith = true
            }
        }
    }
    
    
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
                                        self.addToDealtWith(restaurant, dishName: dishName)
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
    Update the preference list with data pulled in parse
    */
    func addToDealtWith(restaurant: String, dishName: String){
        for dish: Dish in restaurants[restaurant]!{
            if dish.name == dishName {
                dish.dealtWith = true
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
                                pFObject.delete()
                            }
                        }
                    }
                }
            }
        }
    }
    
}

