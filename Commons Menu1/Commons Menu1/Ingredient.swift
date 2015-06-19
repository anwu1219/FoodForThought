//
//  Ingredient.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

struct Ingredient {
    var name: String
    var whereFrom: String
    var ecoLabels: [String]
    
    init(name: String, whereFrom: String) {
        self.name = name
        self.whereFrom = whereFrom
        self.ecoLabels = []
    }
    
    init(name: String, whereFrom: String, ecoLabels: [String]) {
        self.name = name
        self.whereFrom = whereFrom
        self.ecoLabels = ecoLabels
    }
    
    mutating func addEcoLabel(label: String) {
        self.ecoLabels.append(label)
    }
    
    mutating func removeEcoLabel(label: String) {
        self.ecoLabels.removeAtIndex(findIndex(label))
    }
    
    func findIndex(item: String) -> Int {
        var i = 0
        while self.ecoLabels[i] != item {
            i++
        }
        return i
    }
}