//
//  MenuSwipeViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

protocol MenuSwipeViewControllerDelegate {
    func reloadTable()
}


// A protocol that the TableViewCell uses to inform its delegate of state change
protocol MenuTableViewCellDelegate {
    /**
    indicates that the given item has been deleted
    */
    func toDoItemDeleted(dish: Dish)
    
    
    /**
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    // #spchadinha
    func viewDishInfo(dish: Dish)
    
    func addToDislikes(dish: Dish)
    
}


/**
Displays menus as food tinder
*/
class MenuSwipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate, MenuSwipeViewControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restImageButton: UIButton!
   
    var menuLoad : [Dish]?
    var menu = [Dish]()
    var menuPFObjects: [PFObject]?
    let styles = Styles()
    var disLikes = [Dish]()
    var location : String?
    var restProf: RestProfile?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //restImageButton.imageView = restProf?.image
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .SingleLine
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "DishLevelPagebackground")!)

        self.automaticallyAdjustsScrollViewInsets = false;

        //tableView.backgroundColor = UIColor.blackColor()
        //tableView.backgroundView = styles.backgroundImage
        //tableView.backgroundView?.contentMode = .ScaleAspectFill
        tableView.rowHeight = 100;
        //self.createMenu()
        if let menuLoad = menuLoad {
            for dish in menuLoad {
                menu.append(dish)
            }
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            println("This VC is 'will' be popped. i.e. the back button was pressed.")
                uploadPreferenceList()
                uploadDislikes()
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
        return menu.count
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            //initiates the cell
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
    
            //
            cell.delegate = self
            cell.selectionStyle = .None
            
            //passes a dish to each cell
                let dish = menu[indexPath.row]
                cell.dish = dish
            
            //sets the image
                cell.imageView?.image = dish.image
                cell.imageView?.frame = CGRect(x: 0, y: 0, width: 35.0, height: 35.0)
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
        tableView.beginUpdates()
        self.menu.removeAtIndex(index)
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
    }
    
    
    /**
    Delegate function that segues between the dish cells and the dish info view
    */
    func viewDishInfo(selectedDish: Dish) {
        performSegueWithIdentifier("mealInfoSegue", sender: selectedDish)
    }
    
    
    /**
    Delegate function that add dish to dislikes when it's deleted
    */
    func addToDislikes(dish: Dish) {
        disLikes.append(dish)
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
        if segue.identifier == "mealInfoSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
                if let index = find(menu, selectedMeal) {
                // Sets the dish info in the new view to selected cell's dish
                    mealInfoViewController.dish = menu[index]
            }
        }
        // Segues to the preference list of the single menu
        if segue.identifier  == "menuToPreferenceSegue" {
            let preferencelistViewController = segue.destinationViewController as! PreferenceListViewController
            // Passes the list of liked dishes to the preference list view
            preferencelistViewController.preferences = createPreferenceList()
            preferencelistViewController.location = location
            preferencelistViewController.delegate = self
        }
    }
    

    func createPreferenceList() -> [Dish] {
        var preferences = [Dish]()
        for dish: Dish in menu {
            if dish.like {
                preferences.append(dish)
            }
        }
        return preferences
    }
    
    func reloadTable() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    
    
    /**
    Uploads the preference list
    */
    func uploadPreferenceList(){
        for dish: Dish in menu {
            if dish.like{
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
