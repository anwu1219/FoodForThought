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

protocol updatePreferenceListDelegate{
    func updatePreference(preferenceList: [String: [Dish]])
}

protocol updateFoodTinderPreferenceListDelegate{
    func updatePreferences(preferenceList: [Dish])
}

class MainMenuViewController: UIViewController, updatePreferenceListDelegate, updateFoodTinderPreferenceListDelegate {
    
    var menu : [Dish]!
    var restaurants : [String: [Dish]]!
    var preferenceListLoad = [String: [Dish]]()
    var preferenceList = [String: [Dish]]()
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
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            PFUser.logOut()
            signUpViewControllerDelegate?.clearTextField()
        }
    }
    
    
    
    func addKeysToPreferenceList(keys: [String]){
        for key in keys{
            preferenceList[key] = []
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
            foodTinderViewController.foodTinderDelegate = self
        }
        if segue.identifier == "mainToRestaurantsSegue" {
            let restMenuViewController = segue.destinationViewController as! RestMenuViewController
            menu.sort({$0.name<$1.name})
            restMenuViewController.menu = menu
            restMenuViewController.restaurants = restaurants
            restMenuViewController.delegate = self
        }
        if segue.identifier == "mainToAllPreferencesSegue"{
            let allPreferenceListViewController = segue.destinationViewController as! AllPreferenceListViewController
            println(preferenceList)
            allPreferenceListViewController.preferenceListLoad = preferenceList
            allPreferenceListViewController.preferenceListFromParse = preferenceListLoad
        }
    }
    
    func updatePreferences(preferenceListLoad:[Dish]){
    
        for dish: Dish in preferenceListLoad {
            if !contains(preferenceList.keys, dish.location!) {
                preferenceList[dish.location!] = []
            }
            
            preferenceList[dish.location!]?.append(dish)
        }
    }
    

    
    
    /**
    delegate function that pass the preferencelist back from restaurant menu view controller and merge with the preference list in main
    */
    func updatePreference(preferenceList: [String: [Dish]]){
        
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
        println(dishName)
        if !contains(self.preferenceListLoad.keys, restaurant) {
            preferenceListLoad[restaurant] = [Dish]()
        }
        for dish: Dish in restaurants[restaurant]!{
            if dish.name == dishName {
                preferenceListLoad[restaurant]?.append(dish)
                dish.like = true
            }
        }
    }
}

