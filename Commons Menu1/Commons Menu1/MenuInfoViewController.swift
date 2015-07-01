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
    var dish: Dish?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dishName.title = dish?.name
        dishImage.image = dish?.image
        dish?.price = 8.54
        dish?.ingredients = ["sdf"]
        scrollInfo.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        scrollInfo.contentSize.height = 800
        scrollInfo.layer.borderColor = UIColor.greenColor().CGColor
        scrollInfo.layer.borderWidth = 2
        layoutPage()
        
        
    }
    
    func layoutPage() {
        var x: CGFloat = 0.05 * scrollInfo.bounds.width
        var y: CGFloat = 0.05 * scrollInfo.bounds.height
        var width: CGFloat = 0.5 * scrollInfo.bounds.width
        var height: CGFloat = 0.1 * scrollInfo.bounds.height
        
        if let location = dish?.location {
            var label = UILabel()
            label.text = "Location: \(location)"
            label.frame = CGRectMake(x, y, width, height)
            label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            scrollInfo.addSubview(label)
            y += 1.3 * height
        }
        
        if let price = dish?.price {
            var label = UILabel()
            label.text = "Price: $\(price)"
            label.frame = CGRectMake(x, y, width, height)
            scrollInfo.addSubview(label)
            y += 1.3 * height
        }
        
        
        if let ingredients = dish?.ingredients {
            var maxLabelSize = CGSizeMake(CGFloat(FLT_MAX), CGFloat(FLT_MAX))
            var label = UILabel()
            label.numberOfLines = 0 // allows for undetermined number of lines to be used to display text
            //label.frame =
            var test = ""
            test += "Ingredients:\n asdf \n asdf \n asdf "
            for ing in ingredients {
                test += " - \(ing)\n"
            }
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.sizeToFit()
            label.text = test
            label.frame = CGRectMake(x, y, width, height*CGFloat(ingredients.count))
            scrollInfo.addSubview(label)
            y += 1.3 * height
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}