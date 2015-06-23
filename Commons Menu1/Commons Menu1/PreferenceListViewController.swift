//
//  PreferenceListViewController.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/18/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class PreferenceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate {
    

    @IBOutlet weak var preferenceListTableView: UITableView!
    //var dishPreferences = Bunduru().Commons
    
    var preferences: [Dish]!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(preferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.separatorStyle = .SingleLine
        preferenceListTableView.backgroundColor = UIColor.blackColor()
        preferenceListTableView.rowHeight = 100;
    }
    
    //number of section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //can be customized to number of restuarant
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return preferences.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! preferenceListTableViewCell
        let dish = preferences[indexPath.row]
        cell.textLabel?.text = dish.name
        cell.delegate = self
        cell.selectionStyle = .None
        cell.dish = dish

//        var cell = UITableViewCell()
//        cell.textLabel?.text = "Hey!"
        
        var sloth = UIImage(named: "sloth")
        cell.imageView?.image = sloth
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Commons"
    }
    
    func viewDishInfo(selectedDish: Dish) {
        println("delegate function was called")
        performSegueWithIdentifier("preferenceInfoSegue", sender: selectedDish)
    }
    
    func toDoItemDeleted(dish: Dish){
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "preferenceInfoSegue" {
            println("    Entered the prepare for segue method")
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(preferences, selectedMeal) {
                mealInfoViewController.dish = preferences[index]
                println("The item passed is: \(selectedMeal.name)")
            }
            else {
                println("item was not found")
            }
        }
    }
}