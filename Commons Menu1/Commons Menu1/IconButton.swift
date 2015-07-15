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
    
    let descriptions = [
        "EC" : "This label is awarded to foods that contain healthy carbs",
        "FS" : "",
        "L" : "",
        "CE" : "",
        "HF" : "",
        "PP" : "",
        "VN" : "",
        "SE" : "",
        "C" : "",
        "ES" : "",
        "LA" : "",
        "R" : "",
        "AI" : "" ,
        "CA" : "",
        "FD" : "",
        "MD": "",
        "VO" : ""
    ]
    
    init(name: String, frame: CGRect){
        self.name = name
        
        super.init(frame: frame)
        
        let image = UIImage(named: name)
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}