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

class FoodTinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FoodTinderViewCellDelegate {
    
    @IBOutlet weak var foodTinderTableView: UITableView!
    
    var menuLoad : [Dish]?
    var menu = [Dish]()
    var preferenceList = [Dish]()
    var menuPFObjects: [PFObject]?
    let styles = Styles()
    var queriedDishes = [Int]()
    
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
  
                        
            cell.imageView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            cell.imageView?.clipsToBounds = true

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
    
    
    /**
    Delegate function that segues between the dish cells and the dish info view
    */
    func viewDishInfo(selectedDish: Dish) {
        performSegueWithIdentifier("mealInfoSegue", sender: selectedDish)
    }
    
    
    // MARK: - PreferenceListViewControllerDelegate
    
    func revertCellToOriginalColor(dish: Dish) {
        var index = NSIndexPath(forRow:find(menu, dish)!, inSection: 0)
        println("We've made it into the revertCellToOriginalColor method")
        //self[index].backgoundColor = UIColor.clearColor()
    }
    
    func identifyDish(dish: Dish) {
        // no need to do anything in this viewcontroller
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
        
        // Segues to the preference list
        if segue.identifier  == "menuToPreferenceSegue" {
            let preferencelistViewController = segue.destinationViewController as! PreferenceListViewController
            updatePreferenceList()
            // Passes the list of liked dishes to the preference list view
            preferencelistViewController.preferences = preferenceList
        }
    }
    
    
    /**
    Updates the preferenceList  %anwu
    */
    func updatePreferenceList() {
        for dish: Dish in menu {
            //println(dish.like)
            if dish.like && !contains(preferenceList, dish){
                preferenceList.append(dish)
            }
        }
        preferenceList = preferenceList.filter{contains(self.menu, $0) && $0.like}
    }
    
}