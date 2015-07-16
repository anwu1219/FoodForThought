//
//  MenuInfoViewController.swift
//  Commons Menu1
//
//  Created by Chadinha, Spencer on 6/22/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

/**
Displays information on a given dish
*/

class MealInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishName: UINavigationItem!
    @IBOutlet weak var scrollInfo: UIScrollView!
    
    @IBOutlet weak var susLabelView: UIScrollView!
    @IBOutlet weak var labelsLabel: UILabel!
    
    var dish: Dish?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dishName.title = dish?.name
        dishImage.image = dish?.image
        dishImage.contentMode = .ScaleAspectFill
        dishImage.layer.borderWidth = 6
        dishImage.layer.borderColor = UIColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 1.0).CGColor
        dishImage.layer.masksToBounds = true
        //scrollInfo.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)

        var background = UIImageView()
        background.bounds = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height)
        background.frame = background.bounds
        background.image = UIImage(named: "dishlevelInfopagebackground")
        background.contentMode = .ScaleAspectFill
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)

        layoutPage()
        
    }
    
    
    /**
    Put dish information into the scrollInfo
    */
    func layoutPage() {
        var width: CGFloat = 0.01 * screenSize.width // a unit of x
        var height: CGFloat = 0.01 * screenSize.height // a unit of y
        var x: CGFloat = 0.02 * screenSize.width // current x coordinate
        var y: CGFloat = 0.01 * screenSize.height // current y coordinate
        if let susLabels = dish?.susLabels {
            if count(susLabels) > 0 {
                
                var container = UIView()
                
                var title = UILabel()
                title.text = "Dish Sustainability Info"
                title.frame = CGRectMake(0, y, 91*width, 10*height)
                title.textAlignment = .Center
                title.font = UIFont(name: "Helvetica-Neue Light", size: 24)
                
                title.textColor = UIColor.whiteColor()
                container.addSubview(title)
                y += 10 * height
                
                var labelPics = UIScrollView()
                var labelWidth = 6*height
                var labelHeight = 9*height
                var labelSpace = 2*width
                labelPics.frame = CGRectMake(0, y, title.frame.width, title.frame.height)
                labelPics.contentSize = CGSizeMake(CGFloat(susLabels.count)*(labelWidth+labelSpace)+labelSpace, labelHeight)
                //labelPics.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                
                var initX = x
                if labelPics.contentSize.width < labelPics.frame.width {
                    initX = (labelPics.frame.width/2) - (labelPics.contentSize.width/2)
                }
                
                for var i = 0; i < susLabels.count; i++ {
                    
                    var labelImage = IconButton(name: susLabels[i], frame: CGRectMake(initX, height, labelWidth, labelWidth))
                    labelImage.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    labelPics.addSubview(labelImage)
                    initX += labelSpace + labelWidth
                }
                
                //scrollInfo.addSubview(labelPics)
                container.addSubview(labelPics)
                y += 10 * height
                
                container.frame = CGRectMake(x, y-20*height, 91*width, 20*height)
                container.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                container.layer.shadowOffset = CGSizeMake(2.0, 2.0)
                container.layer.shadowOpacity = 0.7
                scrollInfo.addSubview(container)
                
            }
        }
        if let location = dish?.location {
            var label = UILabel()
            label.text = "Location: \(location)"
            label.frame = CGRectMake( x, y, 91 * width, 10 * height)
            label.font = UIFont(name: "Helvetica-Neue Light", size: 14)
            label.textColor = UIColor.whiteColor()
            label.numberOfLines = 0
            label.sizeToFit()
            //label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            scrollInfo.addSubview(label)
            y += label.frame.height + (3*height)
        }
        
        if let price = dish?.price {
            if count(price) > 0 {
                var label = UILabel()
                //label.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 0.6, alpha: 0.8)
                label.text = "Price: \(price)"
                label.frame = CGRectMake(x, y, 91 * width, 10 * height)
                label.numberOfLines = 0
                label.sizeToFit()
                label.font = UIFont(name: "Helvetica-Neue Light", size: 14)
                label.textColor = UIColor.whiteColor()
                scrollInfo.addSubview(label)
                y += label.frame.height + (3*height)
            }
        }
        
        
        if let ingredients = dish?.ingredients {
            //label.numberOfLines = 0 // allows for undetermined number of lines to be used to display text
            if count(ingredients) > 0 {
                var ingLabel = UILabel()
                //ingLabel.backgroundColor = UIColor(red: 0.6, green: 0.3, blue: 0.6, alpha: 0.8)
                ingLabel.text = "Ingredients:"
                ingLabel.frame = CGRectMake(x, y, 91 * width, 10 * height)
                ingLabel.numberOfLines = 0
                ingLabel.sizeToFit()
                ingLabel.font = UIFont(name: "Helvetica-Neue Light", size: 14)
                ingLabel.textColor = UIColor.whiteColor()
                scrollInfo.addSubview(ingLabel)
                y += ingLabel.frame.height + (3*height)
            }
            for var i = 0; i < ingredients.count; i++ {
                var ingredient = UILabel()
                ingredient.font = UIFont(name: "Helvetica-Neue Light", size: 14)
                ingredient.textColor = UIColor.whiteColor()
                ingredient.frame = CGRectMake( 2 * x, y, 91 * width, 10 * height)
                ingredient.text = "- \(ingredients[i])"
                ingredient.lineBreakMode = NSLineBreakMode.ByWordWrapping
                ingredient.numberOfLines = 0
                var num = CGFloat(2 * count(ingredients[i]))
                ingredient.frame = CGRectMake( 2 * x, y, 91 * width, 10 * height)

                //ingreident.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
                ingredient.sizeToFit()
                scrollInfo.addSubview(ingredient)

                if let labels = dish?.labels {
                    if !labels.isEmpty{
                        var nutLabelXPosition = 3 * height
                        for label: String in labels[i] {
                            println(label)
                            var nutLabel = IconButton(name: label, frame: CGRectMake( 330 - nutLabelXPosition, y - 2 * height, 5 * height, 5 * height))
                            nutLabel.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                            scrollInfo.addSubview(nutLabel)
                            nutLabelXPosition += 8 * height
                        }
                    }
                }
                y += 5 * height
            }
        }
        scrollInfo.contentSize.height = y
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showLabelInfo(sender: AnyObject) {
        let vc = UIViewController()
        let button = sender as! IconButton
        
        vc.preferredContentSize = CGSizeMake(200, 100)
        vc.modalPresentationStyle = .Popover
        
        if let pres = vc.popoverPresentationController {
            pres.delegate = self
        }
        
        let description = UILabel(frame: CGRectMake(0, 0, vc.view.bounds.width/2 , vc.view.bounds.height))
        description.center = CGPointMake(100, 50)
        description.lineBreakMode = .ByWordWrapping
        description.numberOfLines = 0
        description.textAlignment = NSTextAlignment.Center
        description.text = button.descriptionText!
        vc.view.addSubview(description)
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
        if let pop = vc.popoverPresentationController {
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
        }
    }
}



extension MealInfoViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
        
    }
}