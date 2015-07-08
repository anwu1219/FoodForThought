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
    let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let saveAlert = UIAlertController(title: "Sync your preference?",
        message: "",
        preferredStyle: UIAlertControllerStyle.Alert
    )
    var edited = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Formats the table view
        self.automaticallyAdjustsScrollViewInsets = false;

        preferenceListTableView.backgroundColor = UIColor(patternImage: UIImage(named: "DishLevelPagebackground")!)
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(preferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.separatorStyle = .SingleLine
        preferenceListTableView.rowHeight = 100;
        self.addToPreferences()
        keys = preferences.keys.array
        keys.sort({$0 < $1})
        for key: String in keys {
            preferences[key]!.sort({$0.name < $1.name})
        }
        saveAlert.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Default,
            handler: nil
            )
        )
        saveAlert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.uploadPreferences()}
            )
        )

    }
    
    
    /**
    Uploads the preference list when moving to parse
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if edited {
            presentViewController(savingAlert, animated: true, completion: nil)
            //println("This VC is 'will' be popped. i.e. the back button was pressed.")
            //presentViewController(saveAlert, animated: true, completion: nil)
            self.uploadPreferences()
            let param = Double(self.preferences.keys.array.count) * 0.3
            let delay =  param * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.savingAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            })
            }
        }
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
        edited = true
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
    
    
    func edit(){
        
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
        let param = Double(self.preferences.keys.array.count) * 0.25
        let delay =  param * Double(NSEC_PER_SEC)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
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