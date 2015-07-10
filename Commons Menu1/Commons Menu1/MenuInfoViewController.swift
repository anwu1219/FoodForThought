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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishName.title = dish?.name
        dishImage.image = dish?.image
        dish?.price = 8.54
        scrollInfo.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        var scrollViewHeight = 350
        if let ingredient = dish?.ingredients{
            scrollViewHeight += ingredient.count * 30
        }
        scrollInfo.contentSize.height = CGFloat(scrollViewHeight)
        scrollInfo.layer.borderColor = UIColor.greenColor().CGColor
        scrollInfo.layer.borderWidth = 2
        layoutPage()
        
    }
    
    
    /**
    Put dish information into the scrollInfo
    */
    func layoutPage() {
        var width: CGFloat = 0.01 * scrollInfo.bounds.width // a unit of x
        var height: CGFloat = 0.01 * scrollInfo.bounds.height // a unit of y
        var x: CGFloat = 0.02 * scrollInfo.bounds.width // current x coordinate
        var y: CGFloat = 0.05 * scrollInfo.bounds.height // current y coordinate
        
        if let susLabels = dish?.labels {
            if susLabels.count > 0 {
                var title = UILabel()
                title.text = "Dish Sustainability Info \(susLabels.count)"
                title.frame = CGRectMake(x, y, 57*width, 20*height)
                title.textAlignment = .Center
                title.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                scrollInfo.addSubview(title)
                y += 20 * height
                
                var labelPics = UIScrollView()
                labelPics.frame = title.frame
                
                /*
                Dynamically resize the scroll view to center itself on the page
                    - determine the number of labels to be placed in view
                    - set content size == (numlabels*size) + (numlabels - 1) * spacing
                    - if content size is lower than the outer view width, place the beginning of the scrollview half the difference between the content size and the outer view width
                    - else make frame equal to the outer width size
                */
//                var scrollLabels = UIScrollView()
//                var imageX =
//                for label in susLabels {
//                    
//                }
            }
            
            
        }
        
        if let location = dish?.location {
            var label = UILabel()
            label.text = "Location: \(location)"
            label.frame = CGRectMake( x, y, 20 * width, 10 * height)
            label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            scrollInfo.addSubview(label)
            y += 10 * height
        }
        
        if let price = dish?.price {
            var label = UILabel()
            label.text = "Price: $\(price)"
            label.frame = CGRectMake(x, y, 20 * width, 10 * height)
            label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            scrollInfo.addSubview(label)
            y += 10 * height
        }
        
        
        if let ingredients = dish?.ingredients {
            //label.numberOfLines = 0 // allows for undetermined number of lines to be used to display text
            var ingreident = UILabel()
            ingreident.text = "Ingredients:"
            ingreident.frame = CGRectMake(x, y, 20 * width, 10 * height)
            scrollInfo.addSubview(ingreident)
            y += 12 * height
            for var i = 0; i < ingredients.count; i++ {
                var ingredient = UILabel()
                ingredient.text = "- \(ingredients[i])"
                ingreident.lineBreakMode = NSLineBreakMode.ByWordWrapping
                var num = CGFloat(2 * count(ingredients[i]))
                ingredient.frame = CGRectMake( 2 * x, y, num * width, 10 * height)
                ingreident.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
                ingredient.sizeToFit()
                scrollInfo.addSubview(ingredient)

                if let labels = dish?.labels {
                    if !labels.isEmpty{
                        var nutLabelXPosition = 10 * height
                        for label: String in labels[i] {
                            var nutLabel = UIImageView(frame: CGRectMake( 330 - nutLabelXPosition, y - 2 * height, 10 * height, 10 * height))
                            var image = UIImage(named: label)
                            nutLabel.image = image
                            scrollInfo.addSubview(nutLabel)
                            nutLabelXPosition += 11 * height
                        }
                    }
                }
                y += 10 * height
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}