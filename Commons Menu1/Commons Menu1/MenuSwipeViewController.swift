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
    
    func edit()
    
    func handleDealtWithOnLike(dish: Dish)
    
    func handleDealtWithOnDislike(dish : Dish)
    
    func uploadPreference(dish: Dish)
    
    func uploadDislike(dish: Dish)
}


/**
Displays menus as food tinder
*/
class MenuSwipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MenuTableViewCellDelegate, MenuSwipeViewControllerDelegate, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restWeekdayOpenHoursLabel: UILabel!
    @IBOutlet weak var restProfileButton: UIButton!
    @IBOutlet weak var restImage: UIImageView!
    
    
    var menu = [String : [Dish]]()
    var dishes : Dishes!
    let styles = Styles()
    var disLikes = Set<Dish>()
    var types = [String]()
    var restProf: RestProfile!
    var edited = false
    let refreshControl = UIRefreshControl()
    var activityIndicator = UIActivityIndicatorView()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let scroll = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Formats the labels in the view controller
        restWeekdayOpenHoursLabel.text = "Hours: \(restProf!.hours[self.getDayOfWeek()])"
        restWeekdayOpenHoursLabel.lineBreakMode = .ByWordWrapping
        restWeekdayOpenHoursLabel.numberOfLines = 0
        restWeekdayOpenHoursLabel.textAlignment = NSTextAlignment.Left
        
        
        restProf.imageFile!.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) ->Void in
            if error == nil {
                if let data = imageData{
                    if let image = UIImage(data: data){
                        self.restImage.image = image
                    }
                }
            }
        }
    
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .SingleLine
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.blackColor().CGColor
        
        
        
        
        //sets nav bar to be see through
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        self.navigationController?.navigationBar.translucent = true

        restProfileButton.setTitle("View Restaurant Profile", forState: .Normal)
        self.automaticallyAdjustsScrollViewInsets = false;

        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = styles.backgroundImage
        tableView.backgroundView?.contentMode = .ScaleAspectFill
        tableView.rowHeight = 85;
        if let dishes = dishes {
            self.makeMenu(dishes.dishes[restProf]!)
            for type: String in self.types {
                self.menu[type]!.sort({$0.name < $1.name})
            }
        }
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "genericBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width

        let label: UILabel = UILabel(frame: CGRectMake(width * 0.015, restImage.frame.height + 0.03 * height + 2 , 0.42 * width, 0.02 * height))
        label.text = "Sustainability Labels:"
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.blackColor()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.numberOfLines = 0
        self.view.addSubview(label)        
        scroll.frame = CGRectMake(width * 0.05 - 5, restImage.frame.height + 0.06 * height + 5, 0.4 * width, 0.095 * height)
        self.addLabels()
        self.view.addSubview(scroll)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let foo = dishes.cached[restProf]{
            if !foo {
                activityIndicator.hidden = false
                activityIndicator.startAnimating()
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                activityIndicator.frame = CGRectMake(view.bounds.midX * 0.92, tableView.bounds.midY, 0, 0)
                self.tableView.addSubview(activityIndicator)
                tableView.setContentOffset(CGPoint(x: 0, y: -0.25 * self.tableView.frame.height), animated: true)
                self.refreshControl.sendActionsForControlEvents(.ValueChanged)
                self.dishes.cached(self.restProf)
            }
        }
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
        var query = PFQuery(className:"dishInfo")
        query.whereKey("location", equalTo: location)
        query.findObjectsInBackgroundWithBlock{ //causes an error in console for every dish being loaded
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil{
                if let objectsArray = objects{
                    for object: AnyObject in objectsArray{
                        if let index = object["index"] as? Int{
                            if !self.dishes.pulled.contains(index){
                                    if let name = object["name"] as? String {
                                        if let location = object["location"] as? String{
                                            if let index = object["index"] as? Int{
                                                if let eco = object["eco"] as? [String] {
                                                    if let fair = object["fair"] as? [String]{
                                                        if let humane = object["humane"] as? [String]{
                                            if let ingredients = object["ingredients"] as? [String]{
                                                if let susLabels = object["susLabels"] as? [String]{
                                                if let labels = object["labels"] as? [[String]]{
                                                    if let type = object["type"] as? String{
                                                        if let price = object["price"] as? String{
                                                        if let userImageFile = object["image"] as? PFFile{
                                                                let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels, eco: eco, fair: fair, humane: humane, imageFile: userImageFile)
                                                                self.dishes.addDish(location, dish: dish)
                                                                self.addDishToMenu(dish)
                                                                self.dishes.addPulled(index)
                                                    } else{
                                                        let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels, eco: eco, fair: fair, humane: humane)
                                                        self.dishes.addDish(location, dish: dish)
                                                        self.addDishToMenu(dish)
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
                        }
                    }
                    for type: String in self.types {
                        self.menu[type]!.sort({$0.name < $1.name})
                    }
                    UIView.transitionWithView(self.tableView, duration:0.35, options:.TransitionCrossDissolve,animations: { () -> Void in
                        self.tableView.reloadData()}, completion: nil)
                    self.tableView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
                    self.activityIndicator.stopAnimating()
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
        for var i = 0; i < restProf.labels.count; i++ {
            for var j = 0; j < restProf.labels[i].count; j++ {
                if count(restProf.labels[i][j]) > 0 {
                    var frame = CGRectMake(x, 0.14*scroll.frame.height, 0.72*scroll.frame.height, 0.72 * scroll.frame.height)
                    var icon = IconButton(name: restProf.labels[i][j], frame: frame)
                    icon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    scroll.addSubview(icon)
                    x += icon.frame.width + width*0.01
                }
            }
            
        }
        var frame = CGRectMake(x, 0.14*scroll.frame.height, 0.72*scroll.frame.height, 0.72 * scroll.frame.height)
        if restProf.eco.count > 0 {
            let ecoIcon = SuperIconButton(labels: restProf.eco, frame: frame, name: "Eco")
            ecoIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
            x += frame.width
            scroll.addSubview(ecoIcon)
        }
        
        if restProf.humane.count > 0 {
            let humaneIcon = SuperIconButton(labels: restProf.humane, frame: frame, name: "Humane")
            humaneIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
            x += frame.width
            scroll.addSubview(humaneIcon)
        }
        
        if restProf.fair.count > 0 {
            let fairIcon = SuperIconButton(labels: restProf.fair, frame: frame, name: "Fair")
            fairIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
            x += frame.width
            scroll.addSubview(fairIcon)
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
    
    
    func makeMenu(inputMenu : [Dish]){
        for dish : Dish in inputMenu {
             addDishToMenu(dish)
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
                dish.imageFile!.getDataInBackgroundWithBlock {
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
        headerViewLabel.backgroundColor = UIColor(red: 38/255.0, green: 42/255.0, blue: 49/255.0, alpha: 1)
        
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
          //  cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.92, alpha: 0.7)//colorForIndex(indexPath.row)
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

    func showLabelInfo(sender: AnyObject) {
        let vc = UIViewController()
        let button = sender as! IconButton
        
        vc.preferredContentSize = CGSizeMake(200, 100)
        vc.modalPresentationStyle = .Popover
        
        if let pres = vc.popoverPresentationController {
            pres.delegate = self
        }
        
        let description = UILabel(frame: CGRectMake(0, 0, vc.view.frame.width/2 , vc.view.frame.height))
        description.lineBreakMode = .ByWordWrapping
        description.numberOfLines = 0
        description.textAlignment = NSTextAlignment.Center
        description.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        description.text = button.descriptionText
        description.sizeToFit()
        vc.view.addSubview(description)
        
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