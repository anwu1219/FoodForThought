//
//  FoodTinderViewCellDelegate.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 29/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol FoodTinderViewCellDelegate {
    /**
    indicates that the given item has been deleted
    */
    func toDoItemDeleted(dish: Dish)
    
    
    /**
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    func viewDishInfo(dish: Dish)
    
    func addToPreferences(dish: Dish)
    
    func deleteFromPreferences(dish: Dish)

}