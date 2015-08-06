//
//  NSAttributedStringExtension.swift
//  Foodscape
//
//  Created by Wu, Andrew on 8/6/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import Foundation
import UIKit


extension NSMutableAttributedString {
        
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
            
        let foundRange = self.mutableString.rangeOfString(textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}