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
    
    //indicates that the given item has been deleted
    func toDoItemDeleted(dish: Dish)
   
    //indicates which item has been selected and provide appropriate information for a segue to dish info
  //  func viewDishInfo(dish: Dish)
    
    func addToPreferenceList(dish: Dish)
    
    func addToDislikes(dish: Dish)
}



class FoodTinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FoodTinderViewCellDelegate {
    
    @IBOutlet weak var foodTinderTableView: UITableView!
    @IBOutlet var foodTinderView: UIView!
    
    var dishes: Dishes!
    var menuLoad : [Dish]?
    var numberOfDishes : Int!
    var menu = [Dish]()
    let styles = Styles()
    var preferences = [Dish]()
    var disLikes = [Dish]()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var edited = false
    let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    var ecoLabelsArray: [String]!
    //let ecoLabelScrollView: UIScrollView!

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



        //self.createMenu()
        
        if let menuLoad = menuLoad {
            for dish in menuLoad {
                menu.append(dish)
                }
        }
        //shuffles the dishes for the tinder swiping
        menu.shuffle()
        
        if let ecoLabelsArray = ecoLabelsArray {
     //       var keys = ecoLabelsArray.keys.array
     //       keys.sort({$0.name < $1.name})
     //       placeEcoLabels(keys)
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

    
    
    
    /**
    Uploads preferences and dislikes
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            //upload data to parse
            if edited {
                presentViewController(savingAlert, animated: true, completion: nil)
                self.uploadPreferenceList()
                self.uploadDislikes()
                let param = Double(self.preferences.count) * 0.05 + Double(self.disLikes.count) * 0.05
                let delay =  param * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                }
                self.savingAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
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
        self.dishes.addToDealtWith(dish.index)
        //Finds index of swiped dish and removes it from the array
        var index = find(menu, dish)!
        //menu.removeAtIndex(index)
        edited = true
        // use the UITableView to animate the removal of this row
        foodTinderTableView.beginUpdates()
        self.menu.removeAtIndex(index)
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        foodTinderTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        foodTinderTableView.endUpdates()
    }
    
    
    /**
    Delegate function that adds a dish to preferences
    */
    func addToPreferenceList(dish: Dish){
        preferences.append(dish)
    }
    
    
    /**
    Delegate function that adds a dish to dislikes
    */
    func addToDislikes(dish: Dish) {
        disLikes.append(dish)
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
    
    
    /**
    Uploads the preference list
    */
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
    
    
    func fetchRandomDishes(numberOfDishes: Int, number: Int) {
        var query = PFQuery(className:"dishInfo")
        for var i = 0; i < number; i++ {
            var randomIndex = Int(arc4random_uniform(UInt32(numberOfDishes)))
            println(randomIndex)
            query.whereKey("index", equalTo: randomIndex)
            query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if let object = object {
                    if let name = object["name"] as? String {
                        if let location = object["location"] as? String{
                            if !self.dealtWith(location, name: name) {
                                if let ingredients = object["ingredients"] as? [String]{
                                    if let labels = object["labels"] as? [[String]]{
                                        if let type = object["type"] as? String{
                                            if let index = object["index"] as? Int{
                                                if let userImageFile = object["image"] as? PFFile{
                                                    userImageFile.getDataInBackgroundWithBlock {
                                                        (imageData: NSData?, error: NSError?) ->Void in
                                                        if error == nil {                               if let data = imageData{                                                if let image = UIImage(data: data){
                                                            let dish = Dish(name: name, image: image, location: location, type: type, ingredients: ingredients, labels: labels, index : index)
                                                            self.dishes.addDish(location, dish: dish)
                                                            self.menu.append(dish)
                                                            }
                                                            }
                                                        }
                                                    }
                                                } else{
                                                    let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index)
                                                    self.dishes.addDish(location, dish: dish)
                                                    self.menu.append(dish)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                i--
                            }
                        }
                    }
                }
            })
        }
    }
    
    
    func dealtWith(location: String, name: String) -> Bool {
        var key : RestProfile
        for restaurant: RestProfile in dishes.dishes.keys{
            if restaurant.name == location{
                key = restaurant
                for dish : Dish in dishes.dishes[key]!{
                    if dish.name == name {
                        if dish.like || dish.dislike{
                            return true
                        }
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

    }
}