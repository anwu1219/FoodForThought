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
class SustainabilityInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, TypesTableViewCellDelegate, UIScrollViewDelegate{
    
    
    var isFromInfo : Bool?
    var labelPositions = [String: CGFloat]()
    let menuSwipeScroll = UIScrollView()
    var typesTableView = UITableView()
    let verticalSpace = 0.05 * UIScreen.mainScreen().bounds.height
    let widthPadding = 0.05 * UIScreen.mainScreen().bounds.width
    let susView = UIScrollView()
    let icon = UIImageView()
    let sustainabilityImages = ["greenEarth", "heartHands", "treeCoin"]
    let susLabels = ["About Sustainability", "Sustainability Labels"]
    let susInfo = ["Our sustainability team seeks to promote sustainability among local communities by providing consumers with relevant food-related sustainability information within a useful meal planning tool. This tool integrates the triple bottom line (equity, environment, economy) into our culture in order to encourage sustainable communities, businesses and lifestyles. \n Sustainability must include the inextricable links among equity, environment and economy (the three E’s). The Great Law of the Iroquois and the definition of sustainable development in the Brundtland Commission Report of 1987 best exemplify the concept of sustainability: \n “In every deliberation, we must consider the impact on the seventh generation” \n The Great Law of the Iroquois\n“Sustainable development is development that meets the needs of the present without compromising the ability of future generations to meet their own needs”\n Brundtland Commission \n We use the triple bottom line concept coined by John Elkington in his 1994 book, “Cannibals with Forks.” It is a framework to facilitate decision-making because every decision we make affects social equity, environmental integrity and economic prosperity. Improving all three can drive opportunity.\n Some examples of sustainability topics include (but are not limited to):\n Food Justice\n Socially and environmentally-conscious businesses\n Fair labor\n Land use\n Waste management\n Resource consumption\n Healthy living. What you can do:\n Never underestimate the impact a single individual can have on the greater sustainability movement. Simple actions, such as asking restaurant managers questions about their restaurant could motivate them to learn more about sustainability.  Here are some suggestions:\nAsk if the restaurant sources local food.\nSee if you can determine what farms the food you buy comes from.\n Visit your local farmers market. You’ll get fresh food and support the local economy.", "Sustainability must include the inextricable links among equity, environment and economy (the three E’s). The Great Law of the Iroquois and the definition of sustainable development in the Brundtland Commission Report of 1987 best exemplify the concept of sustainability.", "Never underestimate the impact a single individual can have on the greater sustainability movement. Simple actions, such as asking restaurant managers questions about their restaurant could motivate them to learn more about sustainability."]
    


