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
    
    // A Boolean value that determines the completed state of this item.
    var completed: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(text: String) {
        self.name = text
        self.completed = false
    }
    
    
    
    
}
