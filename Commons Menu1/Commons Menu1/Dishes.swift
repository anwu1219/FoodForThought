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
    var numberOfDishes = 0
    var dealtWith = Set<Int>()
    
    
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
    
    
    func setNumberOfDishes(number: Int){
        self.numberOfDishes = number
    }
    
    
    
    func addToDealtWith(index: Int){
        self.dealtWith.insert(index)
    }
    
    
    func removeFromDealtWith(index: Int){
        self.dealtWith.remove(index)
    }
    
    
    
    init (){
        
    }
    
}