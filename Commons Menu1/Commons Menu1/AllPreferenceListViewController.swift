//
//  allPreferenceListViewController.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 6/29/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse


/**
Class that shows all the preferences of the current user
*/
class AllPreferenceListViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate {
    
    
    @IBOutlet weak var preferenceListTableView: UITableView!
    var preferences = [String: [Dish]]()
    var restaurants : [String: [Dish]]!
    var keys = [String]()    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Formats the table view
        preferenceListTableView.backgroundColor = UIColor(patternImage: UIImage(named: "DishLevelPagebackground")!)
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(preferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.separatorStyle = .SingleLine
        preferenceListTableView.rowHeight = 100;
        self.addToPreferences()
        keys = preferences.keys.array
        keys.sort({$0 < $1})
    }
    
    
    /**
    Uploads the preference list when moving to parse
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            //println("This VC is 'will' be popped. i.e. the back button was pressed.")
            self.uploadPreferences()
        }
    }
    
    
    /**
    Add liked dishes to preferences
    */
    func addToPreferences(){
        for key in restaurants.keys.array {
            if !contains(preferences.keys.array, key){
                preferences[key] = [Dish]()
            }
            for dish: Dish in restaurants[key]!{
                if dish.like {
                    preferences[key]?.append(dish)
                }
            }
        }
        //If there is no preferences for a restaurant, the restaurant won't show up
        for key in preferences.keys{
            if (preferences[key]!.isEmpty){
                preferences.removeValueForKey(key)
            }
        }
    }
    
    
    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return preferences.keys.array.count //can be customized to number of restuarant
        }
    
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferences[keys[section]]!.count
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // initiates a cell
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! preferenceListTableViewCell
        // passes data to each cell
        let key = keys[indexPath.section]
        if let preferences = preferences[key]{
            let dish = preferences[indexPath.row]
            cell.textLabel?.text = dish.name
            cell.delegate = self
            cell.selectionStyle = .None
            cell.dish = dish
            cell.imageView?.image = dish.image
        }
        return cell
            
    }
    
    
    /**
    Returns the title of each section
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    
    //MARK: - Table view cell delegate
    /**
    Delegate function that views the dish information when the cell is pressed
    */
    func viewDishInfo(selectedDish: Dish) {
        performSegueWithIdentifier("preferenceInfoSegue", sender: selectedDish)
    }
    
    
    /**
    Delegate function that finds and deletes the dish that is swiped
    */
    func toDoItemDeleted(dish: Dish){
        //Finds index of swiped dish and removes it from the array
        var index = find(preferences[dish.location!]!, dish)
        preferences[dish.location!]!.removeAtIndex(index!)
        
        // use the UITableView to animate the removal of this row
        preferenceListTableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index!, inSection: find(keys, dish.location!)!)
        preferenceListTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        preferenceListTableView.endUpdates()
    }
    
    func addToDislikes(dish: Dish){
        
    }
    
    
    /**
    Uploads the preference list
    */
    func uploadPreferences(){
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
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
        dispatch_after(delayTime, dispatch_get_main_queue()){
        for restaurant: String in self.preferences.keys {
            for dish : Dish in self.preferences[restaurant]!{
                if dish.like{
                    if let user = PFUser.currentUser(){
                        let newPreference = PFObject(className:"Preference")
                        newPreference["createdBy"] = PFUser.currentUser()
                        newPreference["dishName"] = dish.name
                        newPreference["location"] = dish.location
                        newPreference.saveInBackgroundWithBlock({
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                println("Successfully saved")
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        })
                    }
                }
            }
        }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "preferenceInfoSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(preferences[selectedMeal.location!]!, selectedMeal) {
                mealInfoViewController.dish = preferences[selectedMeal.location!]![index]
            }
        }
    }
}