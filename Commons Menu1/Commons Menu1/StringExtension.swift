//
//  StringExtension.swift
//  Foodscape
//
//  Created by Wu, Andrew on 8/5/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import UIKit


extension String {
    var html2AttStr: NSAttributedString {
        return NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil, error: nil)!
    }
}