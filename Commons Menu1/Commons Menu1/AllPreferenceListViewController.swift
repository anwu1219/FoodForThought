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
    var preferenceList = [String: [Dish]]()
    var restaurants : [String: [Dish]]!
    var keys = [String]()    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        preferenceListTableView.backgroundColor = UIColor(patternImage: UIImage(named: "DishLevelPagebackground")!)
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(preferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.separatorStyle = .SingleLine
      //preferenceListTableView.backgroundColor = UIColor.blackColor()
        preferenceListTableView.rowHeight = 100;
        self.addToPreferences()
        keys = preferenceList.keys.array
        keys.sort({$0 < $1})
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            println("This VC is 'will' be popped. i.e. the back button was pressed.")
        }
    }
    
    func addToPreferences(){
        for key in restaurants.keys.array {
            if !contains(preferenceList.keys.array, key){
                preferenceList[key] = [Dish]()
            }
            for dish: Dish in restaurants[key]!{
                if dish.like {
                    preferenceList[key]?.append(dish)
                }
            }
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
        //Finds index of swiped dish and removes it from the array
        var index = find(preferenceList[dish.location!]!, dish)
        preferenceList[dish.location!]!.removeAtIndex(index!)
        
        // use the UITableView to animate the removal of this row
        preferenceListTableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index!, inSection: find(keys, dish.location!)!)
        preferenceListTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        preferenceListTableView.endUpdates()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "preferenceInfoSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(preferenceList[selectedMeal.location!]!, selectedMeal) {
                mealInfoViewController.dish = preferenceList[selectedMeal.location!]![index]
            }
        }
    }
}