//
//  PreferenceListViewController.swift
//  Foodscape
//
//  Created by Andrew Wu on 6/18/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

/**
Shows the preference list of the current menu
*/
class PreferenceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PreferenceMenuTableViewCellDelegate {
    

    @IBOutlet weak var preferenceListTableView: UITableView!
    var dishes : Dishes!
    var preferences: [Dish]!
    var location: String!
    var delegate: MenuSwipeViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(PreferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.separatorStyle = .SingleLine
        preferenceListTableView.backgroundColor = UIColor.clearColor()
        preferenceListTableView.rowHeight = 85;
        self.navigationController?.navigationBar.translucent = true
        
        //set background image
        setBackground("preferenceBackground")
    }
    
    
    /**
    Reloads table when go back to the menu swipe view controller
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            delegate.reloadTable()
        }
    }
    
    
    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return preferences.count
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PreferenceListTableViewCell
        let dish = preferences[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .None
        cell.dish = dish
        if dish.imageFile != nil {
            dish.imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) ->Void in
                if error == nil {
                    if let data = imageData{
                        if let image = UIImage(data: data){
                            cell.imageView?.image = image
                            dish.image = image
                        }
                    }
                }
            }
        } else {
            cell.imageView?.image = UIImage(named: "sloth")
            dish.image =  UIImage(named: "sloth")
        }
        return cell
    }
    
    /**
    Sets the title of the table view subtitle
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if preferences.count == 0 {

            return "No Dishes in your Favorites list"
        }
        else {
            return location! + " Favorites"
        }
    }
    
    //MARK: - Preference table view cell delegate
    /**
    Delegate function that views the dish information view controller
    */
    func viewDishInfo(selectedDish: Dish) {
        performSegueWithIdentifier("preferenceInfoSegue", sender: selectedDish)
    }
    
    /**
    Delegate function that finds and deletes the dish that is swiped
    */
    func toDoItemDeleted(dish: Dish){
        //Finds index of swiped dish and removes it from the array
        var index = find(preferences, dish)!
        preferences.removeAtIndex(index)
        dishes.removeFromDealtWith(dish.index)
        // use the UITableView to animate the removal of this row
        preferenceListTableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        preferenceListTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        preferenceListTableView.endUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "preferenceInfoSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(preferences, selectedMeal) {
                mealInfoViewController.dish = preferences[index]
            }
        }
    }
}