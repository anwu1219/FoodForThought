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

    
    init(name: String, image: UIImage, restDescript: String){
        self.name = name
        self.image = image
        self.restDescript = restDescript
    }

    


}