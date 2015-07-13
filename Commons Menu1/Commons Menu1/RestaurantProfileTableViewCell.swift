//
//  RestaurantProfileTableViewCell.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 10/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import QuartzCore
import Parse

class RestaurantProfileTableViewCell: UITableViewCell {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // ensure the gradient layer occupies the full bounds
        
        var width = 0.01 * bounds.size.width
        var height = 0.01 * bounds.size.height
        let kLabelLeftMargin: CGFloat = 36 * width
        let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0

                self.imageView?.frame = CGRect(x: 10 * width, y: 20 * height, width: 18 * width, height: 60 * height)
        //  self.imageView?.bounds = CGRectMake(0, 0, 30, 30)
        self.backgroundColor = UIColor(red: 147/255.0, green: 143/255.0, blue: 161/255.0, alpha: 0.75)
        
        
    }

    
}