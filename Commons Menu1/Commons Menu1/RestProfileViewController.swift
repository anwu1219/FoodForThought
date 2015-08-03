//
//  RestProfileViewController.swift
//  Foodscape
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestProfileViewController: UIViewController, UIScrollViewDelegate {
    
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    var restProf : RestProfile!
    private let infoButton = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
    private let progSusView = UIScrollView()
    private let progRestProfScrollView = UIScrollView()
    private let progRestImage = UIImageView()


    
    @IBOutlet weak var restProfDescription: UILabel!
    @IBOutlet weak var restProfName: UINavigationItem!
    @IBOutlet var restProfileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setBackground("genericBackground")
        
        self.title = restProf?.name
        restProf.imageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) ->Void in
            if error == nil {
                if let data = imageData{
                    if let image = UIImage(data: data){
                        self.progRestImage.image = image
                    }
                }
            }
        }
        let darkBlueColor = UIColor(red: 0.0/255, green: 7.0/255, blue: 72.0/255, alpha: 0.75)
        progRestImage.frame = CGRectMake(0, 0, screenSize.width, screenSize.height*0.21)
        progRestImage.layer.borderColor = darkBlueColor.CGColor
        progRestImage.layer.borderWidth = 2
        // Do any additional setup after loading the view.
       progRestProfScrollView.delegate = self
       progRestProfScrollView.layer.borderWidth = 1
       progRestProfScrollView.layer.borderColor = UIColor.blackColor().CGColor
       progRestProfScrollView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5)
        
        let yUnit: CGFloat = screenSize.height / 100
        let xUnit: CGFloat = screenSize.width / 100
        
        infoButton.frame = CGRect(x: 92 * xUnit, y: 32 * yUnit, width: 6 * xUnit, height: 6 * xUnit)
        infoButton.tintColor = UIColor.whiteColor()
        infoButton.addTarget(self, action: "viewInfoPage:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(infoButton)
        
        func labelStyle(label : UILabel){
            label.lineBreakMode = .ByWordWrapping
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.Left
            label.textColor = UIColor.whiteColor()
        }
        
        let labelTitleLabel = UILabel()
        labelTitleLabel.frame = CGRect(x: 5 * xUnit, y: 21.5 * yUnit, width: 60 * xUnit, height: 4 * yUnit)
        labelTitleLabel.text = "Restaurant Sustainabiltiy Icons:"
        labelTitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 4 * xUnit)
        labelStyle(labelTitleLabel)
        
        view.addSubview(labelTitleLabel)
        
        //sets nav bar to be see through
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        self.navigationController?.navigationBar.translucent = true

        
        progSusView.delegate = self
        progSusView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)
        
        let openHourLabel = UILabel()
        
       progRestProfScrollView.showsVerticalScrollIndicator = false
        
        progSusView.frame = CGRectMake(0, screenSize.height*0.25, screenSize.width-32, screenSize.height*0.18)
        progRestProfScrollView.frame = CGRectMake(16, screenSize.height*0.43, screenSize.width-32, screenSize.height*0.57)
        //progSusView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(progRestImage)
        self.view.addSubview(progSusView)
        self.view.addSubview(progRestProfScrollView)
        
        layoutScroll()
        addLabels()
    }
    
    private func addLabels() {
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width
        let susWidth: CGFloat = progSusView.frame.width/2
        
        let labels = ["Environmental:", "Social:", "Economic:"] // dont need for menu swipe scroll
        var y: CGFloat = height * 0.01
        
        // move scroll outside for i loop
        for var i = 0; i < restProf.labels.count; i++ {
            var scroll = UIScrollView()
            scroll.showsHorizontalScrollIndicator = false
            // remove all label stuff for scroll in menu swipe
            var label = UILabel()
            
            if restProf.labels[i].count > 0 {
                //label.text = labels[i]
                label.font = UIFont(name: "HelveticaNeue-Light", size: 0.05*width)
                label.frame = CGRectMake(0.02*width, y, 0.75*susWidth, 45)
                label.textColor = UIColor.whiteColor()
                //label.sizeToFit()
                
                scroll.frame = CGRectMake(0.05*width, y, susWidth+80, label.frame.height)
                progSusView.addSubview(scroll)
                y += label.frame.height + height * 0.01
            }

            progSusView.addSubview(label)
            
            // this is the end of label stuff
            var x: CGFloat = 0// move this var outside for i loop and rename
            
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
                    x += ecoIcon.frame.width + width * 0.01
                }
            }

            for var j = 0; j < restProf.labels[i].count; j++ {
                if count(restProf.labels[i][j]) > 0 {
                    let frame = CGRectMake(x, 0.01*scroll.frame.height, 0.98*scroll.frame.height, 0.98*scroll.frame.height)
                    let icon = IconButton(name: restProf.labels[i][j], frame: frame)
                    icon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    scroll.addSubview(icon)
                    x += icon.frame.width + width*0.01
                }
            }
            scroll.contentSize.width = x + width * 0.1
        }
        progSusView.contentSize.height = y
    }
    
    
    func popup(sender: UIButton!) {
        let button = sender as! IconButton
    }
    
    func viewInfoPage(sender: AnyObject){
        performSegueWithIdentifier("viewInfoPageSegue", sender: sender)
    }
    
    
    private func layoutScroll() {
        let height: CGFloat = screenSize.height
        let width: CGFloat = screenSize.width
        let space = width*0.05
        
        var y: CGFloat = progRestProfScrollView.frame.height * 0.05
        
        if count(restProf.description) > 0 {
            var description = UILabel()
            description.text = "\"\(restProf.restDescript)\""
            description.textAlignment = .Center
            description.textColor = UIColor.whiteColor()
            description.frame = CGRect(x: 0.05*progRestProfScrollView.frame.width, y: y, width: progRestProfScrollView.frame.width * 0.9, height: 50)
            description.lineBreakMode = .ByWordWrapping
            description.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            description.numberOfLines = 0
            description.sizeToFit()
           progRestProfScrollView.addSubview(description)
            y += description.frame.height + space
        }
        
        var address = UILabel()
        address.text = "Address:\n" + restProf.address
        address.frame = CGRectMake(0.05*width, y,progRestProfScrollView.frame.width*0.9, 50)
        address.lineBreakMode = .ByWordWrapping
        address.textColor = UIColor.whiteColor()
        address.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        address.numberOfLines = 0
        address.sizeToFit()
       progRestProfScrollView.addSubview(address)
        y += address.frame.height + space/3
        
        let searchInMaps = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        searchInMaps.setTitle("Search in Maps", forState: .Normal)
        searchInMaps.frame = CGRectMake(0.05*width, y,progRestProfScrollView.frame.width-(0.1*width), 50)
        searchInMaps.sizeToFit()
        searchInMaps.addTarget(self, action: "mapSearch:", forControlEvents: UIControlEvents.TouchUpInside)
       progRestProfScrollView.addSubview(searchInMaps)
        y += searchInMaps.frame.height + space
        
        var phone = UILabel()
        phone.text = "Phone:\n" + restProf.phoneNumber
        phone.frame = CGRectMake(0.05*width, y,progRestProfScrollView.frame.width*0.9, 50)
        phone.lineBreakMode = .ByWordWrapping
        phone.textColor = UIColor.whiteColor()
        phone.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        phone.numberOfLines = 0
        phone.sizeToFit()
       progRestProfScrollView.addSubview(phone)
        y += phone.frame.height + space/3
        
        let callRestaurant = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        callRestaurant.frame = CGRectMake(0.05*width, y,progRestProfScrollView.frame.width-(0.1*width), 50)
        callRestaurant.setTitle("Call Restaurant", forState: .Normal)
        callRestaurant.sizeToFit()
        callRestaurant.addTarget(self, action: "callNumber:", forControlEvents: UIControlEvents.TouchUpInside)
       progRestProfScrollView.addSubview(callRestaurant)
        y += callRestaurant.frame.height + space
        
        
        let openUrl = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        openUrl.frame = CGRectMake(0.05*width, y,progRestProfScrollView.frame.width-(0.1*width), 50)
        openUrl.setTitle("Go To Website", forState: .Normal)
        openUrl.sizeToFit()
        openUrl.addTarget(self, action: "openWebsite:", forControlEvents: UIControlEvents.TouchUpInside)
       progRestProfScrollView.addSubview(openUrl)
        y += openUrl.frame.height + space
        
        let health = UILabel()
        health.text = "Health Score:\n" + String(stringInterpolationSegment: restProf.healthScore)
        health.frame = CGRectMake(0.05*width, y,progRestProfScrollView.frame.width*0.9, 50)
        health.lineBreakMode = .ByWordWrapping
        health.textColor = UIColor.whiteColor()
        health.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        health.numberOfLines = 0
        health.sizeToFit()
       progRestProfScrollView.addSubview(health)
        y += health.frame.height + space
        
        y += height*0.01
        
        // Set up the Restaurant hours panel
        let hours = UILabel()
        hours.text = "Restaurant Hours: "
        hours.textColor = UIColor.whiteColor()
        hours.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        hours.sizeToFit()
        hours.frame = CGRectMake(0.05*width, y, hours.frame.width, hours.frame.height)
       progRestProfScrollView.addSubview(hours)
        y += hours.frame.height
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        var likeHours = Dictionary<String, [String]>()
        var valuePositions: [String] = []
        
        for var i = 0; i < restProf.hours.count; i++ {
            
            if contains(likeHours.keys, restProf.hours[i]) {
                likeHours[restProf.hours[i]]?.append(days[i])
            }
            else {
                likeHours[restProf.hours[i]] = [days[i]]
                valuePositions.append(days[i])
            }
        }
        

        var trackY: CGFloat = 30

        for key in likeHours.keys {
            let label = UILabel()
            label.text = ""
            var day: [String] = likeHours[key]!
            if day.count > 1 {
                label.text! += day[0] + "-" + day[day.count-1]
            }
            else {
                label.text! += day[0]
            }
            
            if count(key) > 0 {
                label.text! += ": " + key
            }
            else {
                label.text! += ": Closed"
            }
            
            label.frame = CGRectMake(0.12*width, y,progRestProfScrollView.frame.width*0.9, 50)
            //let placeY = CGFloat(y+CGFloat(find(valuePositions,day[0])!)*label.frame.height)
            label.lineBreakMode = .ByWordWrapping
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            label.numberOfLines = 0
            label.sizeToFit()
           progRestProfScrollView.addSubview(label)
            //trackY += label.frame.height
            y += label.frame.height

            
        }
        y += trackY + space
        
        // Set up Meal Plan hours
        if count(restProf.mealPlanHours[0]) > 0 {
            
            let mealPlan = UILabel()
            mealPlan.text = "Meal Plan Hours:"
            mealPlan.textColor = UIColor.whiteColor()
            mealPlan.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
            mealPlan.sizeToFit()
            mealPlan.frame = CGRectMake(0.05*width, y, mealPlan.frame.width, mealPlan.frame.height)
           progRestProfScrollView.addSubview(mealPlan)
            y += mealPlan.frame.height
            
            var likeMealHours = Dictionary<String, [String]>()
            var valuePositions: [String] = []
            for var i = 0; i < restProf.mealPlanHours.count; i++ {
                if contains(likeMealHours.keys, restProf.mealPlanHours[i]) {
                    likeMealHours[restProf.mealPlanHours[i]]?.append(days[i])
                }
                else {
                    likeMealHours[restProf.mealPlanHours[i]] = [days[i]]
                    valuePositions.append(days[i])
                }
            }
            
            var tY: CGFloat = 0
            var orderLabels: [UILabel] = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
            for times in likeMealHours.keys {
                var mplabel = UILabel()
                mplabel.text = ""
                var day: [String] = likeMealHours[times]!
                
                if day.count > 1 {
                    mplabel.text! += day[0] + "-" + day[day.count-1]
                }
                else {
                    mplabel.text! += day[0]
                }
                
                if count(times) > 0 {
                    mplabel.text! += ": " + times
                }
                else {
                    mplabel.text! += ": Closed"
                }
                
                
                var index: Int = find(valuePositions, day[0])!
                orderLabels.insert(mplabel, atIndex: index)

            }
            
            for label in orderLabels {
                label.frame = CGRectMake(0.12*width, y,progRestProfScrollView.frame.width*0.9, 50)
                label.lineBreakMode = .ByWordWrapping
                label.numberOfLines = 0
                label.textColor = UIColor.whiteColor()
                label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
                label.sizeToFit()
               progRestProfScrollView.addSubview(label)
                y += label.frame.height
            }
            y += 25
        }
       progRestProfScrollView.contentSize.height = y
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func openWebsite(sender:UIButton) {
        if let url = NSURL(string: restProf.url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    
    @IBAction func callNumber(sender:UIButton) {
        let alert = UIAlertController(title: "Call Restaurant",
            message: "" + restProf.phoneNumber,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Call",
            style: UIAlertActionStyle.Default,
            handler: { alertAction in self.makeCall() }
            )
        )
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil
            )
        )
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func mapSearch(sender:UIButton) {
        //http://stackoverflow.com/questions/28604429/how-to-open-maps-app-programatically-with-coordinates-in-swift
        
        getCoordinates(restProf.address) { lat, long, error in
            if error != nil {
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
    private func getCoordinates(location: String, completionHandler: (lat: CLLocationDegrees!, long: CLLocationDegrees!, error: NSError?) -> ()) -> Void {
        
        var lat:CLLocationDegrees
        var long:CLLocationDegrees
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { (placemarks: [AnyObject]!, error: NSError!) in
            
            if error != nil {
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
    
    private func makeCall(){
        if let url = NSURL(string: "tel://\(restProf.phoneNumber)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
     func showLabelInfo(sender: AnyObject) {
        let vc = UIViewController()
        let button = sender as! IconButton
        
        vc.preferredContentSize = CGSizeMake(self.view.frame.width * 0.4, self.view.frame.height * 0.3)
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

        
        let frame = CGRectMake(0, description.frame.height + 5, description.frame.width, screenSize.height*0.05)
        let linkButton = LinkButton(name: button.name, frame: frame)
        linkButton.setTitle("Learn More", forState: UIControlState.Normal)
        linkButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        linkButton.addTarget(self, action: "learnMoreLink:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let popScroll = UIScrollView()
        popScroll.showsVerticalScrollIndicator = false
        if description.frame.height + linkButton.frame.height < vc.view.frame.height/2 {
            popScroll.frame = CGRectMake(0, 10, description.frame.width, description.frame.height+linkButton.frame.height+10)
        }
        else {
            popScroll.frame = CGRectMake(0, 0, vc.view.frame.width/2, vc.view.frame.height/2)
        }
        
        
        
        popScroll.contentSize = CGSizeMake(description.frame.width, description.frame.height+linkButton.frame.height)
        popScroll.addSubview(description)
        popScroll.addSubview(linkButton)
        vc.view.addSubview(popScroll)
        
        vc.preferredContentSize = CGSizeMake(popScroll.frame.width, popScroll.frame.height)
        vc.modalPresentationStyle = .Popover
        
        self.presentViewController(vc, animated: true, completion: nil)
                
        if let pop = vc.popoverPresentationController {
            pop.sourceView = (sender as! UIView)
            pop.sourceRect = (sender as! UIView).bounds
        }
    }
    
    
    @IBAction func learnMoreLink(sender: UIButton) {
        let urls = IconDescription().urls
        let button = sender as! LinkButton
        if let url = NSURL(string: urls[button.name]!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    /**
    Prepares for segue
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewInfoPageSegue" {
            let sustainabilityInfoViewController = segue.destinationViewController as! SustainabilityInfoViewController
            // Passes the list of liked dishes to the preference list view
            sustainabilityInfoViewController.isFromInfo = true
        }
    }
}


extension RestProfileViewController : UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
