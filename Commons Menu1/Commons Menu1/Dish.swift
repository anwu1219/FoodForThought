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
    @NSManaged var type : String
    @NSManaged var index : Int
    @NSManaged var susLabels : [String] //Sustainability Labels on dish level
    @NSManaged var eco : [String]
    @NSManaged var fair : [String]
    @NSManaged var humane : [String]
    var imageFile : PFFile!
    var image : UIImage!
    var like: Bool = false
    var dislike: Bool = false
    var date : String!
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    
    func getDishData(object: PFObject){
        self.name = object["name"] as! String
        self.location = object["location"] as! String
        self.ingredients = object["ingredients"] as! [String]
        self.labels = object["labels"] as! [[String]]
        self.type = object["type"] as! String
        self.susLabels = object["susLabels"] as! [String]
        self.index = object["index"] as! Int
        self.eco = object["eco"] as! [String]
        self.fair = object["fair"] as! [String]
        self.humane = object["humane"] as! [String]
        self.price = object["price"] as! String
        if let imageFile =  object["image"] as? PFFile{
            self.imageFile = imageFile
        }
        if let date = object["displayDate"] as? String {
            self.date = date
        }
    }
    
    static func parseClassName() -> String {
        return "dishInfo"
    }
}