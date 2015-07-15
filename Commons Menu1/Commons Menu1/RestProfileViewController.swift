//
//  RestProfileViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class RestProfileViewController: UIViewController, UIScrollViewDelegate {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var restProf : RestProfile!
    let styles = Styles()
    
    @IBOutlet weak var restProfDescription: UILabel!
    @IBOutlet weak var restProfImage: UIImageView!
    @IBOutlet weak var restProfName: UINavigationItem!
    @IBOutlet var restProfileView: UIView!
    @IBOutlet weak var restProfScrollView: UIScrollView!
    
    
    @IBOutlet weak var susView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restProf?.name
        restProfImage.image = restProf.image
        restProfImage.layer.borderColor = UIColor.blueColor().CGColor
        restProfImage.layer.borderWidth = 2
        // Do any additional setup after loading the view.
        restProfScrollView.delegate = self
        restProfScrollView.layer.borderWidth = 2
        restProfScrollView.layer.borderColor = UIColor.blackColor().CGColor
        restProfScrollView.backgroundColor = UIColor(red: 147/255.0, green: 143/255.0, blue: 161/255.0, alpha: 0.75)
        
        susView.delegate = self
        susView.layer.borderWidth = 2
        susView.layer.borderColor = UIColor.blackColor().CGColor
        susView.backgroundColor = UIColor(red: 147/255.0, green: 143/255.0, blue: 161/255.0, alpha: 0.75)
        
        let openHourLabel = UILabel()
        layoutScroll()
        addLabels()
        
        // restWeekdayHoursLabel.text = restProf!.weekdayHours
        // restWeekendHoursLabel.text = restProf!.weekendHours
        // restWeekdayHoursLabel.numberOfLines = 2
        // restWeekendHoursLabel.numberOfLines = 2
        // restPhoneNumLabel.text = restProf!.phoneNumber
        // restAddressLabel.text = restProf!.address
    }
    
    func addLabels() {
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width
        let labels = ["Environmental", "Social", "Economic"]
        var y: CGFloat = height * 0.01
        for var i = 0; i < restProf.labels.count; i++ {
            var scroll = UIScrollView()
            var label = UILabel()
            if restProf.labels[i].count > 0 {
                label.text = labels[i]
                label.frame = CGRectMake(0.01*width, y, susView.frame.width/2, 50)
                //label.sizeToFit()
                
                scroll.frame = CGRectMake(0.5*susView.frame.width, y, 0.65*susView.frame.width, label.frame.height)
                susView.addSubview(scroll)
                y += label.frame.height + height*0.01
            }
            else {
                label.text = "No \(labels[i]) Labels"
                label.frame = CGRectMake(0.05*width, y, susView.frame.width-0.02*width, 50)
                y += label.frame.height + height*0.01
            }
            susView.addSubview(label)
            var x: CGFloat = width*0.05
            for var j = 0; j < restProf.labels[i].count; j++ {
                if count(restProf.labels[i][j]) > 0 {
                    var icon = UIImageView()
                    icon.image = UIImage(named: restProf.labels[i][j])
                    icon.frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    scroll.addSubview(icon)
                    x += icon.frame.width + width*0.01
                }
            }
            scroll.contentSize.width = x
        }
        susView.contentSize.height = y
    }
    
    func layoutScroll() {
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width
        let space = width*0.05
        
        var y: CGFloat = restProfScrollView.frame.height * 0.05
        
        if count(restProf.description) > 0 {
            var description = UILabel()
            description.text = "\"\(restProf.restDescript)\""
            description.textAlignment = .Center
            description.frame = CGRectMake(0.1*width, y, restProfScrollView.frame.width-(0.05*width), 50)
            description.lineBreakMode = .ByWordWrapping
            description.numberOfLines = 0
            description.sizeToFit()
            restProfScrollView.addSubview(description)
            y += description.frame.height + space
        }
        
        var address = UILabel()
        address.text = "Address:\n" + restProf.address
        address.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
        address.lineBreakMode = .ByWordWrapping
        address.numberOfLines = 0
        address.sizeToFit()
        restProfScrollView.addSubview(address)
        y += address.frame.height + space
        
        var phone = UILabel()
        phone.text = "Phone:\n" + restProf.phoneNumber
        phone.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
        phone.lineBreakMode = .ByWordWrapping
        phone.numberOfLines = 0
        phone.sizeToFit()
        restProfScrollView.addSubview(phone)
        y += phone.frame.height + space
        
        //throws SIGABRT ERROR right now, plz fixs
//        var phone1 = UIButton()
//        phone1.setTitle("Phone: " + restProf.phoneNumber, forState: .Normal)
//        phone1.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
//        phone1.sizeToFit()
//        phone1.addTarget(self, action: "callNumber", forControlEvents: UIControlEvents.TouchUpInside)
//        restProfScrollView.addSubview(phone1)
//        y += phone1.frame.height + space
        
        var url = UILabel()
        url.text = "Website:\n" + restProf.url
        url.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
        url.lineBreakMode = .ByWordWrapping
        url.numberOfLines = 0
        url.sizeToFit()
        restProfScrollView.addSubview(url)
        y += url.frame.height + space
        
        var health = UILabel()
        health.text = "Health Score:\n" + String(stringInterpolationSegment: restProf.healthScore)
        health.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
        health.lineBreakMode = .ByWordWrapping
        health.numberOfLines = 0
        health.sizeToFit()
        restProfScrollView.addSubview(health)
        y += health.frame.height + space
        
        y += height*0.01
        
        // Set up the Restaurant hours panel
        var hours = UILabel()
        hours.text = "Restaurant Hours: "
        hours.sizeToFit()
        hours.frame = CGRectMake(0.05*width, y, hours.frame.width, hours.frame.height)
        restProfScrollView.addSubview(hours)
        y += hours.frame.height
        let days = ["Monday\n", "Tuesday\n", "Wednesday\n", "Thursday\n", "Friday\n", "Saturday\n", "Sunday\n"]
        for var i = 0; i < restProf.hours.count; i++ {
            var hour = UILabel()
            if count(restProf.hours[i]) > 0 {
                hour.text = days[i] + restProf.hours[i]
            }
            else {
                hour.text = days[i] + "Closed"
            }
            hour.frame = CGRectMake(0.12*width, y, restProfScrollView.frame.width-(0.05*width), 50)
            hour.lineBreakMode = .ByWordWrapping
            hour.numberOfLines = 0
            hour.sizeToFit()
            restProfScrollView.addSubview(hour)
            y += hour.frame.height + height*0.01
        }
        y += space
        
        // Set up Meal Plan hours
        if count(restProf.mealPlanHours[0]) > 0 {
            var mealPlan = UILabel()
            mealPlan.text = "Davidson Meal Plan Hours:"
            mealPlan.sizeToFit()
            mealPlan.frame = CGRectMake(0.05*width, y, mealPlan.frame.width, mealPlan.frame.height)
            restProfScrollView.addSubview(mealPlan)
            y += mealPlan.frame.height
            
            for var i = 0; i < restProf.mealPlanHours.count; i++ {
                var hour = UILabel()
                hour.text = days[i] + restProf.mealPlanHours[i]
                hour.frame = CGRectMake(0.12*width, y, restProfScrollView.frame.width-(0.05*width), 50)
                hour.lineBreakMode = .ByWordWrapping
                hour.numberOfLines = 0
                hour.sizeToFit()
                restProfScrollView.addSubview(hour)
                y += hour.frame.height + height*0.01
            }
        }
        
        
        
        restProfScrollView.contentSize.height = y
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func callPhone(sender: UIButton) {
//        var url:NSURL = NSURL(fileURLWithPath: restProf.phoneNumber)!
//        UIApplication.sharedApplication().openURL(url)
//    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(restProf.phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
