//
//  StringExtension.swift
//  Foodscape
//
//  Created by Wu, Andrew on 8/5/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import UIKit


extension String {
    
    
    
    var html2AttStr: NSMutableAttributedString {
        do {
            
            let str = try NSMutableAttributedString(data: dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            return str
            
        } catch {
            //print(error)
        }
    return NSMutableAttributedString()
    }
}


