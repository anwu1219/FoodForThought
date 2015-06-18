//
//  Menu.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

struct RestaurantMenu {
    
    var menu: [Meal] = []
    
    mutating func addItem(item: Meal) -> Void {
        self.menu.append(item)
    }
    
    mutating func removeItem(item: Meal) -> Void {
        self.menu.removeAtIndex(findIndex(item))
    }
    
    func findIndex(item: Meal) -> Int {
        var i = 0
        while self.menu[i].name != item.name {
            i++
        }
        return i
    }
}