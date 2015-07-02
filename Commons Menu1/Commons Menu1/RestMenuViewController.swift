//
//  RestMenuViewController.swift
//  
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//
//

import UIKit
import Parse

protocol updateRestaurantPreferenceListDelegate{
    func updatePreference(preferences: [Dish], location: String)
}


/**
Shows all the resturants with available menus
*/
class RestMenuViewController: UIViewController, updateRestaurantPreferenceListDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var horizonScroll: UIScrollView!
    
    //let viewContainer = UIView()
    var styles = Styles()
    var menu: [Dish]?
    var restaurants : [String: [Dish]]?
    var preferenceListLoad : [String: [Dish]]?
    var preferenceList = [String: [Dish]]()
    var delegate: updatePreferenceListDelegate?
    var location: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        horizonScroll.contentSize.width = 1000
        horizonScroll.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        //horizonScroll.addSubview(viewContainer)
        if let restaurants = restaurants{
            var keys = restaurants.keys.array
            keys.sort({$0 < $1})
            addKeysToPreferenceList(keys)
            placeButtons(keys)
        }
        if let preferenceListLoad = preferenceListLoad {
            preferenceList = preferenceListLoad
        }
    }
    
    
    func addKeysToPreferenceList(keys: [String]){
        for key in keys{
            preferenceList[key] = []
        }
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if parent == nil {
            if delegate != nil {
                if let location = location{
                    delegate?.updatePreference(preferenceList)
                }
            }
        }
    }
    
    
    func placeButtons(keys: [String]) {
        for i in 0..<keys.count {
            var button = UIButton()
            var leftAlign: CGFloat = 10
            var width: CGFloat = 0.2 * horizonScroll.bounds.width
            var height: CGFloat = 0.3 * horizonScroll.bounds.height
            var x: CGFloat = (width+10) * CGFloat(i)
            var y: CGFloat = (0 - (0.5 * height))
            button.frame = CGRectMake(leftAlign + x, y, width, height)
            button.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.75, alpha: 0.95)
            button.setTitle(keys[i], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "toMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var image = UIImageView(image: UIImage(named: "heartHands"))
            image.frame = CGRectMake(leftAlign + x, (y+height+5), width, width)
            
            horizonScroll.addSubview(button)
            horizonScroll.addSubview(image)
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
                menuSwipeViewController.delegate = self
            }
        }
        }
    }
    
    func updatePreference(preferences: [Dish], location: String) {
        preferenceList[location] = preferences
        self.location = location
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}