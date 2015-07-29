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
    
    func showLabelInfo(sender: AnyObject)
}


class FoodTinderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FoodTinderViewCellDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var foodTinderTableView: UITableView!
    @IBOutlet var foodTinderView: UIView!
    
    var dishes: Dishes!
    var menu = [Dish]()
    let styles = Styles()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    let completeAlert = UIAlertController(title: "You have swiped all the dishes! Bravo!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    var ecoLabelsArray: [String]!
    //let ecoLabelScrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    let instructLabel = CATextLayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTinderTableView.dataSource = self
        foodTinderTableView.delegate = self
        foodTinderTableView.registerClass(FoodTinderTableViewCell.self, forCellReuseIdentifier: "tinderCell")
        foodTinderTableView.separatorStyle = .SingleLine
        foodTinderTableView.rowHeight = screenSize.height;
        
        
        foodTinderTableView.backgroundColor = UIColor.clearColor()
        
        setBackground("DishLevelPagebackground")
        
        foodTinderTableView.layer.cornerRadius = 5
        
        
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        foodTinderTableView.addSubview(refreshControl)
        
        var logButton = UIBarButtonItem(title: "My Favorites", style: UIBarButtonItemStyle.Plain, target: self, action: "viewPreferences:")
        self.navigationItem.rightBarButtonItem = logButton
        
        
        if !dishes.learned["tinder"]! {
            instructLabel.frame = CGRectMake(0, 0.85 * view.bounds.height, view.bounds.width, 0.15 * view.bounds.height)
            instructLabel.string = "\n Swipe right to add dish to Favorites\n Swipe left to pass on dish"
            let fontName: CFStringRef = "Helvetica-Light"
            instructLabel.font = CTFontCreateWithName(fontName, 10, nil)
            instructLabel.fontSize = self.view.frame.height / 40
            instructLabel.backgroundColor = UIColor.lightGrayColor().CGColor
            instructLabel.foregroundColor = UIColor.darkGrayColor().CGColor
            instructLabel.wrapped = true
            instructLabel.alignmentMode = kCAAlignmentCenter
            instructLabel.contentsScale = UIScreen.mainScreen().scale
            view.layer.addSublayer(instructLabel)
        }
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
        dispatch_after(delayTime, dispatch_get_main_queue()){
            self.refreshControl.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func viewPreferences(button: UIBarButtonItem?){
        performSegueWithIdentifier("tinderToAllPreferencesSegue", sender: button)
    }
    
    
    
    func refresh(refreshControl: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            if dishes.dealtWith.count < dishes.numberOfDishes{
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
            noInternetAlert("Unable to Get Any Food for Thought")
            refreshControl.endRefreshing()
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
            cell.imageView?.image = dish.image
            cell.dish = dish
            
            //sets the image
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
        if !dishes.learned["tinder"]! {
            instructLabel.hidden = true
             dishes.learned["tinder"] = true
        }
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
                if !self.hasBeenAdded(object["name"]! as! String, location: object["location"] as! String){
                    let dish = object as! Dish
                    if !self.dishes.pulled.contains(object["index"]! as! Int){
                        dish.name = object["name"] as! String
                        dish.location = object["location"] as! String
                        dish.ingredients = object["ingredients"] as! [String]
                        dish.labels = object["labels"] as! [[String]]
                        dish.type = object["type"] as! String
                        dish.susLabels = object["susLabels"] as! [String]
                        dish.index = object["index"] as! Int
                        dish.eco = object["eco"] as! [String]
                        dish.fair = object["fair"] as! [String]
                        dish.humane = object["humane"] as! [String]
                        dish.price = object["price"] as! String
                        dish.imageFile = object["image"] as! PFFile
                        self.dishes.addDish(dish.location, dish: dish)
                        self.dishes.addPulled(dish.index)
                        if let date = object["displayDate"] as? String {
                            dish.date = date
                        }
                        dish.imageFile.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) ->Void in
                            if error == nil {
                                if let data = imageData{
                                    if let image = UIImage(data: data){
                                        dish.image = image
                                        self.menu.append(dish)
                                        UIView.transitionWithView(self.foodTinderTableView, duration:0.5, options:.TransitionFlipFromTop,animations: { () -> Void in
                                            self.foodTinderTableView.reloadData()
                                            self.foodTinderTableView.endUpdates()
                                        }, completion: nil)
                                    }
                                }
                            } else {
                                self.foodTinderTableView.endUpdates()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func showLabelInfo(sender: AnyObject) {
        let vc = UIViewController()
        let button = sender as! IconButton
        
        vc.preferredContentSize = CGSizeMake(self.view.frame.width * 0.4, self.view.frame.height * 0.3)
        vc.modalPresentationStyle = .Popover
        
        if let pres = vc.popoverPresentationController {
            pres.delegate = self
        }
        
        let description = UILabel(frame: CGRectMake(0, 0, vc.view.frame.width/2 , vc.view.frame.height))
        description.lineBreakMode = .ByWordWrapping
        description.numberOfLines = 0
        description.textAlignment = NSTextAlignment.Center
        description.text = button.descriptionText
        description.sizeToFit()

        
        let frame = CGRectMake(0, description.frame.height + 5, description.frame.width, screenSize.height*0.05)
        let linkButton = LinkButton(name: button.name, frame: frame)
        linkButton.setTitle("Learn More", forState: UIControlState.Normal)
        linkButton.addTarget(self, action: "learnMoreLink:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let popScroll = UIScrollView()
        if description.frame.height + linkButton.frame.height < vc.view.frame.height/2 {
            popScroll.frame = CGRectMake(0, 10, description.frame.width, description.frame.height+linkButton.frame.height+10)
        }
        else {
            popScroll.frame = CGRectMake(0, 0, vc.view.frame.width/2, vc.view.frame.height/2)
        }
        
        
        
        popScroll.contentSize = CGSizeMake(description.frame.width, description.frame.height+linkButton.frame.height)
        popScroll.addSubview(description)
        popScroll.addSubview(linkButton)
        vc.view.addSubview(popScroll)
        
        vc.preferredContentSize = CGSizeMake(popScroll.frame.width, popScroll.frame.height)
        vc.modalPresentationStyle = .Popover
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        if let pop = vc.popoverPresentationController {
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
        }    }
}



extension FoodTinderViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
        
    }
}