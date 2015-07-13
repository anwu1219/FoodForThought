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
    var restDescript: [String]
    var address: String
    var weekdayHours: String
    var weekendHours: String
    var phoneNumber: String
    var label: [[String]]
    var healthScore: Double

    
    init(name: String, image: UIImage, restDescript: [String], address: String, weekdayHours: String, weekendHours: String, phoneNumber: String, label: [[String]], heathScore: Double){
        self.name = name
        self.image = image
        self.restDescript = restDescript
        self.address = address
        self.weekdayHours = weekdayHours
        self.weekendHours = weekendHours
        self.phoneNumber = phoneNumber
        self.label = label
        self.healthScore = heathScore
    }
}