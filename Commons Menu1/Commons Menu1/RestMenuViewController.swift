//
//  RestMenuViewController.swift
//  
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//
//

import UIKit
import Parse
import QuartzCore

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
    var keys = [RestProfile]()
    var location: String?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "restPickerBackground")
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
            button.setTitleShadowColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel?.font =  UIFont(name: "Helvetica Neue", size: 20)
            button.addTarget(self, action: "toMenu:", forControlEvents: UIControlEvents.TouchUpInside)
          //  button.setBackgroundColor(UIColor(white: 0, alpha: 0.01), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
            
            button.titleLabel?.shadowColor = UIColor.blackColor()
            button.titleLabel?.shadowOffset = CGSizeMake(3, 3)
            button.titleLabel?.layer.shadowRadius = 9
            button.titleLabel?.layer.shadowOpacity = 0.5
            
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
        self.performSegueWithIdentifier("restToMenuSegue", sender: sender)
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

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, forState: forState)
    }}