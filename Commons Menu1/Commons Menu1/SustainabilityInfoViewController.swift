//
//  SustainabilityInfoViewController.swift
//  Foodscape
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

/**
Displays information of sustainability and links to sustainability info
*/
class SustainabilityInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, TypesTableViewCellDelegate, UIScrollViewDelegate{
    
    var selectedIndexPath : NSIndexPath?
    var isFromInfo : Bool?
    let defaultHeight = UIScreen.mainScreen().bounds.height * 0.1
    private var labelPositions = [String: CGFloat]()
    private let menuSwipeScroll = UIScrollView()
    private let  typesTableView = UITableView()
    private let aboutSusView = UIView()
    private let verticalSpace = 0.05 * UIScreen.mainScreen().bounds.height
    private let widthPadding = 0.05 * UIScreen.mainScreen().bounds.width
    private let susView = UIScrollView()
    private let icon = UIImageView()
    private let subTitles = ["Foodscape Purpose", "Foodscape Mission", "Sustainability Defined", "More Than This App: Food Justice, Sports and More", "Examples of Food and Sustainability Topics", "The Davidson College Food System", "Feedback & Suggestions"]
    private let susInfo = ["Foodscape seeks to promote sustainability among local communities by providing consumers with relevant food-related sustainability information.\nThis app connects the three E's of equity, environment, economy into our local food preferences in order to encourage sustainable communities, businesses and lifestyles. Foodscape predominantly highlights social and environmental aspects of food and locations as self-reported by local restaurants and cafes. Through this mobile app you will learn whether restaurants report sourcing locally, get involved in their communities, source products that believe in fair labor and fair wages, recycle, and much more. See methodology for more about how this information is reported and what it means.\nWhile Foodscape concentrates on the interaction between consumers and the restaurants where they purchase food, the goal is to get everyone to think more about their entire food system. You can see a diagram of the Davidson College food system below. Using this, we can start connecting the dots between seed and fork for all food consumers in Davidson. We hope this helps you understand what questions you want to ask about your food, where it comes from, and your preferences!\n\n",
        "We believe it is important for consumers to reconnect with their food and, in addition to the financial implications of their decisions, understand the social and environmental implications of food production, provision and consumption. We hope this app helps you learn and facilitates discussion about what questions you want to ask yourself and your food providers.\nOur food system includes issues related to health, obesity in the United States, water consumption, environmental health impacts of pesticides and fertilizers, inequities of access and availability to healthy food based on socio-economic differences, economic opportunity for local farmers and restaurants, power struggles within food industries between large corporations and small businesses, identity, culture, diversity, and much more. All of these issues can be connected to impacts of policy, subsidies, consumer behavior, advertising and more. It can be overwhelming. We hope to help create a starting point for your journey to learn more about your food and how it is connected to every part of your life. To find out more about all these topics and more visit food.davidsonsustainability.org.\nAs one of the schools supported by The Duke Endowment, who provided the funding for this initiative, we also want this app to be replicable for other colleges and universities. If your school is interested please contact us at food.davidsonsustainability.org to see how we can help integrate new locations into the app or help your school create its own version.\n\n",
        "Sustainability is a framework that includes the inextricable links among social equity, environmental integrity and economic prosperity – often referred to as the Triple Bottom Line (coined by John Elkington in his 1994 book, Cannibals with Forks). Triple Bottom Line sustainability is a framework we use to facilitate decision-making; because every decision we make affects social equity, environmental integrity and economic prosperity. Improving all three can drive opportunity.\n\n{insert triangle image here}\n\nThe Great Law of the Iroquois and the definition of sustainable development in the Brundtland Commission Report of 1987 best exemplify the concept of sustainability.\n\"In every deliberation, we must consider the impact on the seventh generation.\"\n- The Great Law of the Iroquois\n\"Sustainable development is development that meets the needs of the present without compromising the ability of future generations to meet their own needs.\"\n- Brundtland Commission\n\n",
        "Food and sustainability addresses where our food originates (e.g., local and small scale vs. large scale), how it is grown (organic, biologique (?), naturally grown, etc.), fair labor practices, environmental impact, availability and access to healthy foods, other food justice issues, and much more. Want to learn more about what all this means? Explore all these issues and more at food.davidsonsustainability.org.\nWe know that our mobile app does not touch on every aspect of sustainability and food. However, we are using the website above to pull together more resources from around the globe and from our own students, faculty and staff at Davidson College.\nFood Justice\nOur website provides more detail, information and opportunities related to Food Justice issues.\n\"Food justice asserts that no one should live without enough food because of economic constraints or social inequalities… The food justice movement is a different approach to a community’s needs that seeks to truly advance self-reliance and social justice by placing communities in leadership of their own solutions and providing them with the tools to address the disparities within our food systems and within society at large.\" (Ahmadi, 2010)\nThe United States Department of Agriculture has created some definitions and analysis about Food Security and Insecurity. Here are their definitions (http://www.ers.usda.gov/topics/food-nutrition-assistance/food-security-in-the-us/definitions-of-food-security.aspx)\n\nFood Security\n\u{2022} High food security (old label=Food security): no reported indications of food-access problems or limitations.\n\u{2022} Marginal food security (old label=Food security): one or two reported indications—typically of anxiety over food sufficiency or shortage of food in the house. Little or no indication of changes in diets or food intake.\nFood Insecurity\n\u{2022} Low food security (old label=Food insecurity without hunger): reports of reduced quality, variety, or desirability of diet. Little or no indication of reduced food intake.\n\u{2022} Very low food security (old label=Food insecurity with hunger): Reports of multiple indications of disrupted eating patterns and reduced food intake.\n\nSports\nFood and sports has become a hot topic. People come together for sports and food. So there is a big opportunity to influence change in healthy eating, local sourcing and organically grown foods. The Green Sports Alliance and Natural Resources Defense Council created a report titled, Champions of Game Day Food. (http://www.nrdc.org/greenbusiness/guides/sports/files/game-day-food-report.pdf). If you want to learn more about how athletes are becoming leaders for food and sustainability, whether hormone and antibiotic free beef or nutritional and vegan diets for athletes, visit food.davidsonsustainability.org.\n\n",
        "Some examples of sustainability topics in food include (but are not limited to):\nCulture and food\nFair labor\nFood & Identity\nFood justice\nGlobal food issues\nHealthy living\nHormone and antibiotic free meat\nLand use\nLocal sourcing\nPower and Policy\nResource consumption\nSafe and healthy workplace\nSocially and environmentally-conscious businesses\nVeganism\nVegetarianism\nWater use\nWaste management\n\nLearn about some of these examples at food.davidsonsustainability.org\n\n",
        "\n\n\n\n\n\n\n\n\n\n",
        "Please provide us with your feedback and suggestions for the Davidson College Office of Sustainability and our partners through our website: food.davidsonsustainability.org.\n\n"]
    private let susInfoTableView = UITableView()
    

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
            let url = NSURL(string: "http://food.davidsonsustainability.org")
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
        
        
        
