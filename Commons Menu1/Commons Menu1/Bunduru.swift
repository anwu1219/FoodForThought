//
//  Bunduru.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

//Data lives in here

struct Bunduru {
    var allRestaurants =
    ["Commons": [
        Dish(name: "Chicken Parmesan", ingredients: ["Chicken", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Beef Stroganoff", ingredients: ["Beef", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Tilapia", ingredients: ["Fish", "Other stuff"], nutrition: "Placeholder"),
        Dish(name: "Burritos", ingredients: ["Meat", "cheese"], nutrition: "Placeholder"),
        Dish(name: "Chicken tenders", ingredients: ["Chicken", "stuff"], nutrition: "Placeholder")
        ],
     "Union": [
        Dish(name: "Hamburger", ingredients: ["hamburger", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Teryaki Burger", ingredients: ["hamburger", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Cafe Ranch Burger", ingredients: ["hamburger", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Wildcat Burger", ingredients: ["hamburger", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Smokehouse Burger", ingredients: ["hamburger", "other stuff"], nutrition: "Placeholder"),
        Dish(name: "Cheeseburger", ingredients: ["hamburger", "other stuff"], nutrition: "Placeholder")
        ]
    ]
}

//Dish(name: "", ingredients: ["", ""], nutrition: "Placeholder"),