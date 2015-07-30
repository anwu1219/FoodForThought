//
//  SuperIconButton.swift
//  FoodForThought
//
//  Created by Chadinha, Spencer on 7/16/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit
class SuperIconButton: IconButton {
    let labels: [String]
    
    init(labels: [String], frame: CGRect, name: String){
        self.labels = labels
        super.init(name: name, frame: frame)
        let image = UIImage(named: self.name)
        self.setImage(image, forState: UIControlState.Normal)
        
        let descriptions = IconDescription().descriptions
        self.descriptionText = descriptions[name]!

        for var i = 0; i < labels.count; i++ {
            if count(labels[i]) > 0 {
                var description: String = descriptions[labels[i]]!
                self.descriptionText += description + "\n"
            }
        }

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}