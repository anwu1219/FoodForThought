//
//  MainMenuViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 16/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

/**
Welcome page view controller and search type for user
*/
class MainMenuViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var sustainabilityInfoButton: UIButton!
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOut()
    }
    
    let styles = Styles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        menuButton.backgroundColor = styles.buttonBackgoundColor
        menuButton.layer.cornerRadius = styles.buttonCornerRadius
        menuButton.layer.borderWidth = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

