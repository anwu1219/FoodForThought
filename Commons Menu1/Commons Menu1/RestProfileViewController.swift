//
//  RestProfileViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


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
        let darkBlueColor = UIColor(red: 0.0/255, green: 7.0/255, blue: 72.0/255, alpha: 0.75)
        restProfImage.layer.borderColor = darkBlueColor.CGColor
        restProfImage.layer.borderWidth = 2
        // Do any additional setup after loading the view.
        restProfScrollView.delegate = self
        restProfScrollView.layer.borderWidth = 1
        restProfScrollView.layer.borderColor = UIColor.blackColor().CGColor
        restProfScrollView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5)
        
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "genericBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        //sets nav bar to be see through
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        self.navigationController?.navigationBar.translucent = true

        
        susView.delegate = self
        susView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)
        
        let openHourLabel = UILabel()
        layoutScroll()
        addLabels()
    }
    
    func addLabels() {
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width
        let susWidth: CGFloat = susView.frame.width/2
        
        let labels = ["Environmental:", "Social:", "Economic:"] // dont need for menu swipe scroll
        var y: CGFloat = height * 0.01
        
        // move scroll outside for i loop
        for var i = 0; i < restProf.labels.count; i++ {
            var scroll = UIScrollView()
            
            // remove all label stuff for scroll in menu swipe
            var label = UILabel()
            
            if restProf.labels[i].count > 0 {
                label.text = labels[i]
                label.frame = CGRectMake(0.05*width, y, susWidth/2, 45)
                label.textColor = UIColor.whiteColor()
                //label.sizeToFit()
                
                scroll.frame = CGRectMake(label.frame.width+0.01*width, y, 0.5*susWidth, label.frame.height)
                susView.addSubview(scroll)
                y += label.frame.height + height * 0.01
            }
//            else {
//                label.text = "No \(labels[i]) Labels"
//                label.frame = CGRectMake(0.05*width, y, susView.frame.width-0.02*width, 50)
//                y += label.frame.height + height*0.01
//            }
            susView.addSubview(label)
            
            // this is the end of label stuff
            var x: CGFloat = 0// move this var outside for i loop and rename
            for var j = 0; j < restProf.labels[i].count; j++ {
                if count(restProf.labels[i][j]) > 0 {
                    let frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    let icon = IconButton(name: restProf.labels[i][j], frame: frame)
                    icon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    
                    
//                    var icon = UIImageView()
//                    icon.image = UIImage(named: restProf.labels[i][j])
//                    icon.frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    scroll.addSubview(icon)
                    x += icon.frame.width + width*0.01
                }
            }
            if i == 0 {
                if restProf.eco.count > 0 {
                    let frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    let ecoIcon = SuperIconButton(labels: restProf.eco, frame: frame, name: "Eco")
                    ecoIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    scroll.addSubview(ecoIcon)
                    x += ecoIcon.frame.width + width*0.01
                }
            }
            if i == 1 {
                if restProf.humane.count > 0 {
                    let frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    let ecoIcon = SuperIconButton(labels: restProf.humane, frame: frame, name: "Humane")
                    ecoIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    scroll.addSubview(ecoIcon)
                    x += ecoIcon.frame.width + width*0.01
                }
                if restProf.fair.count > 0 {
                    let frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    let ecoIcon = SuperIconButton(labels: restProf.fair, frame: frame, name: "Fair")
                    ecoIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    scroll.addSubview(ecoIcon)
                    x += ecoIcon.frame.width + width*0.01
                }
            }
            scroll.contentSize.width = x
        }
        susView.contentSize.height = y
    }
    
    
    func popup(sender: UIButton!) {
        var button = sender as! IconButton
        println(button.name)
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
            description.textColor = UIColor.whiteColor()
            description.frame = CGRectMake(0.1*width, y, restProfScrollView.frame.width*0.4, 50)
            description.lineBreakMode = .ByWordWrapping
            description.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            description.numberOfLines = 0
            description.sizeToFit()
            restProfScrollView.addSubview(description)
            y += description.frame.height + space
        }
        
        var address = UILabel()
        address.text = "Address:\n" + restProf.address
        address.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width*0.4, 50)
        address.lineBreakMode = .ByWordWrapping
        address.textColor = UIColor.whiteColor()
        address.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        address.numberOfLines = 0
        address.sizeToFit()
        restProfScrollView.addSubview(address)
        y += address.frame.height + space/3
        
        let searchInMaps = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        searchInMaps.setTitle("Search in Maps", forState: .Normal)
        searchInMaps.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
        searchInMaps.sizeToFit()
        searchInMaps.addTarget(self, action: "mapSearch:", forControlEvents: UIControlEvents.TouchUpInside)
        restProfScrollView.addSubview(searchInMaps)
        y += searchInMaps.frame.height + space
        
        var phone = UILabel()
        phone.text = "Phone:\n" + restProf.phoneNumber
        phone.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width*0.4, 50)
        phone.lineBreakMode = .ByWordWrapping
        phone.textColor = UIColor.whiteColor()
        phone.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        phone.numberOfLines = 0
        phone.sizeToFit()
        restProfScrollView.addSubview(phone)
        y += phone.frame.height + space/3
        
        let callRestaurant = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        callRestaurant.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width-(0.1*width), 50)
        callRestaurant.setTitle("Call Restaurant", forState: .Normal)
        callRestaurant.sizeToFit()
        callRestaurant.addTarget(self, action: "callNumber:", forControlEvents: UIControlEvents.TouchUpInside)
        restProfScrollView.addSubview(callRestaurant)
        y += callRestaurant.frame.height + space
        
        var url = UILabel()
        url.text = "Website:\n" + restProf.url
        url.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width*0.4, 50)
        url.lineBreakMode = .ByWordWrapping
        url.textColor = UIColor.whiteColor()
        url.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        url.numberOfLines = 0
        url.sizeToFit()
        restProfScrollView.addSubview(url)
        y += url.frame.height + space
        
        var health = UILabel()
        health.text = "Health Score:\n" + String(stringInterpolationSegment: restProf.healthScore)
        health.frame = CGRectMake(0.05*width, y, restProfScrollView.frame.width*0.4, 50)
        health.lineBreakMode = .ByWordWrapping
        health.textColor = UIColor.whiteColor()
        health.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        health.numberOfLines = 0
        health.sizeToFit()
        restProfScrollView.addSubview(health)
        y += health.frame.height + space
        
        y += height*0.01
        
        // Set up the Restaurant hours panel
        var hours = UILabel()
        hours.text = "Restaurant Hours: "
        hours.textColor = UIColor.whiteColor()
        hours.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
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
            hour.frame = CGRectMake(0.12*width, y, restProfScrollView.frame.width*0.4, 50)
            hour.lineBreakMode = .ByWordWrapping
            hour.textColor = UIColor.whiteColor()
            hour.font = UIFont(name: "HelveticaNeue-Light", size: 16)
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
            mealPlan.textColor = UIColor.whiteColor()
            mealPlan.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            mealPlan.sizeToFit()
            mealPlan.frame = CGRectMake(0.05*width, y, mealPlan.frame.width, mealPlan.frame.height)
            restProfScrollView.addSubview(mealPlan)
            y += mealPlan.frame.height
            
            for var i = 0; i < restProf.mealPlanHours.count; i++ {
                var hour = UILabel()
                hour.text = days[i] + restProf.mealPlanHours[i]
                hour.frame = CGRectMake(0.12*width, y, restProfScrollView.frame.width*0.4, 50)
                hour.lineBreakMode = .ByWordWrapping
                hour.textColor = UIColor.whiteColor()
                hour.font = UIFont(name: "HelveticaNeue-Light", size: 16)
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
    
    @IBAction func callNumber(sender:UIButton) {
        if let url = NSURL(string: "tel://\(restProf.phoneNumber)") {
            println("Call Made")
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func mapSearch(sender:UIButton) {
        //http://stackoverflow.com/questions/28604429/how-to-open-maps-app-programatically-with-coordinates-in-swift
        
        getCoordinates(restProf.address) { lat, long, error in
            if error != nil {
                println("Something went wrong with the map button in RestProfileView")
            } else {
                // use lat, long here
                let regionDistance:CLLocationDistance = 10000
                var coordinates = CLLocationCoordinate2DMake(lat, long)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                var options = [
                    MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
                ]
                var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                var mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "\(self.restProf.address)"
                mapItem.openInMapsWithLaunchOptions(options)
            }
        }
    }
    
    //http://stackoverflow.com/questions/27769859/ios-swift-coordinates-function-returns-nil
    func getCoordinates(location: String, completionHandler: (lat: CLLocationDegrees!, long: CLLocationDegrees!, error: NSError?) -> ()) -> Void {
        
        var lat:CLLocationDegrees
        var long:CLLocationDegrees
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks: [AnyObject]!, error: NSError!) in
            
            if error != nil {
                println("Geocode failed with error: \(error.localizedDescription)")
                completionHandler(lat: nil, long: nil, error: error)
                
            } else if placemarks.count > 0 {
                
                let placemark = placemarks[0] as! CLPlacemark
                let location = placemark.location
                
                let lat = location.coordinate.latitude
                let long = location.coordinate.longitude
                
                completionHandler(lat: lat, long: long, error: nil)
            }
        }
    }
    
    func showLabelInfo(sender: AnyObject) {
        let vc = UIViewController()
        let button = sender as! IconButton
        
        vc.preferredContentSize = CGSizeMake(200, 100)
        vc.modalPresentationStyle = .Popover
        
        if let pres = vc.popoverPresentationController {
            pres.delegate = self
        }
        
        let description = UILabel(frame: CGRectMake(0, 0, vc.view.frame.width/2 , vc.view.frame.height))
        description.lineBreakMode = .ByWordWrapping
        description.numberOfLines = 0
        description.textAlignment = NSTextAlignment.Center
        description.text = button.descriptionText
        description.sizeToFit()
        vc.view.addSubview(description)
        
        let popScroll = UIScrollView()
        if description.frame.width < vc.view.frame.width/2 {
            popScroll.frame = CGRectMake(0, 0, description.frame.width, description.frame.height)
        }
        else {
            popScroll.frame = CGRectMake(0, 0, vc.view.frame.width/2, vc.view.frame.height/2)
        }
        popScroll.contentSize = CGSizeMake(description.frame.width, description.frame.height)
        popScroll.addSubview(description)
        vc.view.addSubview(popScroll)
        
        vc.preferredContentSize = CGSizeMake(popScroll.frame.width, popScroll.frame.height)
        vc.modalPresentationStyle = .Popover
        
        self.presentViewController(vc, animated: true, completion: nil)
                
        if let pop = vc.popoverPresentationController {
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
        }
    }
}


extension RestProfileViewController : UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None

    }
}
