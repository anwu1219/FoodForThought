//
//  Meal.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

struct Meal {
    var name: String
    var ingredients: [Ingredient]
    
    init(name: String) {
        self.name = name
        self.ingredients = []
    }
    
    init(name:String, ingredients: [Ingredient]) {
        self.name = name
        self.ingredients = ingredients
    }
    
    

    
    mutating func addIngredient(ingredient: Ingredient) {
        ingredients.append(ingredient)
    }
    
    mutating func changeName(name: String) {
        self.name = name
    }
    
    mutating func removeIngredient(ingredient: Ingredient) {
        self.ingredients.removeAtIndex(findIndex(ingredient))
    }
    
    func findIndex(item: Ingredient) -> Int {
        var i = 0
        while self.ingredients[i].name != item.name {
            i++
        }
        return i
    }
    
}


