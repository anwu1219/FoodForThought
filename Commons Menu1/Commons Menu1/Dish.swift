//
//  Dish.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/18/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//
import UIKit

class Dish: NSObject {
    // A text description of this item.
    var name: String
    var ingredients: [String] = []
    var nutrition: String = ""
    
    
    // A Boolean value that determines the completed state of this item.
    var completed: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(name: String) {
        self.name = name
        self.completed = false
    }
    
    
    init(name: String, ingredients: [String]){
        self.name = name
        self.ingredients = ingredients
        self.completed = false
    }
    
    
    init(name: String, ingredients: [String], nutrition: String){
        self.name = name
        self.ingredients = ingredients
        self.nutrition = nutrition
        self.completed = false
    }
    
}
