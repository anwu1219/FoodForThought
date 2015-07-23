//
//  Dish.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/18/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.

import UIKit
import Parse


/**
Represents a dish
*/
class Dish: PFObject, PFSubclassing {
    // a text description of this item.
    @NSManaged var name : String
    @NSManaged var location : String
    @NSManaged var ingredients: [String]
    @NSManaged var labels : [[String]]//Nutritionist Labels for Commons
    // for off-campus dining service
    
    @NSManaged var allergens: [String]
    // food source, and other sustainability info
    @NSManaged var chefNote: String
    @NSManaged var ecoLabel: [String]
    // for on campus dining service
    @NSManaged var nutritionistNote: String
    @NSManaged var price: String
    // a Boolean value that determines whether the user liked the dish %anwu
    var like: Bool = false
    var dislike: Bool = false
    @NSManaged var type : String
    @NSManaged var index : Int
    @NSManaged var susLabels : [String] //Sustainability Labels on dish level
    @NSManaged var eco : [String]
    @NSManaged var fair : [String]
    @NSManaged var humane : [String]
    @NSManaged var imageFile : PFFile
    @NSManaged var image : UIImage

    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    
    static func parseClassName() -> String {
        return "dishInfo"
    }
}
