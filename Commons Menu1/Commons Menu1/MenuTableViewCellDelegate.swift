//
//  menuTableViewCellProtocol.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/23/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol MenuTableViewCellDelegate {
    /**
    indicates that the given item has been deleted
    */
    func toDoItemDeleted(dish: Dish)
    
    
    /**
    indicates which item has been selected and provide appropriate information for a segue to dish info
    */
    // #spchadinha
    func viewDishInfo(dish: Dish)

    
}