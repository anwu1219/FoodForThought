//
//  allPreferenceListViewController.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 6/29/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class AllPreferenceListViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate {
    
    
    @IBOutlet weak var preferenceListTableView: UITableView!
    var preferenceListLoad: [String: [Dish]]?
    var preferenceListFromParse: [String: [Dish]]!
    var preferenceList = [String: [Dish]]()
    var keys = [String]()
    var delegate: PreferenceListViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(preferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.separatorStyle = .SingleLine
        preferenceListTableView.backgroundColor = UIColor.blackColor()
        preferenceListTableView.rowHeight = 100;
        if let preferenceListLoad = preferenceListLoad {
            preferenceList = preferenceListLoad
        }
        for key: String in preferenceListFromParse.keys {
            if !contains(preferenceList.keys, key){
                preferenceList[key] = [Dish]()
            }
            for dish: Dish in preferenceListFromParse[key]!{
                if !contains(preferenceList[key]!, dish){
                    preferenceList[key]!.append(dish)
                }
            }
        }
        
        keys = preferenceList.keys.array
        keys.sort({$0 < $1})
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            println("This VC is 'will' be popped. i.e. the back button was pressed.")
        }
    }
    
    
    //number of section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return preferenceList.keys.array.count //can be customized to number of restuarant
        }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferenceList[keys[section]]!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! preferenceListTableViewCell
        let key = keys[indexPath.section]
        if let preferences = preferenceList[key]{
            let dish = preferences[indexPath.row]
            cell.textLabel?.text = dish.name
            cell.delegate = self
            cell.selectionStyle = .None
            cell.dish = dish
            cell.imageView?.image = dish.image
        }
        return cell
            
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    
    func viewDishInfo(selectedDish: Dish) {
        performSegueWithIdentifier("preferenceInfoSegue", sender: selectedDish)
    }
    
    
    func toDoItemDeleted(dish: Dish){
//        //Finds index of swiped dish and removes it from the array
//        var index = find(preferences, dish)!
//        preferences.removeAtIndex(index)
//        
//        // use the UITableView to animate the removal of this row
//        preferenceListTableView.beginUpdates()
//        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
//        preferenceListTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
//        preferenceListTableView.endUpdates()
    }
    
    
    func addToPreferences(dish: Dish) {
        
    }
    
    func deleteFromPreferences(dish: Dish) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "preferenceInfoSegue" {
//            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
//            let selectedMeal = sender! as! Dish
//            if let index = find(preferences, selectedMeal) {
//                mealInfoViewController.dish = preferences[index]
//            }
//        }
    }
}