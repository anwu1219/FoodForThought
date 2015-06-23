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
        Dish(name: "Chicken Parmesan", ingredients: ["Chicken", "other stuff"]),
        Dish(name: "Beef Stroganoff", ingredients: ["Beef", "other stuff"]),
        Dish(name: "Tilapia", ingredients: ["Fish", "Other stuff"]),
        Dish(name: "Burritos", ingredients: ["Meat", "cheese"]),
        Dish(name: "Chicken tenders", ingredients: ["Chicken", "stuff"])
        ],
     "Union": [
        Dish(name: "Hamburger", ingredients: ["hamburger", "other stuff"]),
        Dish(name: "Teryaki Burger", ingredients: ["hamburger", "other stuff"]),
        Dish(name: "Cafe Ranch Burger", ingredients: ["hamburger", "other stuff"]),
        Dish(name: "Wildcat Burger", ingredients: ["hamburger", "other stuff"]),
        Dish(name: "Smokehouse Burger", ingredients: ["hamburger", "other stuff"]),
        Dish(name: "Cheeseburger", ingredients: ["hamburger", "other stuff"])
        ]
    ]
}

//Dish(name: "", ingredients: ["", ""], nutrition: "Placeholder"),