//
//  File.swift
//  Foodscape
//
//  Created by Wu, Andrew on 7/29/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{

    func setBackground(fileName : String){
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: fileName)
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
    }
}