//
//  Dish.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/18/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.

import UIKit


/**
Represents a dish
*/
class Dish: NSObject {
    // a text description of this item.
    var name: String
    var ingredients: [String]?
    var image: UIImage?
    // for off-campus dining service
    var allergens: [String]?
    // food source, and other sustainability info
    var chefNote: [String]?
    var ecoLabel: [String]?
    // for on campus dining service
    var nutritionistNote: String?
    var price: Double?
    // a Boolean value that determines whether the user liked the dish %anwu
    var like: Bool = false
    var location: String?
    var dealtWith: Bool = false

    
    init(name: String) {
        self.name = name
    }
    
    
    init (name: String, ingredients: [String]?){
        self.name = name
        self.ingredients = ingredients
    }
    
    init(name: String, image: UIImage, location: String){
        self.name = name
        self.image = image
        self.location = location
    }
    
    init(name: String, image: UIImage, like: Bool, location: String) {
        self.name = name
        self.image = image
        self.like = like
        self.location = location
    }
    
    init (name: String, ingredients: [String], image: UIImage, allergens: [String], chefNote: [String], ecoLabel: [String], nutritionistNote: String, price: Double){
        self.name = name
        self.ingredients = ingredients
        self.image = image
        self.allergens = allergens
        self.chefNote = chefNote
        self.ecoLabel = ecoLabel
        self.nutritionistNote = nutritionistNote
        self.price = price
    }
    
}
