//
//  MenuSwipeViewController.swift
//  Foodscape
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

protocol MenuSwipeViewControllerDelegate {
    func reloadTable()
}

protocol TypesTableViewCellDelegate{
    func goToType(type: String)
}


// A protocol that the TableViewCell uses to inform its delegate of state change
protocol MenuTableViewCellDelegate {
    
    /**
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    // #spchadinha
    func viewDishInfo(dish: Dish)
    
    func edit()
    
    func handleDealtWithOnLike(dish: Dish)
    
    func handleDealtWithOnDislike(dish : Dish)
}


/**
Displays menus as food tinder
*/
class MenuSwipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate, MenuSwipeViewControllerDelegate, UIPopoverPresentationControllerDelegate, TypesTableViewCellDelegate{
    
    
    var dishes : Dishes!
    var restProf: RestProfile!
    private let tableView = UITableView()
    private let restProfileButton = UIButton()
    private let restImage = UIImageView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView()
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    private let scroll = UIScrollView()
    private let menuSwipeScroll = UIScrollView()
    private let typesTableView = UITableView()
    private let infoButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
    
    private var menu = [String : [Dish]]()
    private var disLikes = Set<Dish>()
    private var types = [String]()
    private var edited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yUnit: CGFloat = screenSize.height / 100
        let xUnit: CGFloat = screenSize.width / 100
    
        
        
        scroll.showsHorizontalScrollIndicator = false

        
        infoButton.frame = CGRect(x: 90 * xUnit, y: 25.8 * yUnit, width: 6 * xUnit, height: 6 * xUnit)
        infoButton.tintColor = UIColor.whiteColor()
        infoButton.addTarget(self, action: "viewInfoPage:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(infoButton)
        
        func labelStyle(label : UILabel){
            label.lineBreakMode = .ByWordWrapping
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Left
            label.textColor = UIColor.whiteColor()
        }
        
        
        let restWeekdayOpenHoursLabel = UILabel()
        //Formats the labels in the view controller
        restWeekdayOpenHoursLabel.text = "Today's Hours: \(restProf!.hours[self.getDayOfWeek()])"
        restWeekdayOpenHoursLabel.font = UIFont(name: "HelveticaNeue-Light", size: 3.2 * xUnit)
        labelStyle(restWeekdayOpenHoursLabel)
        restWeekdayOpenHoursLabel.frame = CGRect(x: 3 * xUnit, y: 31.5 * yUnit, width: 50 * xUnit, height: 6 * yUnit)

        view.addSubview(restWeekdayOpenHoursLabel)
        
        let labelTitleLabel = UILabel()
        labelTitleLabel.frame = CGRect(x: 5 * xUnit, y: 21.5 * yUnit, width: 50 * xUnit, height: 2 * yUnit)
        labelTitleLabel.text = "Restaurant Sustainabiltiy Icons:"
        labelTitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 3.2 * xUnit)
        labelStyle(labelTitleLabel)
        
