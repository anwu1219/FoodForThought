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
    
    
    //let viewContainer = UIView()
    var styles = Styles()
    var restaurants : [String: [Dish]]?
    var location: String?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "RestaurantpickerBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        selectARestLabel.layer.shadowColor = UIColor.blackColor().CGColor
        selectARestLabel.layer.shadowOffset = CGSizeMake(5, 5)
        selectARestLabel.layer.shadowRadius = 5
        selectARestLabel.layer.shadowOpacity = 1.0
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        verticalRestMenuScroll.contentSize.width = 375
        verticalRestMenuScroll.contentSize.height = 600
        verticalRestMenuScroll.backgroundColor = UIColor.clearColor()

        //verticalRestMenuScroll.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        //verticalRestMenuScroll(viewContainer)
        if let restaurants = restaurants{
            var keys = restaurants.keys.array
            keys.sort({$0 < $1})
            placeButtons(keys)
        }
        
    }
    
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
        }
    }
    
    func placeButtons(keys: [String]) {
        for i in 0..<keys.count {
            var button = UIButton()
            var downAlign: CGFloat = 20
            
            var width: CGFloat = 0.2 * verticalRestMenuScroll.bounds.width
            var height: CGFloat = 0.15 * verticalRestMenuScroll.bounds.height
            var x: CGFloat = (50 + (0.5 * width))
            var y: CGFloat = (height+10) * CGFloat(i) //(0 - (0.5 * height))
            button.frame = CGRectMake(x - 40, y + 10, 250, 46)
           // button.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.75, alpha: 0.95)
            button.setTitle(keys[i], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "toMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            //button.titleLabel?.textColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);

            //  var image = UIImageView(image: UIImage(named: "menuButton"))
            let backgroundImage = UIImageView(image: UIImage(named: "menuButton"))
           // button.setImage(backgroundImage, forState: UIControlState.Normal)
           // image.frame = CGRectMake( x, (y+height+5), width, width)
            backgroundImage.frame = button.frame
            
            verticalRestMenuScroll.addSubview(button)
            verticalRestMenuScroll.addSubview(backgroundImage)
        }
    }
    
    func toMenu(sender: UIButton!) {
        // use get data function to get the menu for the selected restaurant
        // call performSegueWithIdentifier to menuSwipeViewController 
        //self.getData(sender.titleLabel!.text!)
        performSegueWithIdentifier("restToMenuSegue", sender: sender)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "restToMenuSegue"{
        let menuSwipeViewController = segue.destinationViewController as! MenuSwipeViewController
        if let restaurants = restaurants {
            let button = sender as! UIButton
            if let title = button.titleLabel?.text {
                menuSwipeViewController.menuLoad = restaurants[title]
                menuSwipeViewController.location = title
                deletePreferenceList(title)
                deleteDislikes(title)
            }
        }
        }
    }
    
    
    
    /**
    Deletes the preference list class in parse
    */
    func deletePreferenceList(restaurant: String){
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
                                            pFObject.delete()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    
    func deleteDislikes(restaurant: String){
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
                                        pFObject.delete()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}