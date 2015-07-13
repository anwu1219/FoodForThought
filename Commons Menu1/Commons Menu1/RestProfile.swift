//
//  RestProfile.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit

class RestProfile: NSObject {
    var name: String
    var image: UIImage
    var restDescript: String
    var address: String
    var hours: [String]
    var mealPlanHours: [String]
    var phoneNumber: String
    var labels: [[String]]
    var healthScore: Double
    var url: String

    
    init(name: String, image: UIImage, restDescript: String, address: String, hours: [String], mealPlanHours: [String], phoneNumber: String, labels: [[String]], heathScore: Double, url: String){
        self.name = name
        self.image = image
        self.restDescript = restDescript
        self.address = address
        self.hours = hours
        self.mealPlanHours = mealPlanHours
        self.phoneNumber = phoneNumber
        self.labels = labels
        self.healthScore = heathScore
        self.url = url
    }
}