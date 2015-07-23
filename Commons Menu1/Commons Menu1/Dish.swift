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
class Dish: NSObject {
    // a text description of this item.
    var name: String
    var ingredients: [String]?
    var labels : [[String]]? //Nutritionist Labels for Commons
    // for off-campus dining service
    var allergens: [String]?
    // food source, and other sustainability info
    var chefNote: String?
    var ecoLabel: [String]?
    // for on campus dining service
    var nutritionistNote: String?
    var price: String?
    // a Boolean value that determines whether the user liked the dish %anwu
    var like: Bool = false
    var dislike: Bool = false
    var location = String()
    var type = String()
    var index = 0
    var susLabels = [String]() //Sustainability Labels on dish level
    var eco = [String]()
    var fair = [String]()
    var humane = [String]()
    var imageFile : PFFile?
    var image : UIImage?
    
    
    init(name: String) {
        self.name = name
    }
    
    
    init (name: String, ingredients: [String]?){
        self.name = name
        self.ingredients = ingredients
    }
    
    init(name: String, location: String, type: String, ingredients: [String], labels: [[String]], index : Int, price: String?, susLabels: [String], eco : [String], fair : [String], humane : [String], imageFile : PFFile){
        self.name = name
        self.location = location
        self.type = type
        self.ingredients = ingredients
        self.labels = labels
        self.index = index
        self.price = price
        self.susLabels = susLabels
        self.eco = eco
        self.fair = fair
        self.humane = humane
        self.imageFile = imageFile
    }
    
    
    
    init(name: String, location: String, type: String, ingredients: [String], labels: [[String]], index : Int,  price: String, susLabels: [String], eco : [String], fair : [String], humane : [String]){
        self.name = name
        self.location = location
        self.type = type
        self.ingredients = ingredients
        self.labels = labels
        self.index = index
        self.price = price
        self.susLabels = susLabels
    }
}
