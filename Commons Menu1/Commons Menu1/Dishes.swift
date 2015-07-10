//
//  Dishes.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 7/9/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

class Dishes{
    var dishes = [RestProfile: [Dish]]()
    
    func addDish(location: String, dish : Dish){
        for restaurant : RestProfile in dishes.keys {
            if restaurant.name == location {
                dishes[restaurant]?.append(dish)
            }
        }
    }
    
    func addRestaurant(restaurant: RestProfile) {
        if !contains(dishes.keys, restaurant){
            dishes[restaurant] = [Dish]()
        }
    }
    
    
    init (){
        
    }
    
}