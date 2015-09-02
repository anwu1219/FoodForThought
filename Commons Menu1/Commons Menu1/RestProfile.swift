//
//  RestProfile.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit
import Parse


class RestProfile: PFObject, PFSubclassing {
     @NSManaged var name: String
     @NSManaged var restDescript: String
     @NSManaged var address: String
     @NSManaged var hours: [String]
     @NSManaged var mealPlanHours: [String]
     @NSManaged var phoneNumber: String
     @NSManaged var labels: [[String]]
     @NSManaged var healthScore: Double
     @NSManaged var url: String
     @NSManaged var eco : [String]
     @NSManaged var fair : [String]
     @NSManaged var humane : [String]
     @NSManaged var imageFile: PFFile
     @NSManaged var dynamicTypes : [String]
    @NSManaged var coordinates : String
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Restaurant"
    }
    
    func fetchRestData(object: PFObject){
        self.name = object["name"] as! String
        self.imageFile = object["image"] as! PFFile
        self.address = object["address"] as! String
        self.phoneNumber = object["number"] as! String
        self.hours = object["hours"] as! [String]
        self.restDescript = object["restDescription"] as! String
        self.labels = object["labelDescription"] as! [[String]]
        self.healthScore = object["healthScore"] as! Double
        self.mealPlanHours = object["mealPlanHours"] as! [String]
        self.url = object["website"] as! String
        self.eco = object["eco"] as! [String]
        self.fair = object["fair"] as! [String]
        self.humane = object["humane"] as! [String]
        self.dynamicTypes = object["dynamic"] as! [String]
        self.coordinates = object["coordinates"] as! String
    }
}