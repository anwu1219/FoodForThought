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
    private var restaurants : [RestProfile: [Dish]]!
    var dishes : Dishes!
    private var keys = [RestProfile]()
    private var location: String?
    private let vertScrollMenu = UIScrollView()
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the background image
        setBackground("restPickerBackground")

        //Gets the size of the screen
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        //Formats the select a restaurant label
        let selectARestLabel = UILabel()
        selectARestLabel.frame = CGRectMake(24, 64, screenSize.width*0.9, 55)
        selectARestLabel.layer.shadowColor = UIColor.blackColor().CGColor
        selectARestLabel.layer.shadowOffset = CGSizeMake(5, 5)
        selectARestLabel.layer.shadowRadius = 5
        selectARestLabel.layer.shadowOpacity = 1.0
        selectARestLabel.text = "Select A Restaurant"
        selectARestLabel.textColor = UIColor.whiteColor()
        selectARestLabel.font = UIFont(name: "Helvetica-Bold", size: 28)
        self.view.addSubview(selectARestLabel)

        
        //Formats the scroll view
        
        vertScrollMenu.frame = CGRectMake(24, 200, screenSize.width, screenSize.height * 0.5)
        vertScrollMenu.contentSize.width = screenSize.width
        vertScrollMenu.contentSize.height = 350
        vertScrollMenu.backgroundColor = UIColor.clearColor()
        self.view.addSubview(vertScrollMenu)

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
    private func placeButtons(keys: [RestProfile]) {
        for i in 0..<keys.count {
            let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            let downAlign: CGFloat = 20
            
            // Sets the size and position of the button
            let buttonWidth = vertScrollMenu.contentSize.width
            let width: CGFloat = 0.2 * vertScrollMenu.bounds.width
            let height: CGFloat = 0.15 * vertScrollMenu.bounds.height
            
            let x: CGFloat = ((buttonWidth*0.05) + (0.5 * width))
            let y: CGFloat = (height+10) * CGFloat(i)
            
            //Sets the content of the buttons
            button.frame = CGRectMake(x - 40, y + 10, (buttonWidth*0.8), 46)
            button.setTitle(keys[i].name, forState: UIControlState.Normal)
            button.titleLabel?.font =  UIFont(name: "Helvetica Neue", size: 20)
            button.addTarget(self, action: "toMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
            button.layer.shadowColor = UIColor.blackColor().CGColor
            button.layer.shadowOffset = CGSizeMake(2, 2)
            button.layer.shadowRadius = 0.5
            button.layer.shadowOpacity = 1.0
            let backgroundImage = UIImageView(image: UIImage(named: "menuButton"))
            backgroundImage.frame = button.frame
            
            vertScrollMenu.addSubview(button)
            vertScrollMenu.addSubview(backgroundImage)

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