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
        
    func setAsLink(textToFind:String, linkURL:String) -> Bool {
            
        let foundRange = self.mutableString.rangeOfString(textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
    
    
    func setFont(textToFind:String, font : UIFont) -> Bool {
        let foundRange = self.mutableString.rangeOfString(textToFind)
        if foundRange.location != NSNotFound {
            self.addAttributes([NSFontAttributeName : font], range: foundRange)    
            return true
        }
        return false
    }
    
    
    func setAllAsLink(textToFind: String, linkURL: String) -> Bool{
        var foundRange = self.mutableString.rangeOfString(textToFind)
        if foundRange.location != NSNotFound {
        while (foundRange.location + foundRange.length) < self.length {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            let range = NSMutableAttributedString(string: self.mutableString.substringFromIndex(foundRange.location + foundRange.length)).mutableString.rangeOfString(textToFind)
            if range.length != 0 {
                foundRange.location += foundRange.length + range.location
            } else {
                return false
            }
            }
            return true
        }
        return false
    }
}