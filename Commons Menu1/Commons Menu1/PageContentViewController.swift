//
//  PageContentViewController.swift
//  Foodscape
//
//  Created by Wu, Andrew on 7/24/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
     var pageIndex: Int?
     var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.9 * self.view.frame.height))
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .ScaleToFill
        
        self.view.addSubview(imageView)
    }
}
