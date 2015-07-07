//
//  SustainabilityInfoViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//


import UIKit

/**
Displays information of sustainability and links to sustainability info
*/
class SustainabilityInfoViewController: UIViewController {
    
    

    @IBOutlet weak var scrollView: UIScrollView!

    @IBAction func learnMoreAction(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://sites.davidson.edu/sustainabilityscholars/")!)
    }
    
    @IBAction func learnMoreAction2(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://sites.davidson.edu/sustainabilityscholars/")!)
    }
    
    @IBAction func learnMoreAction3(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://sites.davidson.edu/sustainabilityscholars/")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.contentSize.height = 1000
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}