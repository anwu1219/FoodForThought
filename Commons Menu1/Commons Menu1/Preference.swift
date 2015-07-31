//
//  Preference.swift
//  Foodscape
//
//  Created by Wu, Andrew on 7/31/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import UIKit
import Parse


/**
Represents a dish
*/
class Preference: PFObject, PFSubclassing {
    // a text description of this item.
    @NSManaged var dishName : String
    @NSManaged var location : String
    @NSManaged var createdBy : PFUser

    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    
    func getPreference(object: PFObject){
        self.dishName = object["name"] as! String
        self.location = object["location"] as! String
    }
    
    
    static func parseClassName() -> String {
        return "Preference"
    }
}