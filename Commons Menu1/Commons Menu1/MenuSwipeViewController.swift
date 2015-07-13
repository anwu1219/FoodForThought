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
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    // #spchadinha
    func viewDishInfo(dish: Dish)
    
    func addToDislikes(dish: Dish)
    
    func edit()
    
    func handleDealtWithOnLike(dish: Dish)
    
    
    func handleDealtWithOnDislike(dish : Dish)
}


/**
Displays menus as food tinder
*/
class MenuSwipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate, MenuSwipeViewControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restImageButton: UIButton!
    @IBOutlet weak var restPhoneNumbLabel: UILabel!
    @IBOutlet weak var restAddressLabel: UILabel!
    @IBOutlet weak var restWeekdayOpenHoursLabel: UILabel!
    @IBOutlet weak var restWeekendOpenHoursLabel: UILabel!
       
    
    var menu = [String : [Dish]]()
    var dishes : Dishes!
    let styles = Styles()
    var disLikes = [Dish]()
    var types = [String]()
    var restProf: RestProfile!
    var edited = false
    
    let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let savedAlert = UIAlertController(title: "Saved", message: "", preferredStyle: UIAlertControllerStyle.Alert)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Formats the labels in the view controller
        restImageButton.setImage(restProf.image, forState: .Normal)
        restWeekdayOpenHoursLabel.text = restProf!.weekdayHours
        restWeekendOpenHoursLabel.text = restProf!.weekendHours
        restWeekdayOpenHoursLabel.numberOfLines = 2
        restWeekendOpenHoursLabel.numberOfLines = 2
        
        restPhoneNumbLabel.text = restProf!.phoneNumber
        restAddressLabel.text = restProf!.address
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .SingleLine
       // tableView.backgroundColor = UIColor(patternImage: UIImage(named: "DishLevelPagebackground")!)
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.blackColor().CGColor

        self.automaticallyAdjustsScrollViewInsets = false;

        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = styles.backgroundImage
        tableView.backgroundView?.contentMode = .ScaleAspectFill
        tableView.rowHeight = 100;
        if let dishes = dishes {
            self.makeMenu(dishes.dishes[restProf]!)
        }
        types = menu.keys.array
        types.sort({$0 < $1})
        for type: String in types {
            menu[type]!.sort({$0.name < $1.name})
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        if Reachability.isConnectedToNetwork() == true {
            self.refresh(refreshControl)
        }
    }
    
    
    func refresh(refreshControl: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() == true {
            self.addDishWithLocation(restProf.name)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
            dispatch_after(delayTime, dispatch_get_main_queue()){
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        } else {
             let alert = UIAlertController(title: "Internet Connection Required", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
            dispatch_after(delayTime, dispatch_get_main_queue()){
                alert.dismissViewControllerAnimated(true, completion: { () -> Void in
            
                })
            }
        }
    }


    func addDishWithLocation(location: String){
        var query = PFQuery(className:"dishInfo")
        query.whereKey("location", equalTo: location)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil{
                if let objectsArray = objects{
                    for object: AnyObject in objectsArray{
                        if let name = object["name"] as? String {
                            if let location = object["location"] as? String{
                                if self.hasBeenAdded(name, location: location) {
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
                                                                }
                                                                }
                                                            }
                                                        }
                                                    } else{
                                                        let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index)
                                                        self.dishes.addDish(location, dish: dish)
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
        }
    }
    
    
    func hasBeenAdded(name : String, location: String)-> Bool {
        var rest : RestProfile? = nil
        for restaurant: RestProfile in dishes.dishes.keys{
            if restaurant.name == location{
                rest = restaurant
            }
        }
        for dish: Dish in dishes.dishes[rest!]!{
            if dish.name == name {
                return false
            }
        }
        return true
    }
    
    
    /**
    Uploads preferences and dislikes to parse when go back
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if edited {
            println("This VC is 'will' be popped. i.e. the back button was pressed.")
                presentViewController(savingAlert, animated: true, completion: nil)
                        //println("This VC is 'will' be popped. i.e. the back button was pressed.")
                        //presentViewController(saveAlert, animated: true, completion: nil)
                self.uploadPreferenceList(restProf.name)
                self.uploadDislikes(restProf.name)
                let param = Double(self.menu.count) * 0.05
                let delay =  param * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                    }
                }
            }
        self.savingAlert.dismissViewControllerAnimated(true, completion: { () -> Void in

        })
    }
    
    
    func makeMenu(inputMenu : [Dish]){
        for dish : Dish in inputMenu {
            if !contains(menu.keys, dish.type){
                menu[dish.type] = [Dish]()
            }
            menu[dish.type]?.append(dish)
        }
    }
    
    
    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menu.keys.array.count
    }
    
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[types[section]]!.count
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            //initiates the cell
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            //passes a dish to each cell
            let type = types[indexPath.section]
            if let dishes = menu[type]{
                let dish = dishes[indexPath.row]
                cell.dish = dish
            //sets the image
                cell.imageView?.image = dish.image
             //   cell.imageView?.frame = CGRect(x: 0, y: 0, width: 35, height: 35.0)
            }
            return cell
    }
    
    
    /**
    Returns the title of each section
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return types[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewLabel = UILabel()
        headerViewLabel.frame = CGRectMake(0, 0, tableView.frame.size.width, 100)
        headerViewLabel.backgroundColor = UIColor(red: 122/255.0, green: 118/255.0, blue: 162/255.0, alpha: 1)
        
        headerViewLabel.text = types[section]
        headerViewLabel.textAlignment = .Center
        headerViewLabel.textColor = UIColor.whiteColor()
        headerViewLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        headerViewLabel.layer.borderColor = UIColor(red: 116/255.0, green: 70/255.0, blue: 37/255.0, alpha: 0.75).CGColor
        headerViewLabel.layer.borderWidth = 1.0
        
        return headerViewLabel
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    /**
    Sets the background color of a table cell
    */
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
    Creates preference list that is passed to preference list view controller
    */
    func createPreferenceList() -> [Dish] {
        var preferences = [Dish]()
        for type : String in types {
            for dish: Dish in menu[type]! {
                if dish.like {
                    preferences.append(dish)
                }
            }
        }
        preferences.sort({$0.name < $1.name})
        return preferences
    }
    
    
    //MARK: - Table view cell delegate
    
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

    
    func edit(){
        self.edited = true
    }
    
    
    func handleDealtWithOnLike(dish: Dish){
        if dish.like{
            dishes.addToDealtWith(dish.index)
        } else {
            dishes.removeFromDealtWith(dish.index)
        }
    }
    
    
    func handleDealtWithOnDislike(dish : Dish){
        if dish.dislike{
            dishes.addToDealtWith(dish.index)
        } else {
            dishes.removeFromDealtWith(dish.index)
        }
    }

    
    
    //MARK: - menu swipe view delegate
    /**
    Delegate function that reloads the table view when go back from preference list
    */
    func reloadTable() {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    
    /**
    Uploads the preference list
    */
    func uploadPreferenceList(restaurant: String){
        if let currentUser = PFUser.currentUser(){
            var user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            var query = PFQuery(className:"Preference")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                if let rest = pFObject["location"] as? String{
                                    if rest == restaurant {
                                        pFObject.deleteInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                                            if (success) {
                                                println("Successfully deleted")
                                            } else {
                                                println("Failed")
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        let param = Double(self.menu.count) * 0.05
        let delay =  param * Double(NSEC_PER_SEC)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(delayTime, dispatch_get_main_queue()){
            for type : String in self.types{
                for dish: Dish in self.menu[type]! {
                    if dish.like{
                        if let user = PFUser.currentUser(){
                            let newPreference = PFObject(className:"Preference")
                            newPreference["createdBy"] = PFUser.currentUser()
                            newPreference["dishName"] = dish.name
                            newPreference["location"] = dish.location
                            newPreference.saveInBackgroundWithBlock({
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    println("Successfully Saved")
                                } else {
                                    // There was a problem, check error.description
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    
    /**
    Uploads the dislike list
    */
    func uploadDislikes(restaurant: String){
        if let currentUser = PFUser.currentUser(){
            var user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            var query = PFQuery(className:"Disliked")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                if let rest = pFObject["location"] as? String{
                                    if rest == restaurant {
                                        pFObject.deleteInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
                                            if (success) {
                                                println("Successfully deleted")
                                            } else {
                                                println("Failed")
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        let param = Double(self.menu.count) * 0.05
        let delay =  param * Double(NSEC_PER_SEC)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(delayTime, dispatch_get_main_queue()){
        for dish: Dish in self.disLikes {
            if let user = PFUser.currentUser(){
                let newPreference = PFObject(className:"Disliked")
                newPreference["createdBy"] = PFUser.currentUser()
                newPreference["dishName"] = dish.name
                newPreference["location"] = dish.location
                newPreference.saveInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                         println("Successfully Saved")
                    } else {
                        // There was a problem, check error.description
                    }
                })
            }
        }
        }
    }

    
    /**
    Prepares for segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Segues to single dish info
        if segue.identifier == "restProfileSegue" {
            let restProfileViewController = segue.destinationViewController as! RestProfileViewController
            restProfileViewController.restProf = restProf
        }
        if segue.identifier == "mealInfoSegue" {
            let mealInfoViewController = segue.destinationViewController as! MealInfoViewController
            let selectedMeal = sender! as! Dish
            if let index = find(menu[selectedMeal.type]!, selectedMeal) {
                // Sets the dish info in the new view to selected cell's dish
                mealInfoViewController.dish = menu[selectedMeal.type]![index]
            }
        }
        // Segues to the preference list of the single menu
        if segue.identifier  == "menuToPreferenceSegue" {
            let preferencelistViewController = segue.destinationViewController as! PreferenceListViewController
            // Passes the list of liked dishes to the preference list view
            preferencelistViewController.preferences = createPreferenceList()
            preferencelistViewController.location = restProf?.name
            preferencelistViewController.dishes = dishes
            preferencelistViewController.delegate = self
        }
    }
}