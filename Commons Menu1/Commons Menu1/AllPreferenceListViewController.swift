//
//  allPreferenceListViewController.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 6/29/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse


protocol PreferenceMenuTableViewCellDelegate{
    /**
    indicates that the given item has been deleted
    */
    func toDoItemDeleted(dish: Dish)
    
    /**
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    func viewDishInfo(dish: Dish)
}


/**
Class that shows all the preferences of the current user
*/
class AllPreferenceListViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, PreferenceMenuTableViewCellDelegate, TypesTableViewCellDelegate {
    private let allPrefTopImage = UIImageView()
    private let preferenceListTableView = UITableView()
    private var preferences = [String: [Dish]]()
    var dishes : Dishes!
    private var keys = [String]()
    private let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    private var edited = false
    private var indexTitles = [String]()
    private let menuSwipeScroll = UIScrollView()
    private let typesTableView = UITableView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Formats the table view
        self.automaticallyAdjustsScrollViewInsets = false;
        //sets nav bar to be see through
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        //sets background image
        setBackground("preferenceBackground")
        
        
        allPrefTopImage.image = UIImage(named: "redberrycup")
        allPrefTopImage.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 0.23 * self.view.frame.height)
        
        view.addSubview(allPrefTopImage)
        
        menuSwipeScroll.frame = CGRect(x: 0.05 * view.frame.width, y: 0.25 * view.frame.height, width: 0.9 * view.frame.width, height: 0.75 * view.frame.height)
        menuSwipeScroll.backgroundColor = UIColor.clearColor()
        menuSwipeScroll.contentSize = CGSize(width: 1.66 * menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: false)
        menuSwipeScroll.scrollEnabled = false
        view.addSubview(menuSwipeScroll)
        
        typesTableView.dataSource = self
        typesTableView.delegate = self
        typesTableView.registerClass(TypesTableViewCell.self, forCellReuseIdentifier: "typeCell")
        typesTableView.separatorStyle = .None

