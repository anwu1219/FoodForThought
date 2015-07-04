//
//  FoodTinderViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 29/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

//extension to shuffle a mutating array
//from http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}


// A protocol that the TableViewCell uses to inform its delegate of state change
protocol FoodTinderViewCellDelegate {
    /**
    indicates that the given item has been deleted
    */
    func toDoItemDeleted(dish: Dish)
    
    
    /**
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    func viewDishInfo(dish: Dish)
    
    func addToPreferenceList(dish: Dish)
    
    func addToDislikes(dish: Dish)
}



class FoodTinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FoodTinderViewCellDelegate {
    
    @IBOutlet weak var foodTinderTableView: UITableView!
    
    var menuLoad : [Dish]?
    var menu = [Dish]()
    let styles = Styles()
    var preferences = [Dish]()
    var disLikes = [Dish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTinderTableView.dataSource = self
        foodTinderTableView.delegate = self
        foodTinderTableView.registerClass(FoodTinderTableViewCell.self, forCellReuseIdentifier: "tinderCell")
        foodTinderTableView.separatorStyle = .SingleLine
        //tableView.backgroundColor = UIColor.blackColor()
        //foodTinderTableView.backgroundView = styles.backgroundImage
        //tableView.backgroundView?.contentMode = .ScaleAspectFill
        foodTinderTableView.rowHeight = 600;
        //self.createMenu()
        
        if let menuLoad = menuLoad {
            for dish in menuLoad {
                menu.append(dish)
                }
        }
        //shuffles the dishes for the tinder swiping
        menu.shuffle()
        
        //filters menu from dishes that have already been swiped
        menu = menu.filter({$0.dealtWith != true})
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            //upload data to parse
            self.uploadPreferenceList()
            self.uploadDislikes()
        }
    }

    
    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Fisher-Yates function to get random dishes into the tinder swiper
    //From http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
    func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let c = count(list)
        if c < 2 { return list }
        for i in 0..<(c - 1) {
            let j = Int(arc4random_uniform(UInt32(c - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }
    
    
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            //initiates the cell
            let cell = tableView.dequeueReusableCellWithIdentifier("tinderCell", forIndexPath: indexPath) as! FoodTinderTableViewCell
            
            //
            cell.delegate = self
            cell.selectionStyle = .None
            
            //passes a dish to each cell
            let dish = menu[indexPath.row]
            cell.dish = dish
            
            //sets the image
            cell.imageView?.image = dish.image
           // cell.imageView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
          //  cell.imageView?.clipsToBounds = true

            return cell
    }
    
    
    //MARK: - Table view cell delegate
    /**
    Delegate function that finds and deletes the dish that is swiped
    */
    func toDoItemDeleted(dish: Dish) {
        //Finds index of swiped dish and removes it from the array
        var index = find(menu, dish)!
        //menu.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        foodTinderTableView.beginUpdates()
        self.menu.removeAtIndex(index)
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        foodTinderTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        foodTinderTableView.endUpdates()
    }
    
    
    func addToPreferenceList(dish: Dish){
        preferences.append(dish)
    }
    
    
    func addToDislikes(dish: Dish) {
        disLikes.append(dish)
    }
    
    /**
    Delegate function that segues between the dish cells and the dish info view
    */
    func viewDishInfo(selectedDish: Dish) {
        performSegueWithIdentifier("mealInfoSegue", sender: selectedDish)
    }

    
    
    // MARK: - Table view delegate
    //    func colorForIndex(index: Int) -> UIColor {
    //        let itemCount = menu.count - 1
    //        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
    //        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    //    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 0.7)//colorForIndex(indexPath.row)
    }
    
    
    // support for versions of iOS prior to iOS 8
    func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat {
            return tableView.rowHeight;
    }
    
    
    /**
    Prepares for segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segues to single dish info
        if segue.identifier == "foodTinderSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(menu, selectedMeal) {
                // Sets the dish info in the new view to selected cell's dish
                mealInfoViewController.dish = menu[index]
            }
        }
    }
    
    
    /**
    Uploads the preference list
    */
    func uploadPreferenceList(){
        for dish: Dish in preferences {
            if let user = PFUser.currentUser(){
                let newPreference = PFObject(className:"Preference")
                newPreference["createdBy"] = PFUser.currentUser()
                newPreference["dishName"] = dish.name
                newPreference["location"] = dish.location
                newPreference.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                })
            }
        }
    }
    
    func uploadDislikes(){
        for dish: Dish in disLikes {
            if let user = PFUser.currentUser(){
                let newPreference = PFObject(className:"Disliked")
                newPreference["createdBy"] = PFUser.currentUser()
                newPreference["dishName"] = dish.name
                newPreference["location"] = dish.location
                newPreference.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                })
            }
        }
    }
    
    
}