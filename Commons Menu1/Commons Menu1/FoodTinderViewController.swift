//
//  FoodTinderViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 29/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse


// A protocol that the TableViewCell uses to inform its delegate of state change
protocol FoodTinderViewCellDelegate {
    
    //indicates that the given item has been deleted
    func toDoItemDeleted(dish: Dish)
    
    //indicates which item has been selected and provide appropriate information for a segue to dish info
    //  func viewDishInfo(dish: Dish)
    
    func uploadPreference(dish: Dish)
    
    func uploadDislike(dish: Dish)
}


class FoodTinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FoodTinderViewCellDelegate {
    
    @IBOutlet weak var foodTinderTableView: UITableView!
    @IBOutlet var foodTinderView: UIView!
    
    var dishes: Dishes!
    var menu = [Dish]()
    let styles = Styles()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var edited = false
    let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let preparingAlert = UIAlertController(title: "Preparing...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let completeAlert = UIAlertController(title: "You have swiped all the dishes! Bravo!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    var ecoLabelsArray: [String]!
    //let ecoLabelScrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTinderTableView.dataSource = self
        foodTinderTableView.delegate = self
        foodTinderTableView.registerClass(FoodTinderTableViewCell.self, forCellReuseIdentifier: "tinderCell")
        foodTinderTableView.separatorStyle = .SingleLine
        //foodTinderTableView.backgroundView = styles.backgroundImage
        //tableView.backgroundView?.contentMode = .ScaleAspectFill
        foodTinderTableView.rowHeight = screenSize.height;
        
        
        foodTinderTableView.backgroundColor = UIColor.clearColor()
        //foodTinderView.backgroundColor = UIColor(patternImage: UIImage(named: "DishLevelPagebackground")!)
        
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "DishLevelPagebackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        foodTinderTableView.layer.cornerRadius = 5
        
        
        if let ecoLabelsArray = ecoLabelsArray {
            //       var keys = ecoLabelsArray.keys.array
            //       keys.sort({$0.name < $1.name})
            //       placeEcoLabels(keys)
        }
        
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        foodTinderTableView.addSubview(refreshControl)
        
        var logButton = UIBarButtonItem(title: "My Preferences", style: UIBarButtonItemStyle.Plain, target: self, action: "viewPreferences:")
        self.navigationItem.rightBarButtonItem = logButton
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.sendActionsForControlEvents(.ValueChanged)
    }
    
    
    func viewPreferences(button: UIBarButtonItem?){
        performSegueWithIdentifier("tinderToAllPreferencesSegue", sender: button)
    }
    
    
    
    func refresh(refreshControl: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            if dishes.dealtWith.count != dishes.numberOfDishes{
                self.fetchRandomDishes(self.dishes.numberOfDishes)
            } else {
                presentViewController(completeAlert, animated: true, completion: nil)
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 2))
                dispatch_after(delayTime, dispatch_get_main_queue()){
                    self.completeAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    })
                }
            }
        } else{
            noInternetAlert("Unable to Get New Food for Thought")
            refreshControl.endRefreshing()
        }
    }
    
    
    func placeEcoLabels(keys: [Label]) {
        for i in 0..<keys.count {
            var image = UIImage()
            var downAlign: CGFloat = 20
            // Sets the size and position of the button
            var width: CGFloat = 25
            var height: CGFloat = 25
            var x: CGFloat = (50 + (0.5 * width))
            var y: CGFloat = (height+10) * CGFloat(i)
            //       image.frame = CGRectMake(x - 40, y + 10, 250, 46)
            //image.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.75, alpha: 0.95)
            
            //Sets the content of the buttons
            
            // let backgroundImage = Label()
            // backgroundImage.frame = image.frame
            
            //       ecoLabelScrollView.addSubview(button)
            //       ecoLabelScrollView.addSubview(backgroundImage)
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
            //cell.imageView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            
            
            return cell
    }
    
    //MARK: - Table view cell delegate
    /**
    Delegate function that finds and deletes the dish that is swiped
    */
    func toDoItemDeleted(dish: Dish) {
        //Finds index of swiped dish and removes it from the array
        edited = true
        // use the UITableView to animate the removal of this row
        var index = find(self.menu, dish)!
        self.dishes.addToDealtWith(dish.index)
        self.foodTinderTableView.beginUpdates()
        self.menu.removeAtIndex(index)
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        self.foodTinderTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        let delay =  0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.refreshControl.sendActionsForControlEvents(.ValueChanged)
        }
        foodTinderTableView.endUpdates()
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 0.7)//colorForIndex(indexPath.row)
    }
    
    
    // support for versions of iOS prior to iOS 8
    func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat {
            return tableView.rowHeight;
    }
    
    
    func fetchRandomDishes(numberOfDishes: Int) -> Int{
        var query = PFQuery(className:"dishInfo")
        var randomIndex = Int(arc4random_uniform(UInt32(numberOfDishes)))
        while dishes.pulled.contains(randomIndex){
            while dealtWith(randomIndex){
                randomIndex = Int(arc4random_uniform(UInt32(numberOfDishes)))
            }
        }
        query.whereKey("index", equalTo: randomIndex)
        query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if let object = object {
                if let index = object["index"] as? Int{
                    if let name = object["name"] as? String {
                        if let location = object["location"] as? String{
                            if let ingredients = object["ingredients"] as? [String]{
                                if let labels = object["labels"] as? [[String]]{
                                    if let type = object["type"] as? String{
                                        if let susLabels = object["susLabels"] as? [String]{
                                            if let price = object["price"] as? String{
                                        if let userImageFile = object["image"] as? PFFile{
                                            userImageFile.getDataInBackgroundWithBlock {
                                                (imageData: NSData?, error: NSError?) ->Void in
                                                if error == nil {
                                                    if let data = imageData{                                                if let image = UIImage(data: data){
                                                    if !self.hasBeenAdded(name, location: name){
                                                        let dish = Dish(name: name, image: image, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels)
                                                        self.dishes.addDish(location, dish: dish)
                                                        self.menu.append(dish)
                                                        self.dishes.addPulled(index)
                                                        UIView.transitionWithView(self.foodTinderTableView, duration:0.5, options:.TransitionFlipFromTop,animations: { () -> Void in
                                                            self.foodTinderTableView.reloadData() }, completion: nil)

                                                    }
                                                    }
                                                    }
                                                }
                                            }
                                        } else{
                                            if !self.hasBeenAdded(name, location: name){
                                                let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels)
                                                self.dishes.addDish(location, dish: dish)
                                                self.menu.append(dish)
                                                self.dishes.addPulled(index)
                                                UIView.transitionWithView(self.foodTinderTableView, duration:0.5, options:.TransitionFlipFromTop,animations: { () -> Void in
                                                    self.foodTinderTableView.reloadData() }, completion: nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    }
                    }
                }
            }
        })
        return randomIndex
    }
    
    
    
    func dealtWith(index: Int) -> Bool {
        return contains(dishes.dealtWith, index)
    }
    
    
    func hasBeenAdded(name : String, location: String)-> Bool {
        for restaurant in dishes.dishes.keys{
            if restaurant.name == location{
                for dish: Dish in dishes.dishes[restaurant]!{
                    if dish.name == name {
                        return true
                    }
                }
            }
        }
        return false
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
        if segue.identifier == "tinderToAllPreferencesSegue"{
            let allPreferenceListViewController = segue.destinationViewController as! AllPreferenceListViewController
            allPreferenceListViewController.dishes = dishes
        }
    }
}