        //bottom border between top image and table view
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: allPrefTopImage.frame.size.height - width + 55, width:  allPrefTopImage.frame.size.width, height: allPrefTopImage.frame.size.height)
        border.borderWidth = width
        allPrefTopImage.layer.addSublayer(border)
        allPrefTopImage.layer.masksToBounds = true
        self.navigationController?.navigationBar.translucent = true
        
        
        let myPreferenceLabel = UILabel()
        //Formats the labels in the view controller
        myPreferenceLabel.text = "My Favorites"
        myPreferenceLabel.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 0.07 * self.view.frame.width)
        myPreferenceLabel.sizeToFit()
        myPreferenceLabel.shadowColor = UIColor.blackColor()
        myPreferenceLabel.shadowOffset = CGSizeMake(2, 2)
        myPreferenceLabel.textColor = UIColor.whiteColor()
        myPreferenceLabel.backgroundColor = UIColor.clearColor()
        myPreferenceLabel.frame = CGRect(x : 0.05 * view.frame.width, y: 0.15 * view.frame.height, width: 0.7 * view.frame.width, height: 0.08 * view.frame.height)
        
        view.addSubview(myPreferenceLabel)
        
        preferenceListTableView.layer.borderColor = UIColor(red: 132/255.0, green: 88/255.0, blue: 88/255.0, alpha: 1).CGColor
        preferenceListTableView.layer.borderWidth = 2.0
        

        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        preferenceListTableView.registerClass(PreferenceListTableViewCell.self, forCellReuseIdentifier: "cell")
        preferenceListTableView.scrollEnabled = true
        preferenceListTableView.separatorStyle = .SingleLine
        preferenceListTableView.rowHeight = 85;
        preferenceListTableView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        self.addToPreferences()
        keys = preferences.keys.array
        keys.sort({$0 < $1})
        for key: String in keys {
            preferences[key]!.sort({$0.name < $1.name})
        }
        
        addTable()
    }
    
    func addTable(){
        let xUnit : CGFloat = self.menuSwipeScroll.frame.width / 100
        let yUnit : CGFloat = self.menuSwipeScroll.frame.height / 100

        
        typesTableView.frame = CGRect(x: 0 * xUnit, y: 0, width: 60 * xUnit, height: menuSwipeScroll.frame.height)
        typesTableView.backgroundColor = UIColor.clearColor()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "bringBack:")
        typesTableView.addGestureRecognizer(tapRecognizer)
        menuSwipeScroll.addSubview(typesTableView)

        preferenceListTableView.frame = CGRect(x: 66 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        preferenceListTableView.backgroundColor = UIColor.clearColor()
        preferenceListTableView.backgroundView?.contentMode = .ScaleAspectFill
        preferenceListTableView.rowHeight = 85
        menuSwipeScroll.addSubview(preferenceListTableView)
    }
    
    
    
    func bringBack(sender: AnyObject){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
    }
    
    
    
    /**
    Uploads the preference list when moving to parse
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if edited {
            presentViewController(savingAlert, animated: true, completion: nil)
            self.uploadPreferences()
            let param = Double(self.preferences.keys.array.count) * 0.3
            let delay =  param * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            }
            self.savingAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    
    /**
    Add liked dishes to preferences
    */
    func addToPreferences(){
        for key in dishes.dishes.keys {
            if !contains(preferences.keys.array, key.name){
                preferences[key.name] = [Dish]()
            }
            for dish: Dish in dishes.dishes[key]!{
                if dish.like {
                    preferences[key.name]?.append(dish)
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
            if tableView == preferenceListTableView {
                return preferences.keys.array.count //can be customized to number of restuarant
            } else {
                return 1
            }
        }
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == preferenceListTableView {
            return preferences[keys[section]]!.count
        } else {
            return preferences.keys.array.count
        }
    }
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // initiates a cell
        if tableView == preferenceListTableView {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PreferenceListTableViewCell
        // passes data to each cell
        let key = keys[indexPath.section]
        if let preferences = preferences[key]{
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
           // cell.detailTextLabel?.font =  UIFont(name: "Helvetica Neue", size: 20)
           // cell.detailTextLabel?.textAlignment = .Center
        }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as! TypesTableViewCell
            cell.delegate = self
            cell.textLabel!.text = keys[indexPath.row]
            cell.textLabel!.backgroundColor = UIColor.clearColor()
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor(white: 0.667, alpha: 0.2)
            return cell
        }
    }
    
    
    /**
    Returns the title of each section
    */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == preferenceListTableView {
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.width / 8)
        headerView.backgroundColor = UIColor(red: 153/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
        headerView.layer.borderColor = UIColor(red: 116/255.0, green: 70/255.0, blue: 37/255.0, alpha: 0.75).CGColor
        headerView.layer.borderWidth = 1.0
        
        let xUnit = headerView.frame.width / 100
        let yUnit = headerView.frame.height / 100
        
        
        let sectionsButton = UIButton(frame: CGRect(x: 2 * xUnit, y: 25 * yUnit, width: 9 * xUnit, height: 50 * yUnit))
        sectionsButton.addTarget(self, action: "showSections:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Set the image of sections button
        sectionsButton.setImage(UIImage(named: "ArrowDropdownButton"), forState: UIControlState.Normal)
        
        
        
        let headerViewLabel = UILabel()
        headerViewLabel.frame = CGRectMake(12 * xUnit, 0, 76 * xUnit, tableView.frame.width / 8)
        headerViewLabel.text = keys[section]
        headerViewLabel.textAlignment = .Center
        headerViewLabel.textColor = UIColor.whiteColor()
        headerViewLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
       
        headerView.addSubview(sectionsButton)
        headerView.addSubview(headerViewLabel)
        
        return headerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == preferenceListTableView {
            return tableView.frame.width / 8
        }
        return 0
    }
    
    
    
    
    func showSections(sender: AnyObject){
        self.menuSwipeScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
        self.dishes.removeFromDealtWith(dish.index)
        // use the UITableView to animate the removal of this row
        let index = find(preferences[dish.location]!, dish)
        preferences[dish.location]!.removeAtIndex(index!)
        preferenceListTableView.beginUpdates()
        //Finds index of swiped dish and removes it from the array
        let indexPathForRow = NSIndexPath(forRow: index!, inSection: find(keys, dish.location)!)
        preferenceListTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        if preferences[dish.location]!.isEmpty {
            preferences.removeValueForKey(dish.location)
            let indexSet = NSIndexSet(index: find(keys, dish.location)!)
            preferenceListTableView.deleteSections(indexSet, withRowAnimation: .Fade)
            keys = preferences.keys.array
            keys.sort({$0 < $1})
        }
        preferenceListTableView.endUpdates()
    }

    
    /**
    Uploads the preference list
    */
    func uploadPreferences(){
        if let currentUser = PFUser.currentUser(){
            let user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            let query = PFQuery(className:"Preference")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                pFObject.deleteInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                                })
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
                        })
                    }
                }
            }
        }
        }
    }
    
    
    // TypeDelegate
    func goToType(type: String){
        let index = find(keys, type)!
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
        dispatch_after(delayTime, dispatch_get_main_queue()){
            self.preferenceListTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .Top, animated: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
        if segue.identifier == "preferenceInfoSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(preferences[selectedMeal.location]!, selectedMeal) {
                mealInfoViewController.dish = preferences[selectedMeal.location]![index]
            }
        }
    }
}