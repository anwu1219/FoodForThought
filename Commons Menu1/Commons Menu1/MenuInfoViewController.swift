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

class MealInfoViewController: UIViewController {
    
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
        dishImage.layer.borderWidth = 6
        dishImage.layer.borderColor = UIColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 1.0).CGColor
        
        var background = UIImageView()
        background.bounds = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height)
        background.frame = background.bounds
        background.image = UIImage(named: "blurrypreferencepicture")
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
        
        if let susLabels = dish?.labels {
            if susLabels.count > 0 {
                
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
                var labelWidth = 9*height
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
                    println(initX)
                    var labelImage = UIImageView()
                    labelImage.frame = CGRectMake(initX, height, labelWidth, labelWidth)
                    labelImage.image = UIImage(named: "C")
                    labelImage.contentMode = .ScaleToFill
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
            //label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            scrollInfo.addSubview(label)
            y += 10 * height
        }
        
        if let price = dish?.price {
            var label = UILabel()
            label.text = "Price: $\(price)"
            label.frame = CGRectMake(x, y, 91 * width, 10 * height)
            label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            label.font = UIFont(name: "Helvetica-Neue Light", size: 14)
            label.textColor = UIColor.whiteColor()
            scrollInfo.addSubview(label)
            y += 10 * height
        }
        
        
        if let ingredients = dish?.ingredients {
            //label.numberOfLines = 0 // allows for undetermined number of lines to be used to display text
            var ingreident = UILabel()
            ingreident.text = "Ingredients:"
            ingreident.frame = CGRectMake(x, y, 91 * width, 10 * height)
            ingreident.font = UIFont(name: "Helvetica-Neue Light", size: 14)
            ingreident.textColor = UIColor.whiteColor()
            scrollInfo.addSubview(ingreident)
            y += 9 * height
            for var i = 0; i < ingredients.count; i++ {
                var ingredient = UILabel()
                ingredient.font = UIFont(name: "Helvetica-Neue Light", size: 14)
                ingredient.textColor = UIColor.whiteColor()
                ingredient.text = "- \(ingredients[i])"
                ingreident.lineBreakMode = NSLineBreakMode.ByWordWrapping
                var num = CGFloat(2 * count(ingredients[i]))
                ingredient.frame = CGRectMake( 2 * x, y, num * width, 10 * height)
                //ingreident.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
                ingredient.sizeToFit()
                scrollInfo.addSubview(ingredient)

                if let labels = dish?.labels {
                    if !labels.isEmpty{
                        var nutLabelXPosition = 3 * height
                        for label: String in labels[i] {
                            var nutLabel = UIImageView(frame: CGRectMake( 330 - nutLabelXPosition, y - 2 * height, 6 * height, 6 * height))
                            var image = UIImage(named: label)
                            nutLabel.image = image
                            scrollInfo.addSubview(nutLabel)
                            nutLabelXPosition += 8 * height
                        }
                    }
                }
                y += 7 * height
            }
        }
        scrollInfo.contentSize.height = y
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}