        view.addSubview(labelTitleLabel)

        
        restImage.frame = CGRect(x: 0, y: 0, width: 100 * xUnit, height: 21 * yUnit)
        restProf.imageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) ->Void in
            if error == nil {
                if let data = imageData{
                    if let image = UIImage(data: data){
                        self.restImage.image = image
                    }
                }
            }
        }
        self.view.addSubview(restImage)
        
        menuSwipeScroll.frame = CGRect(x: 0.05 * view.frame.width, y: 0.38 * view.frame.height, width: 0.9 * view.frame.width, height: 0.62 * view.frame.height)
        menuSwipeScroll.backgroundColor = UIColor.clearColor()
        menuSwipeScroll.contentSize = CGSize(width: 1.66 * menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: false)
        menuSwipeScroll.scrollEnabled = false
        view.addSubview(menuSwipeScroll)
        
        addTable()

        //sets nav bar to be see through
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.65)
        self.navigationController?.navigationBar.translucent = true

        self.automaticallyAdjustsScrollViewInsets = false;
        
        restProfileButton.frame = CGRect(x: 55 * xUnit, y: 31.5 * yUnit, width: 42 * xUnit, height: 5 * yUnit)
        //restProfileButton.setBackgroundImage(UIImage(named: "ViewRestProfgradient"), forState: UIControlState.Normal)
        restProfileButton.setTitle("View Restaurant Profile >", forState: .Normal)
        restProfileButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 3.5 * xUnit)
        restProfileButton.addTarget(self, action: "showRestaurant:", forControlEvents: UIControlEvents.TouchUpInside)
        restProfileButton.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.4)
        restProfileButton.layer.cornerRadius = 2
        restProfileButton.layer.borderWidth = 1
        restProfileButton.layer.borderColor = UIColor.blackColor().CGColor

        self.view.addSubview(restProfileButton)
        self.view.addSubview(restWeekdayOpenHoursLabel)
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            if let dishes = self.dishes {
                self.makeMenu(dishes.dishes[self.restProf]!)
                for type: String in self.types {
                    self.menu[type]!.sort({$0.name < $1.name})
                }
                if self.getDate() != dishes.date {
                    for key in dishes.cached.keys {
                        dishes.cached[key] = false
                    }
                    dishes.date = self.getDate()
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.tableView.endUpdates()
            }
        }

        
        
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        tableView.addSubview(refreshControl)

        //set the background image
        setBackground("genericBackground")

        
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width

        scroll.frame = CGRectMake(width * 0.05, height * 0.228, width * 0.82, 0.095 * height)
        self.addLabels()
        self.view.addSubview(scroll)
  
        if !dishes.learned["menuSwipe"]! {
            let alertController = UIAlertController(title: "Instructions",
                message: "Swipe right on the dish to add to My Favorites \n \n or\n \n Swipe left to dislike",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "OK!",
                style: UIAlertActionStyle.Default,
                handler: nil
                )
            )
            self.presentViewController(alertController, animated: true, completion: nil)
            dishes.learned["menuSwipe"] = true
        }
        
        
        if let foo = dishes.cached[restProf]{
            if !foo {
                activityIndicator.hidden = false
                activityIndicator.startAnimating()
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                activityIndicator.frame = CGRectMake(view.bounds.midX * 0.92, tableView.bounds.midY, 0, 0)
                self.tableView.addSubview(activityIndicator)
                self.refreshControl.sendActionsForControlEvents(.ValueChanged)
                self.dishes.cached(self.restProf)
            }
        }
    }
    
    
    func viewInfoPage(sender: AnyObject){
        performSegueWithIdentifier("viewInfoPageSegue", sender: sender)
    }
 
    func addTable(){
        let xUnit : CGFloat = self.menuSwipeScroll.frame.width / 100
        let yUnit : CGFloat = self.menuSwipeScroll.frame.height / 100
        
        
        typesTableView.frame = CGRect(x: 0 * xUnit, y: 0, width: 60 * xUnit, height: menuSwipeScroll.frame.height)
        typesTableView.backgroundColor = UIColor.clearColor()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "bringBack:")
        typesTableView.addGestureRecognizer(tapRecognizer)
        menuSwipeScroll.addSubview(typesTableView)
        
        typesTableView.dataSource = self
        typesTableView.delegate = self
        typesTableView.registerClass(TypesTableViewCell.self, forCellReuseIdentifier: "typeCell")
        typesTableView.separatorStyle = .None
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .SingleLine
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.blackColor().CGColor
        
        tableView.frame = CGRect(x: 66 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = UIImageView(image: UIImage(named: "menuButton"))
        tableView.backgroundView?.contentMode = .ScaleAspectFill
        tableView.rowHeight = 85
        menuSwipeScroll.addSubview(tableView)
    }
    
    
    func bringBack(sender: AnyObject){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    func refresh(refreshControl: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            self.addDishWithLocation(restProf.name)
        } else{
            noInternetAlert("Unable to Refresh")
        }
        refreshControl.endRefreshing()
    }


    func addDishWithLocation(location: String){
        let query = PFQuery(className:"dishInfo")
        query.whereKey("location", equalTo: location)
        query.findObjectsInBackgroundWithBlock{ //causes an error in console for every dish being loaded
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil{
                for type in self.restProf.dynamicTypes{
                    var dynamicTypeMenu = [Dish]()
                    if let menuType = self.menu[type] {
                    for dish in menuType {
                        if let date = dish.date {
                            if date == self.getDate() {
                                
                            } else {
                                dynamicTypeMenu.append(dish)
                            }
                        } else {
                            dynamicTypeMenu.append(dish)
                        }
                        }
                    }
                }
                if let objectsArray = objects{
                    for object: AnyObject in objectsArray{
                        let dish = object as! Dish
                        if self.dishes.pulled[object["index"]! as! Int] == nil{
                            if let date = object["displayDate"] as? String {
                                if date == self.dishes.date {
                                    dish.getDishData(object as! PFObject)
                                    self.dishes.addDish(location, dish: dish)
                                    self.dishes.addPulled(dish)
                                    self.addDishToMenu(dish)
                                }
                            } else {
                                dish.getDishData(object as! PFObject)
                                self.dishes.addDish(location, dish: dish)
                                self.dishes.addPulled(dish)
                                self.addDishToMenu(dish)
                            }
                        }
                    }
                    for type: String in self.types {
                        self.menu[type]!.sort({$0.name < $1.name})
                    }
                    UIView.transitionWithView(self.tableView, duration:0.35, options:.TransitionCrossDissolve,animations: { () -> Void in
                        self.tableView.reloadData()
                        self.typesTableView.reloadData()
                        }, completion: { (finished: Bool) -> () in
                            if finished {
                                self.typesTableView.endUpdates()
                                self.activityIndicator.stopAnimating()
                            }
                        })
                }
            }
        }
    }
    
    
    func addLabels() {
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width
        let labels = ["Restaurant Label"]
        var x: CGFloat = width * 0.01
        var y: CGFloat = height * 0.01
        if restProf.eco.count > 0 {
            let ecoIcon = SuperIconButton(labels: restProf.eco, frame: CGRect.nullRect, name: "Eco")
            ecoIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
            ecoIcon.frame = CGRectMake(x, 0.14*scroll.frame.height, 0.72*scroll.frame.height, 0.72 * scroll.frame.height)
            x += ecoIcon.frame.width + width * 0.01
            scroll.addSubview(ecoIcon)
        }
        
        if restProf.humane.count > 0 {
            let humaneIcon = SuperIconButton(labels: restProf.humane, frame: CGRect.nullRect, name: "Humane")
            humaneIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
            humaneIcon.frame = CGRectMake(x, 0.14*scroll.frame.height, 0.72*scroll.frame.height, 0.72 * scroll.frame.height)
            x += humaneIcon.frame.width + width * 0.01
            scroll.addSubview(humaneIcon)
        }
        
        if restProf.fair.count > 0 {
            let fairIcon = SuperIconButton(labels: restProf.fair, frame: CGRect.nullRect, name: "Fair")
            fairIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
            fairIcon.frame = CGRectMake(x, 0.14*scroll.frame.height, 0.72*scroll.frame.height, 0.72 * scroll.frame.height)
            x += fairIcon.frame.width + width * 0.01
            scroll.addSubview(fairIcon)
        }

        for var i = 0; i < restProf.labels.count; i++ {
            for var j = 0; j < restProf.labels[i].count; j++ {
                if count(restProf.labels[i][j]) > 0 {
                    let frame = CGRectMake(x, 0.14*scroll.frame.height, 0.68*scroll.frame.height, 0.68 * scroll.frame.height)
                    let icon = IconButton(name: restProf.labels[i][j], frame: frame)
                    icon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    scroll.addSubview(icon)
                    x += icon.frame.width + width*0.01
                }
            }
            
        }

                scroll.contentSize.width = x
        scroll.contentSize.height = y
    }
    
    
    /**
    Uploads preferences and dislikes to parse when go back
    */
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if edited {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
                    self.uploadPreferenceList(self.restProf.name)
                    self.uploadDislikes(self.restProf.name)
                }
            }
        }
    }
    
    
    // TypeDelegate
    func goToType(type: String){
        let index = find(types, type)!
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.3))
        dispatch_after(delayTime, dispatch_get_main_queue()){
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .Top, animated: false)
        }
    }
    
    
    func makeMenu(inputMenu : [Dish]){
        for dish : Dish in inputMenu {
            if let date = dish.date {
                if date == getDate() {
                    addDishToMenu(dish)
                }
            } else {
                addDishToMenu(dish)
            }
        }
    }
    
    
    func addDishToMenu(dish: Dish){
        if !contains(menu.keys, dish.type){
            menu[dish.type] = [Dish]()
            self.types.append(dish.type)
            self.types.sort({$0 < $1})
        }
        menu[dish.type]?.append(dish)
    }


    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == self.tableView{
            return types.count
        } else {
            return 1
        }
    }
    
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return menu[types[section]]!.count
        } else {
            return types.count
        }
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            if tableView == self.tableView{
            //initiates the cell
            var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
            
            cell.delegate = self
            cell.selectionStyle = .None
            
            //passes a dish to each cell
            let type = types[indexPath.section]
            if let dishes = menu[type]{
                let dish = dishes[indexPath.row]
                cell.dish = dish
            //sets the image
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
            }
        return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as! TypesTableViewCell
            cell.delegate = self
            cell.textLabel!.text = types[indexPath.row]
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
        if tableView == self.tableView{
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.width / 10)
        headerView.backgroundColor = UIColor(red: 38/255.0, green: 42/255.0, blue: 49/255.0, alpha: 1)
        headerView.layer.borderColor = UIColor.blackColor().CGColor
        headerView.layer.borderWidth = 1.0
        
        let xUnit = headerView.frame.width / 100
        let yUnit = headerView.frame.height / 100
        
        
        let sectionsButton = UIButton(frame: CGRect(x: 2 * xUnit, y: 25 * yUnit, width: 80 * yUnit, height: 50 * yUnit))
        sectionsButton.addTarget(self, action: "showSections:", forControlEvents: UIControlEvents.TouchUpInside)
            
        //Set the image of sections button
        sectionsButton.setImage(UIImage(named: "ArrowDropdownButton"), forState: UIControlState.Normal)
        
        
        let headerViewLabel = UILabel()
        headerViewLabel.frame = CGRectMake(0.15 * tableView.frame.size.width, 0, 0.7 * tableView.frame.size.width, tableView.frame.width / 10)
        headerViewLabel.text = types[section]
        headerViewLabel.textAlignment = .Center
        headerViewLabel.textColor = UIColor.whiteColor()
        headerViewLabel.font = UIFont(name: "HelveticaNeue", size: 20)

        headerView.addSubview(headerViewLabel)
        headerView.addSubview(sectionsButton)
        
        return headerView
        }
        return nil
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView{
            return tableView.frame.width / 10
        }
        return 0
    }
    
    
    func showSections(sender: AnyObject){
        self.menuSwipeScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
            let user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            let query = PFQuery(className:"Preference")
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
                                        })
                                    }
                                }
                            }
                        }
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
                                                user["menuViewed"] = true
                                                user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                                })}
                                            else {
                                                // There was a problem, check error.description
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
    }
    
    /**
    Uploads the dislike list
    */
    func uploadDislikes(restaurant: String){
        if let currentUser = PFUser.currentUser(){
            let user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            let query = PFQuery(className:"Disliked")
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
                                        })
                                    }
                                }
                            }
                        }
                        for type : String in self.types{
                            for dish: Dish in self.menu[type]! {
                                if dish.dislike{
                                    if let user = PFUser.currentUser(){
                                        let newPreference = PFObject(className:"Disliked")
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
            }
        }
    }
    
    func showRestaurant(sender: AnyObject){
        performSegueWithIdentifier("restProfileSegue", sender: sender)
    }
    
    /**
    Prepares for segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
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
        if segue.identifier == "viewInfoPageSegue" {
            let sustainabilityInfoViewController = segue.destinationViewController as! SustainabilityInfoViewController
            // Passes the list of liked dishes to the preference list view
            sustainabilityInfoViewController.isFromInfo = true
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
        
        let description = UILabel(frame: CGRectMake(10, 0, vc.view.frame.width/2 , vc.view.frame.height))
        description.lineBreakMode = .ByWordWrapping
        description.numberOfLines = 0
        description.textAlignment = NSTextAlignment.Left
        description.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        description.text = button.descriptionText
        description.sizeToFit()
        
        let frame = CGRectMake(0, description.frame.height - 5, description.frame.width, screenSize.height*0.05)
        let linkButton = LinkButton(name: button.name, frame: frame)
        linkButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        linkButton.setTitle("Learn More", forState: UIControlState.Normal)
        linkButton.addTarget(self, action: "learnMoreLink:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let popScroll = UIScrollView()
        if description.frame.height + linkButton.frame.height < vc.view.frame.height/2 {
            popScroll.frame = CGRectMake(0, 10, description.frame.width, description.frame.height+linkButton.frame.height+10)
        }
        else {
            popScroll.frame = CGRectMake(0, 0, vc.view.frame.width/2, vc.view.frame.height/2)
        }
        
        popScroll.contentSize = CGSizeMake(description.frame.width+20, description.frame.height+linkButton.frame.height+10)
        popScroll.addSubview(description)
        popScroll.addSubview(linkButton)
        vc.view.addSubview(popScroll)
        vc.preferredContentSize = CGSizeMake(popScroll.frame.width, popScroll.frame.height)
        vc.modalPresentationStyle = .Popover
        
        self.presentViewController(vc, animated: true, completion: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
        }
    }
    
    @IBAction func learnMoreLink(sender: UIButton) {
        let urls = IconDescription().urls
        let button = sender as! LinkButton
        if let url = NSURL(string: urls[button.name]!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}

extension MenuSwipeViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
        
    }
}