//
//  popupIcon.swift
//  Commons Menu1
//
//  Created by Chadinha, Spencer on 7/15/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit

class IconButton: UIButton {
    let name: String
    var descriptionText = String()
    
    init(name: String, frame: CGRect){
        self.name = name
        self.descriptionText = IconDescription().descriptions[name]!
        super.init(frame: frame)
        
        let image = UIImage(named: name)
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}