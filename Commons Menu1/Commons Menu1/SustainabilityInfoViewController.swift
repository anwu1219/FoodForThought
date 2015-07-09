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
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let testView = UIScrollView()
    let sustainabilityImages = ["greenEarth", "heartHands", "treeCoin"]
    let susLabels = ["Environmental", "Social", "Economic"]
    let susInfo = ["blah", "blah blah", "blah blah blah"]

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
        let verticalSpace = 0.05 * screenSize.height
        let widthPadding = 0.05 * screenSize.width
        var y: CGFloat = 0.0
        testView.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 0.9, alpha: 1.0)
        testView.layer.borderColor = UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0).CGColor
        testView.layer.borderWidth = 10
        testView.layer.cornerRadius = 5

        
        super.viewDidLoad()
        
        testView.frame = CGRectMake(widthPadding, 110.0, screenSize.width-(2*widthPadding), 520)
        let background = UIImageView()
        background.image = UIImage(named: "wheat")
        background.frame = self.view.frame
        background.contentMode = .ScaleAspectFill
        self.view.addSubview(background)
        //self.view.sendSubviewToBack(background)
        
        for var i = 0; i < 3; i++ {
            let container = UIView()
            let header = UILabel()
            let image = UIImageView()
            let body = UILabel()
            let button = UIButton()
            
            // Set the subsection's header
            header.text = susLabels[i]
            header.font = UIFont(name: "Helvetica", size: 30)
            header.frame = CGRectMake(0.0, y+verticalSpace, testView.frame.width, 50.0)
            header.sizeToFit()
            header.frame = CGRectMake(0.0, y+verticalSpace, testView.frame.width, header.frame.height)
            header.textAlignment = .Center
            testView.addSubview(header)
            y += 50.0 + verticalSpace
            
            // set the subsection's image
            image.image = UIImage(named: sustainabilityImages[i])
            image.frame = CGRectMake(0.0, y, testView.frame.width, 100)
            image.contentMode = .ScaleAspectFit
            testView.addSubview(image)
            y += 100+verticalSpace
            
            // set the subsection's body text
            body.text = susInfo[i]
            body.lineBreakMode = NSLineBreakMode.ByWordWrapping
            body.numberOfLines = 0
            body.frame = CGRectMake(0.0, y, 1000, 1000)
            body.sizeToFit()
            body.frame = CGRectMake(0, y, testView.frame.width, body.frame.height)
            body.textAlignment = .Center
            testView.addSubview(body)
            y += body.frame.height + verticalSpace
            
        }
        testView.contentSize.height = y + verticalSpace
        self.view.addSubview(testView)
        scrollView.hidden = true
        //scrollView.contentSize.height = 1000
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}