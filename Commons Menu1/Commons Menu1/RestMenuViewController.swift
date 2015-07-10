//
//  RestMenuViewController.swift
//  
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//
//

import UIKit
import Parse

/**
Shows all the resturants with available menus
*/
class RestMenuViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var verticalRestMenuScroll: UIScrollView!
    @IBOutlet weak var selectARestLabel: UILabel!
    var styles = Styles()
    var restaurants : [RestProfile: [Dish]]!
    var dishes : Dishes!
    var loaded = [Bool]()
    var keys = [RestProfile]()
    var location: String?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let loadingAlert = UIAlertController(title: "Loading...", message: "", preferredStyle: UIAlertControllerStyle.Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "RestaurantpickerBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        //Formats the select a restaurant label
        selectARestLabel.layer.shadowColor = UIColor.blackColor().CGColor
        selectARestLabel.layer.shadowOffset = CGSizeMake(5, 5)
        selectARestLabel.layer.shadowRadius = 5
        selectARestLabel.layer.shadowOpacity = 1.0
        
        //Gets the size of the screen
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //Formats the scroll view
        verticalRestMenuScroll.contentSize.width = screenSize.width
        verticalRestMenuScroll.contentSize.height = 450
        verticalRestMenuScroll.backgroundColor = UIColor.clearColor()

        //verticalRestMenuScroll.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        //Places the button with the list of restaurants get from restaurant map
        restaurants = dishes.dishes
        if let restaurants = restaurants{
            keys = restaurants.keys.array
            keys.sort({$0.name < $1.name})
            placeButtons(keys)
            for var i = 0; i < keys.count; i++ {
                loaded.append(false)
            }
        }
    }
    
    
    /**
    Places buttons that points to different restaurant menus
    */
    func placeButtons(keys: [RestProfile]) {
        for i in 0..<keys.count {
            var button = UIButton()
            var downAlign: CGFloat = 20
            
            // Sets the size and position of the button
            var buttonWidth = verticalRestMenuScroll.contentSize.width
            var width: CGFloat = 0.2 * verticalRestMenuScroll.bounds.width
            var height: CGFloat = 0.15 * verticalRestMenuScroll.bounds.height
            var x: CGFloat = ((buttonWidth*0.05) + (0.5 * width))
            var y: CGFloat = (height+10) * CGFloat(i)
            
            //Sets the content of the buttons
            button.frame = CGRectMake(x - 40, y + 10, (buttonWidth*0.8), 46)
            button.setTitle(keys[i].name, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.titleLabel?.font =  UIFont(name: "Helvetica Neue", size: 20)
            button.addTarget(self, action: "toMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
            
            //button shadows NOT WORKING ATM
            button.titleLabel?.layer.shadowColor = UIColor.blackColor().CGColor
            button.titleLabel?.layer.shadowOffset = CGSizeMake(2, 2)
            button.titleLabel?.layer.shadowRadius = 2
            button.titleLabel?.layer.shadowOpacity = 1.0
            
            let backgroundImage = UIImageView(image: UIImage(named: "menuButton"))
            backgroundImage.frame = button.frame
            
            verticalRestMenuScroll.addSubview(button)
            verticalRestMenuScroll.addSubview(backgroundImage)
        }
    }
    
    
    /**
    The function that the button will perform when pressed
    */
    func toMenu(sender: UIButton!) {
        if let restaurants = restaurants {
            if let title = sender!.titleLabel?.text {
                for restaurant : RestProfile in restaurants.keys{
                    if restaurant.name == title{
                        if loaded[find(keys, restaurant)!] == false {
                            self.addDishWithLocation(restaurant.name)
                            loaded[find(keys, restaurant)!] = true
                            presentViewController(loadingAlert, animated: true, completion: nil)
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
                            dispatch_after(delayTime, dispatch_get_main_queue()){
                            self.loadingAlert.dismissViewControllerAnimated(true, completion: { () -> Void in
                                self.performSegueWithIdentifier("restToMenuSegue", sender: sender)
                            })
                        }
                    }
                    self.performSegueWithIdentifier("restToMenuSegue", sender: sender)
                    }
                }
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
        for restaurant: RestProfile in restaurants.keys{
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "restToMenuSegue"{
            let menuSwipeViewController = segue.destinationViewController as! MenuSwipeViewController
            if let restaurants = restaurants {
                let button = sender as! UIButton
                if let title = button.titleLabel?.text {
                    for restaurant : RestProfile in restaurants.keys{
                        if restaurant.name == title{
                            menuSwipeViewController.restProf = restaurant
                            menuSwipeViewController.dishes = dishes

                    }
                }
            }
        }
    }
}
}