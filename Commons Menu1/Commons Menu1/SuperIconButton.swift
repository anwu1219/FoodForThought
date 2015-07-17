//
//  SuperIconButton.swift
//  FoodForThought
//
//  Created by Chadinha, Spencer on 7/16/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit

class SuperIconButton: UIButton {
    let labels: [String]
    let name: String
    var descriptionText = String()
    
    init(labels: [String], frame: CGRect, name: String){
        self.labels = labels
        self.name = name
        
        let descriptions = IconDescription().descriptions
        descriptionText = descriptions[name]!
        for var i = 0; i < labels.count; i++ {
            if count(labels[i]) > 0 {
                self.descriptionText += descriptions[labels[i]]!
            }
        }
        super.init(frame: frame)
        
        let image = UIImage(named: self.name)
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}