    @IBAction func learnMoreAction(sender: UIButton!) {
            let vc = UIViewController()
            vc.preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
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
        super.viewDidLoad()
        
        
        susView.delegate = self
        
        
        setBackground("SustyPageBackground")

        
        menuSwipeScroll.frame = CGRect(x: widthPadding, y: 3.5*verticalSpace, width: UIScreen.mainScreen().bounds.width-(2*widthPadding), height: UIScreen.mainScreen().bounds.height - (4*verticalSpace))
        menuSwipeScroll.backgroundColor = UIColor.clearColor()
        menuSwipeScroll.contentSize = CGSize(width: 1.66 * menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: false)
        menuSwipeScroll.scrollEnabled = false
        view.addSubview(menuSwipeScroll)

        addScrollView()
        
        
        addScrollIcon()
        
        typesTableView.dataSource = self
        typesTableView.delegate = self
        typesTableView.registerClass(TypesTableViewCell.self, forCellReuseIdentifier: "typeCell")
        typesTableView.separatorStyle = .None
        
        
    }
    
    
    func addScrollIcon(){
        let xUnit : CGFloat = self.view.frame.width / 100
        let yUnit : CGFloat = self.view.frame.height / 100
        
        icon.frame = CGRect(x: 0.1 * widthPadding, y: 3.8 * verticalSpace, width: 0.8 * widthPadding, height: verticalSpace)
        icon.alpha = 0.2
        icon.image = UIImage(named: "arrowIcon")
        icon.contentMode = .ScaleToFill
        self.view.addSubview(icon)
        icon.hidden = false
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        if scrollView == susView{
            icon.hidden = true
        }
    }
    

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == susView{
            icon.hidden = false
            println("Scroll finished")
        
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == susView{
            icon.hidden = false
            println("Scroll finished")
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let boo = isFromInfo {
            if boo{
                susView.setContentOffset(CGPoint(x: 0, y: labelPositions["Sustainability Labels"]!), animated: false)
            }
        }
    }
    
    
    func addScrollView(){
        let xUnit : CGFloat = self.menuSwipeScroll.frame.width / 100
        let yUnit : CGFloat = self.menuSwipeScroll.frame.height / 100
        
        
        typesTableView.frame = CGRect(x: 0 * xUnit, y: 0, width: 60 * xUnit, height: menuSwipeScroll.frame.height)
        typesTableView.backgroundColor = UIColor.clearColor()
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "bringBack:")
        typesTableView.addGestureRecognizer(tapRecognizer)
        menuSwipeScroll.addSubview(typesTableView)
        

        var y: CGFloat = 0.0
        susView.backgroundColor = UIColor(red: 243/255.0, green: 244/255.0, blue: 230/255.0, alpha: 1)
        self.navigationController?.navigationBar.translucent = true
        
        susView.frame = CGRect(x: 66 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        susView.layer.borderColor = UIColor(red: 64/255.0, green: 55/255.0, blue: 74/255.0, alpha: 0.95).CGColor
        susView.layer.borderWidth = 10
        susView.layer.cornerRadius = 5
        
        for var i = 0; i < count(susLabels); i++ {
            let container = UIView()
            let header = UILabel()
            let image = UIImageView()
            let body = UILabel()
            let button = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            
            // Set the subsection's header
            header.text = susLabels[i]
            header.font = UIFont(name: "Helvetica", size: susView.frame.width * 0.09)
            header.textColor = UIColor.whiteColor()
            header.layer.shadowOffset = CGSizeMake(2, 2)
            header.layer.shadowColor = UIColor.blackColor().CGColor
            header.layer.shadowOpacity = 0.7
            header.layer.shadowRadius = 3.0
            header.sizeToFit()
            header.frame = CGRectMake(widthPadding, y+verticalSpace, susView.frame.width - 2 * widthPadding, header.frame.height)
            header.textAlignment = .Center
            susView.addSubview(header)
            labelPositions[susLabels[i]] = y
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
            body.frame = CGRectMake(widthPadding, y, susView.frame.width - (2*widthPadding), header.frame.height * 3)
            body.sizeToFit()
            body.textAlignment = .Center
            susView.addSubview(body)
            y += body.frame.height + verticalSpace
            
            // set the section's learn more button
            button.setTitle("Learn More", forState: UIControlState.Normal)
            button.addTarget(self, action: "learnMoreAction:", forControlEvents: UIControlEvents.TouchUpInside)
            button.frame = CGRectMake(susView.frame.width*0.2, y, susView.frame.width*0.6, 50)
            button.backgroundColor = UIColor.clearColor()
            susView.addSubview(button)
            y += 50 + verticalSpace
            
        }
        
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .Right
        swipeGestureRecognizer.addTarget(self, action: "viewMenu:")
        menuSwipeScroll.addGestureRecognizer(swipeGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer()
        swipeLeftGestureRecognizer.direction = .Left
        swipeLeftGestureRecognizer.addTarget(self, action: "bringBack:")
        menuSwipeScroll.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        
        let descriptionsDict = IconInfo().descriptions
        let levels = ["Dish-level Icons", "Restaurant-level Icons", "Nutritionist Icons", "Sustainability Certification"]
        for level in levels {
            let levelLabel = UILabel(frame: CGRect(x: widthPadding, y: y, width: susView.frame.width -  widthPadding, height: 0))
            levelLabel.text = level + ":"
            levelLabel.sizeToFit()
            levelLabel.textAlignment = .Left
            levelLabel.font = UIFont(name: "Helvetica", size: susView.frame.width * 0.058)
            levelLabel.textColor = UIColor.blackColor()
            susView.addSubview(levelLabel)
            y = y + levelLabel.frame.height
            
            let descriptions = descriptionsDict[level]!
        for labelName: String in descriptions.keys.array {
            let labelView = UIView()
            let labelImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 0.1 * susView.frame.width, height: 0.1 * susView.frame.width))
            labelImage.image = UIImage(named: labelName)
            labelImage.contentMode = .ScaleToFill
            let labelDescription = UILabel(frame: CGRect(x: labelImage.frame.width + widthPadding, y: 0, width: susView.frame.width - labelImage.frame.width - 3 * widthPadding, height: 0))
            labelDescription.text = descriptions[labelName]!
            labelDescription.lineBreakMode = NSLineBreakMode.ByWordWrapping
            labelDescription.numberOfLines = 0
            labelDescription.textAlignment = .Left
            labelDescription.font = UIFont(name: "Helvetica", size: susView.frame.width * 0.05)
            labelView.frame = CGRect(x: widthPadding, y: y, width: UIScreen.mainScreen().bounds.width - 2 * widthPadding, height: UIScreen.mainScreen().bounds.height)
            labelDescription.sizeToFit()
            labelView.addSubview(labelImage)
            labelView.addSubview(labelDescription)
            labelView.sizeToFit()
            susView.addSubview(labelView)
            y = y + labelDescription.frame.height
        }
        }
        susView.contentSize.height = y + verticalSpace
        menuSwipeScroll.addSubview(susView)
    }
    
    
    
 
    
    
    func bringBack(sender: AnyObject){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
    }
    
    
    func viewMenu(swipeGestureRecognizer: UISwipeGestureRecognizer) {
        menuSwipeScroll.setContentOffset(CGPoint(x: 0 * menuSwipeScroll.frame.width, y: 0), animated: true)
    }
    
    
    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as! TypesTableViewCell
        if indexPath.row == 0 {
            cell.delegate = self
            cell.textLabel!.text = "About Sustainability"
        }
        if indexPath.row == 1 {
            cell.delegate = self
            cell.textLabel!.text = "Sustainability Labels"
        }
        if indexPath.row == 2 {
            cell.delegate = self
            cell.textLabel!.text = "About Sustainability"
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: self.view.frame.width * 0.045)
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(white: 0.667, alpha: 0.2)
        return cell
    }
    
    
    func goToType(type: String){
        println(labelPositions)
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
        susView.setContentOffset(CGPoint(x: 0, y: labelPositions[type]!), animated: true)
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