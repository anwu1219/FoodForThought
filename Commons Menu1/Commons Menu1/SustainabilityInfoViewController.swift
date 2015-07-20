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
class SustainabilityInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let susView = UIScrollView()
    let sustainabilityImages = ["greenEarth", "heartHands", "treeCoin"]
    let susLabels = ["Environmental", "Social", "Economic"]
    let susInfo = ["Foremost, emphasis is placed on the environmental sustainability of various food products. Organic food avoids the artificiality and pollutants of ecologically harmful fertilizers, while local food requires fewer “food miles”, meaning less carbon dioxide emissions to transport the produce. Different eco labels take into account these characteristics of foods.  Education in this leads to a healthier environment that avoids unnecessary contamination and degradation of the planet.", "We also analyze the social impacts of various foods at local dining facilities, like the Vail cafeteria and the Pickled Peach restaurant. Part of this is nutritional, a society cannot function best without healthy members. We analyze the foods that are highest in protein and lowest in fat, among other criteria. This information leads potentially to changes in food-related decisions. We also consider fundamentals like farmers’ working conditions and wages.", "In order to survive in a world with limited resources, we must eat purchase food that is convenient and affordable. Our app becomes relevant for this purpose when reviewing meals outside of the Vail cafeteria, a dining hall that sets a fixed price (roughly $10-12) for all-you-can-eat meals. At other dining facilities, price can, depending on your priorities, become a significant factor when deciding on meal choices."]


    @IBAction func learnMoreAction(sender: UIButton!) {
            let vc = UIViewController()
            vc.preferredContentSize = CGSizeMake(screenSize.width, screenSize.height)
            vc.modalPresentationStyle = .Popover
            if let pres = vc.popoverPresentationController {
                pres.delegate = self
            }
            
            let wv = UIWebView()
            vc.view.addSubview(wv)
            wv.frame = vc.view.bounds
            wv.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            let url = NSURL(string: "http://sites.davidson.edu/sustainabilityscholars/")
            let request = NSURLRequest(URL: url!)
            wv.loadRequest(request)
            
            self.presentViewController(vc, animated: true, completion: nil)
            
            if let pop = vc.popoverPresentationController {
                pop.sourceView = (sender as UIView)
                pop.sourceRect = (sender as UIView).bounds
            }
        }
    
    override func viewDidLoad() {
        let verticalSpace = 0.05 * screenSize.height
        let widthPadding = 0.05 * screenSize.width
        var y: CGFloat = 0.0
        susView.backgroundColor = UIColor(red: 243/255.0, green: 244/255.0, blue: 230/255.0, alpha: 1)
        susView.layer.borderColor = UIColor(red: 64/255.0, green: 55/255.0, blue: 74/255.0, alpha: 0.95).CGColor
        susView.layer.borderWidth = 10
        susView.layer.cornerRadius = 5
        self.navigationController?.navigationBar.translucent = true

        
        super.viewDidLoad()
        
        susView.frame = CGRectMake(widthPadding, 3.5*verticalSpace, screenSize.width-(2*widthPadding), screenSize.height - (4*verticalSpace))
        let background = UIImageView()
        background.image = UIImage(named: "SustyPageBackground")
        background.frame = CGRectMake(0.0, 0.0, screenSize.width, screenSize.height) // will need to change with new images
        background.bounds = background.bounds
        background.contentMode = .ScaleToFill
        self.view.addSubview(background)
        //self.view.sendSubviewToBack(background)

        
        for var i = 0; i < 3; i++ {
            let container = UIView()
            let header = UILabel()
            let image = UIImageView()
            let body = UILabel()
            let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            
            // Set the subsection's header
            header.text = susLabels[i]
            header.font = UIFont(name: "Helvetica", size: 30)
            header.textColor = UIColor.whiteColor()
            header.layer.shadowOffset = CGSizeMake(2, 2)
            header.layer.shadowColor = UIColor.blackColor().CGColor
            header.layer.shadowOpacity = 0.7
            header.layer.shadowRadius = 3.0
            header.frame = CGRectMake(0.0, y+verticalSpace, susView.frame.width, 50.0)
            header.sizeToFit()
            header.frame = CGRectMake(0.0, y+verticalSpace, susView.frame.width, header.frame.height)
            header.textAlignment = .Center
            susView.addSubview(header)
            y += 50.0 + verticalSpace
            
            // set the subsection's image
            image.image = UIImage(named: sustainabilityImages[i])
            image.frame = CGRectMake(0.0, y, susView.frame.width, 100)
            image.contentMode = .ScaleAspectFit
            susView.addSubview(image)
            y += 100+verticalSpace
            
            // set the subsection's body text
            body.text = susInfo[i]
            body.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            body.textColor = UIColor(red: 64/255.0, green: 55/255.0, blue: 74/255.0, alpha: 0.95)
            body.lineBreakMode = NSLineBreakMode.ByWordWrapping
            body.numberOfLines = 0
            body.frame = CGRectMake(0.0, y, 1000, 1000)
            body.sizeToFit()
            body.frame = CGRectMake(widthPadding, y, susView.frame.width - (2*widthPadding), body.frame.height)
            body.textAlignment = .Center
            susView.addSubview(body)
            y += body.frame.height + verticalSpace
            
            // set the section's learn more button
            button.setTitle("Learn More", forState: UIControlState.Normal)
            button.addTarget(self, action: "learnMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
            button.frame = CGRectMake(susView.frame.width*0.2, y, susView.frame.width*0.6, 50)
            button.backgroundColor = UIColor.yellowColor()
            susView.addSubview(button)
            y += 50 + verticalSpace
            
        }
        susView.contentSize.height = y + verticalSpace
        self.view.addSubview(susView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//https://github.com/mattneub/Programming-iOS-Book-Examples/tree/master/bk2ch09p477popoversOnPhone/PopoverOnPhone
extension SustainabilityInfoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .FullScreen
    }
    
     func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let vc = controller.presentedViewController
        let nav = UINavigationController(rootViewController: vc)
        let b = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissHelp:")
        vc.navigationItem.rightBarButtonItem = b
        return nav
    }
    
    func dismissHelp(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}