        addTableView()
        
        
        addScrollIcon()
        
        typesTableView.dataSource = self
        typesTableView.delegate = self
        typesTableView.registerClass(TypesTableViewCell.self, forCellReuseIdentifier: "typeCell")
        typesTableView.separatorStyle = .None

        
        susInfoTableView.dataSource = self
        susInfoTableView.delegate = self
        susInfoTableView.registerClass(ExpandTableViewCell.self, forCellReuseIdentifier: "susCell")
        susInfoTableView.separatorStyle = .None
    }
    
    
    private func addScrollIcon(){
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
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == susView{
            icon.hidden = false            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let boo = isFromInfo {
            if boo{
//                susView.setContentOffset(CGPoint(x: 0, y: labelPositions["Sustainability Labels"]!), animated: false)
            }
        }
    }
    
    
    private func addScrollView(){
        let xUnit : CGFloat = self.menuSwipeScroll.frame.width / 100
        let yUnit : CGFloat = self.menuSwipeScroll.frame.height / 100
        
        

        

        var y: CGFloat = 10.0
        susView.backgroundColor = UIColor(red: 243/255.0, green: 244/255.0, blue: 230/255.0, alpha: 1)
        self.navigationController?.navigationBar.translucent = true
        
        susView.frame = CGRect(x: 66 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        susView.layer.borderColor = UIColor(red: 64/255.0, green: 55/255.0, blue: 74/255.0, alpha: 0.95).CGColor
        susView.layer.borderWidth = 10
        susView.layer.cornerRadius = 5
        susView.scrollEnabled = true
        
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .Right
        swipeGestureRecognizer.addTarget(self, action: "viewMenu:")
        menuSwipeScroll.addGestureRecognizer(swipeGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer()
        swipeLeftGestureRecognizer.direction = .Left
        swipeLeftGestureRecognizer.addTarget(self, action: "bringBack:")
        menuSwipeScroll.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        
        let descriptionsDict = IconInfo().descriptions
        let levels = ["Dish-level labels", "Restaurant-level labels", "Nutritionist labels", "Sustainability Certification"]
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
    
    
    func addTableView(){
        let xUnit : CGFloat = self.view.frame.width / 100
        let yUnit : CGFloat = self.view.frame.height / 100
        
        aboutSusView.frame = CGRect(x: 60 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        
        typesTableView.frame = CGRect(x: 0 * xUnit, y: 0, width: 60 * xUnit, height: menuSwipeScroll.frame.height)
        typesTableView.backgroundColor = UIColor.clearColor()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "bringBack:")
        typesTableView.addGestureRecognizer(tapRecognizer)
        menuSwipeScroll.addSubview(typesTableView)
        
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .Right
        swipeGestureRecognizer.addTarget(self, action: "viewMenu:")
        menuSwipeScroll.addGestureRecognizer(swipeGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer()
        swipeLeftGestureRecognizer.direction = .Left
        swipeLeftGestureRecognizer.addTarget(self, action: "bringBack:")
        menuSwipeScroll.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        
        let imageView = UIImageView(frame: CGRect(x: 0 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height * 0.3))
        imageView.image = UIImage(named: "susTriangle")
        imageView.contentMode = .ScaleToFill
        
        susInfoTableView.frame = CGRect(x: 0, y: 0.3 * menuSwipeScroll.frame.height, width: menuSwipeScroll.frame.width, height: 0.7 * menuSwipeScroll.frame.height)
        
        aboutSusView.addSubview(imageView)
        aboutSusView.addSubview(susInfoTableView)
        
        menuSwipeScroll.addSubview(aboutSusView)
        
    }
    
    
    
 
    
    
    internal func bringBack(sender: AnyObject){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
    }
    
    
    internal func viewMenu(swipeGestureRecognizer: UISwipeGestureRecognizer) {
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
        if tableView == susInfoTableView {
            return subTitles.count
        }
        return 2
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == susInfoTableView {
            var cell = tableView.dequeueReusableCellWithIdentifier("susCell", forIndexPath: indexPath) as! ExpandTableViewCell
            cell.foodSystemImageView.hidden = !(indexPath.row == 5)
            if indexPath.row == 5 {
                cell.foodSystemImageView.frame = CGRect(x:0.03 * menuSwipeScroll.frame.width, y: 0, width:menuSwipeScroll.frame.width * 0.9, height:getHeight(indexPath.row))
                cell.foodSystemImageView.image = UIImage(named: "foodSystem")
                cell.foodSystemImageView.contentMode = .ScaleToFill
            }
            
            cell.susContentView.frame = CGRect(x:0.03 * menuSwipeScroll.frame.width, y:defaultHeight, width:menuSwipeScroll.frame.width * 0.88, height:getHeight(indexPath.row))
            cell.contentLabel.frame = CGRect(x:0, y:0, width: menuSwipeScroll.frame.width * 0.88, height:getHeight(indexPath.row))
            cell.contentLabel.textAlignment = .Left
            cell.titleLabel.text = self.subTitles[indexPath.row]
            cell.titleLabel.backgroundColor = UIColor.redColor()
            cell.contentLabel.text = self.susInfo[indexPath.row]
            cell.backgroundColor = UIColor(white: 0.667, alpha: 0.2)
            return cell
        } else {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as! TypesTableViewCell
        if indexPath.row == 0 {
            cell.delegate = self
            cell.textLabel!.text = "About Sustainability"
        }
        if indexPath.row == 1 {
            cell.delegate = self
            cell.textLabel!.text = "Sustainability Labels"
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: self.view.frame.width * 0.045)
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(white: 0.667, alpha: 0.2)
        return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == susInfoTableView {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == susInfoTableView{
        (cell as! ExpandTableViewCell).watchFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == susInfoTableView{
        (cell as! ExpandTableViewCell).ignoreFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == susInfoTableView{
        if indexPath == selectedIndexPath {
            return getHeight(indexPath.row) + self.defaultHeight
        } else {
            return self.defaultHeight
            }
        }
        return defaultHeight
    }
    
    
    func getHeight(index : Int) -> CGFloat{
        let testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: susInfoTableView.frame.width * 0.85, height: 0))
        testLabel.text = susInfo[index]
        testLabel.frame.size.width = susInfoTableView.frame.width
        testLabel.numberOfLines = 0
        testLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        testLabel.textAlignment = .Left
        testLabel.sizeToFit()
        return testLabel.frame.height
    }
    
    
    func goToType(type: String){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.66 * menuSwipeScroll.frame.width, y: 0), animated: true)
        if type == "About Sustainability" {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.susView.alpha = 0
                    self.aboutSusView.alpha = 1
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.susView.alpha = 1
                self.aboutSusView.alpha = 0
                }, completion: nil)
        }
        
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