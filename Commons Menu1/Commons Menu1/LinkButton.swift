//
//  LinkButton.swift
//  FoodForThought
//
//  Created by Chadinha, Spencer on 7/17/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit

class LinkButton: UIButton {
    let name: String
    
    init(name: String, frame: CGRect){
        self.name = name
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}