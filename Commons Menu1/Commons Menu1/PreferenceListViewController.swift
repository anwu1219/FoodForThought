//
//  PreferenceListViewController.swift
//  Commons Menu1
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
        preferenceListTableView.rowHeight = 100;
        self.navigationController?.navigationBar.translucent = true

        
        //set background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "preferenceBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
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
        cell.imageView?.image = dish.image

        return cell
    }
    
    /**
    Sets the title of the table view subtitle
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if preferences.count == 0 {

            return "No Dishes in your Preference list"
        }
        else {
            return location! + " Preferences"
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