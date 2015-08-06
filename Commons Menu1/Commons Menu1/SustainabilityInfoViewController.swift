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
    private let iconSusView = UIView()
    private let verticalSpace = 0.05 * UIScreen.mainScreen().bounds.height
    private let widthPadding = 0.05 * UIScreen.mainScreen().bounds.width
    private let susIconTableView = UITableView()
    private let icon = UIButton()
    private let subTitles = ["Foodscape Purpose", "Foodscape Mission", "Our Methodology", "Sustainability Defined", "More Than This App: Food Justice, Sports and More", "Examples of Food and Sustainability Topics", "The Davidson College Food System", "Feedback & Suggestions"]
    private let levels = ["Restaurant-level Icons", "Dish-level Icons", "Davidson Nutritionist Icons", "Ecologically Sound Icon", "Fair Icon", "Humane Icon"]
    var susInfo = ["<p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\"><i>Foodscape</i> seeks to promote sustainability among local communities by providing consumers with relevant food-related sustainability information.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">This app connects the three E's of equity, environment, economy into our local food preferences in order to encourage sustainable communities, businesses and lifestyles. <i>Foodscape</i> predominantly highlights social and environmental aspects of food and locations as self-reported by local restaurants and cafes. Through this mobile app you will learn whether restaurants report sourcing locally, get involved in their communities, source products that believe in fair labor and fair wages, recycle, and much more. See methodology for more about how this information is reported and what it means.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">While <i>Foodscape</i> concentrates on the interaction between consumers and the restaurants where they purchase food, the goal is to get everyone to think more about their entire food system. You can see a diagram of the Davidson College food system below. Using this, we can start connecting the dots between seed and fork for all food consumers in Davidson. We hope this helps you understand what questions you want to ask about your food, where it comes from, and your preferences!</p>".html2AttStr,
        "<p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">We believe it is important for consumers to reconnect with their food and, in addition to the financial implications of their decisions, understand the social and environmental implications of food production, provision and consumption. We hope this app helps you learn and facilitates discussion about what questions you want to ask yourself and your food providers.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">Our food system includes issues related to health, obesity in the United States, water consumption, environmental health impacts of pesticides and fertilizers, inequities of access and availability to healthy food based on socio-economic differences, economic opportunity for local farmers and restaurants, power struggles within food industries between large corporations and small businesses, identity, culture, diversity, and much more. All of these issues can be connected to impacts of policy, subsidies, consumer behaviors, advertising and more. It can be overwhelming. We hope to help create a starting point for your journey to learn more about your food and how it is connected to every part of your life. To find out more about all these topics and more visit <strong>food.davidsonsustainability.org</strong>.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">As one of the schools supported by The Duke Endowment, who provided the funding for this initiative, we also want this app to be replicable for other colleges and universities. If your school is interested please contact us at <strong>food.davidsonsustainability.org</strong> to see how we can help integrate new locations into the app or help your school create its own version.</p>".html2AttStr,
        
        "Methodology".html2AttStr,
        
        
        "<p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">Sustainability is a framework that includes the inextricable links among social equity, environmental integrity and economic prosperity – often referred to as the Triple Bottom Line (coined by John Elkington in his 1994 book, <i>Cannibals with Forks</i>). Triple Bottom Line sustainability is a framework we use to facilitate decision-making; because every decision we make affects social equity, environmental integrity and economic prosperity. Improving all three can drive opportunities.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">The Great Law of the Iroquois and the definition of sustainable development in the Brundtland Commission Report of 1987 best exemplify the concept of sustainability.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">\"In every deliberation, we must consider the impact on the seventh generation.\"</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">&nbsp;&nbsp;&nbsp;&nbsp;- <i>The Great Law of the Iroquois</i></p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">\"Sustainable development is development that meets the needs of the present without compromising the ability of future generations to meet their own needs.\"</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">&nbsp;&nbsp;&nbsp;&nbsp;- <i>Brundtland Commission</i></p>".html2AttStr,
        
        
        "<p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">Food and sustainability addresses where our food originates, how it is grown, fair labor practices, environmental impact, availability and access to healthy foods, other food justice issues, and much more. Want to learn more about what all this means? Explore all these issues and more at <strong>food.davidsonsustainability.org</strong>.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">We know that our mobile app does not touch on every aspect of sustainability and food. However, we are using the website above to pull together more resources from around the globe and from our own students, faculty and staff at Davidson College.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\"><strong><u>Food Justice</u></strong><br>Our website provides more detail, information and opportunities related to Food Justice issues.\n<i>\"Food justice asserts that no one should live without enough food because of economic constraints or social inequalities… The food justice movement is a different approach to a community’s needs that seeks to truly advance self-reliance and social justice by placing communities in leadership of their own solutions and providing them with the tools to address the disparities within our food systems and within society at large.\" (Ahmadi, 2010)</i></p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">The United States Department of Agriculture has created some definitions and analysis about Food Security and Insecurity. You can find these definitions below or click<strong> here</strong> to visit their website.</p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\"><strong>Food Security</strong></p><ul style=\"list-style-type:disc; font-size: 1.2em; text-align: left; font-family: Helvetica\"><li><strong>High food security</strong>: no reported indications of food-access problems or limitations.<li><strong>Marginal food security</strong>: one or two reported indications—typically of anxiety over food sufficiency or shortage of food in the house. Little or no indication of changes in diets or food intake.</ul></p><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\"><strong>Food Insecurity</strong></p><ul style=\"list-style-type:disc; font-size: 1.2em; text-align: left; font-family: Helvetica\"><li><strong>Low food security</strong>: reports of reduced quality, variety, or desirability of diet. Little or no indication of reduced food intake.<li><strong>Very low food security</strong>: Reports of multiple indications of disrupted eating patterns and reduced food intake.</ul><br><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\"><u><strong>Sports</u></strong><br>Food and sports has become a hot topic. People come together for sports and food. So there is a big opportunity to influence change in healthy eating, local sourcing and organically grown foods. The Green Sports Alliance and Natural Resources Defense Council created a <strong>report</strong> titled, Champions of Game Day Food. If you want to learn more about how athletes are becoming leaders for food and sustainability, about whether hormone and antibiotic free beef or nutritional and vegan diets are better for athletes, visit <strong>food.davidsonsustainability.org</strong>.</p>".html2AttStr,
        "<p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">Some examples of sustainability topics in food include (but are not limited to):</p><ul style=\"list-style-type:disc; font-size: 1.2em; text-align: left; font-family: Helvetica\"><li>Culture and food<li>Fair labor<li>Food & Identity<li>Food justice<li>Global food issues<li>Healthy living<li>Hormone and antibiotic free meat<li>Land use<li>Local sourcing<li>Power and Policy<li>Resource consumption<li>Safe and healthy workplace<li>Socially and environmentally-conscious businesses<li>Veganism<li>Vegetarianism<li>Water use<li>Waste management</ul><br><p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">Learn about some of these examples at <strong>food.davidsonsustainability.org</strong>\n\n</p>".html2AttStr,
        "<br><br><br><br><br><br><br>".html2AttStr,
        "<p style=\"font-size: 1.2em; text-align: left; font-family: Helvetica\">Please provide us with your feedback and suggestions for the Davidson College Office of Sustainability and our partners through our website: <strong>food.davidsonsustainability.org</strong>.</p>".html2AttStr]

    private let susInfoTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackground("SustyPageBackground")
        menuSwipeScroll.frame = CGRect(x: widthPadding * 0.5 , y: 2.5 * verticalSpace, width: UIScreen.mainScreen().bounds.width-widthPadding, height: UIScreen.mainScreen().bounds.height - (2.7*verticalSpace))
        menuSwipeScroll.backgroundColor = UIColor.clearColor()
        menuSwipeScroll.contentSize = CGSize(width: 1.66 * menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.635 * menuSwipeScroll.frame.width, y: 0), animated: false)
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
        
        
        susIconTableView.dataSource = self
        susIconTableView.delegate = self
        susIconTableView.registerClass(ExpandTableViewCell.self, forCellReuseIdentifier: "susIconCell")
        susIconTableView.separatorStyle = .None
        
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            for mutableAttributedString in self.susInfo {
                mutableAttributedString.setAllAsLink("food.davidsonsustainability.org", linkURL: "http://food.davidsonsustainability.org")
            }
            self.susInfo[4].setAsLink(" here", linkURL: "http://www.ers.usda.gov/topics/food-nutrition-assistance/food-security-in-the-us/definitions-of-food-security.aspx")
            self.susInfo[4].setAsLink(" report ", linkURL: "http://www.nrdc.org/greenbusiness/guides/sports/files/game-day-food-report.pdf")
        }
    }
    
    
    private func addScrollIcon(){
        let xUnit : CGFloat = self.view.frame.width / 100
        let yUnit : CGFloat = self.view.frame.height / 100
        
        icon.frame = CGRect(x: 60 * xUnit + 7, y: verticalSpace, width: 1.5 * widthPadding, height: 2 * verticalSpace)
        icon.setBackgroundImage(UIImage(named: "arrowIcon"), forState: UIControlState.Normal)
        icon.contentMode = .ScaleToFill
        icon.addTarget(self, action: "viewMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.menuSwipeScroll.addSubview(icon)
        icon.hidden = false
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        if scrollView == susIconTableView || scrollView == susInfoTableView{
            icon.hidden = true
        }
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == susIconTableView || scrollView == susInfoTableView{
            icon.hidden = false
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == susIconTableView || scrollView == susInfoTableView{
            icon.hidden = false            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let boo = isFromInfo {
            if boo{
                goToType("Sustainability Labels")
            }
        }
    }
    
    private func addScrollView(){
        let xUnit : CGFloat = self.menuSwipeScroll.frame.width / 100
        let yUnit : CGFloat = self.menuSwipeScroll.frame.height / 100

        menuSwipeScroll.addSubview(susIconTableView)
    }
    
    
    func addTableView(){
        let xUnit : CGFloat = self.view.frame.width / 100
        let yUnit : CGFloat = self.view.frame.height / 100
        
        aboutSusView.frame = CGRect(x: 60 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        aboutSusView.layer.borderColor = UIColor(red: 0.114, green: 0.22, blue: 0.325, alpha: 0.9).CGColor
        aboutSusView.layer.borderWidth = 10
        aboutSusView.layer.cornerRadius = 5
        aboutSusView.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.9, alpha: 0.9)
        
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
        
        let imageView = UIImageView(frame: CGRect(x: 25 * xUnit, y: 2 * yUnit, width: 23 * yUnit, height: 23 * yUnit))
        imageView.image = UIImage(named: "susTriangle")
        imageView.contentMode = .ScaleToFill
        
        
        let topTextLabel = UILabel(frame: CGRect(x: 7 * xUnit, y: 25 * yUnit, width: 81 * xUnit, height: 15 * yUnit))
        topTextLabel.attributedText = "<p style=\"font-size: 1.2em; text-align: center; font-family: Helvetica; color: rgb(30,32,34);\"><i><strong>Foodscape</strong> seeks to promote sustainability among local communities by providing consumers with relevant food-related sustainability information.</i></p></font>".html2AttStr
        topTextLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        topTextLabel.numberOfLines = 0
        topTextLabel.sizeToFit()
        
        susInfoTableView.frame = CGRect(x: 0, y: 0.43 * menuSwipeScroll.frame.height, width: menuSwipeScroll.frame.width, height: 0.55 * menuSwipeScroll.frame.height)
        susInfoTableView.backgroundColor = UIColor.clearColor()
        
        
        aboutSusView.addSubview(topTextLabel)
        aboutSusView.addSubview(imageView)
        aboutSusView.addSubview(susInfoTableView)
        
        
        let iconTopTextImage = UIImageView(frame: CGRect(x: 25 * xUnit, y: 2 * yUnit, width: 23 * yUnit, height: 23 * yUnit))
        iconTopTextImage.image = UIImage(named: "susTriangle")
        iconTopTextImage.contentMode = .ScaleToFill
        
        
        iconSusView.frame = CGRect(x: 60 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        iconSusView.layer.borderColor = UIColor(red: 0.114, green: 0.22, blue: 0.325, alpha: 0.9).CGColor
        iconSusView.layer.borderWidth = 10
        iconSusView.layer.cornerRadius = 5
        iconSusView.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.9, alpha: 0.9)
        iconSusView.alpha = 0
        
        susIconTableView.frame = CGRect(x: 0, y: 0.3 * menuSwipeScroll.frame.height, width: menuSwipeScroll.frame.width, height: 0.69 * menuSwipeScroll.frame.height)
        susIconTableView.backgroundColor = UIColor.clearColor()
        
        
        iconSusView.addSubview(susIconTableView)
        iconSusView.addSubview(iconTopTextImage)

        menuSwipeScroll.addSubview(iconSusView)
        menuSwipeScroll.addSubview(aboutSusView)
        

        
    }
    
    internal func bringBack(sender: AnyObject){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.635 * menuSwipeScroll.frame.width, y: 0), animated: true)
    }
    
    
    internal func viewMenu(swipeGestureRecognizer: UIGestureRecognizer) {
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
        if tableView == susIconTableView {
            return levels.count
        }
        return 2
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == susIconTableView {
            var cell = tableView.dequeueReusableCellWithIdentifier("susIconCell", forIndexPath: indexPath) as! ExpandTableViewCell
            cell.selectionStyle = .None
            cell.susContentView.frame = CGRect(x:0.05 * menuSwipeScroll.frame.width, y: defaultHeight, width:menuSwipeScroll.frame.width * 0.9, height: 0)
            cell.susContentView.backgroundColor = UIColor.clearColor()
            cell.titleLabel.text = self.levels[indexPath.row]
            cell.titleView.backgroundColor = UIColor(red: 60/255.0, green: 96/255.0, blue: 128/255.0, alpha: 1)
            cell.titleView.layer.cornerRadius = 8
            cell.titleView.layer.masksToBounds = true
            cell.titleView.frame = CGRect(x: 0.05 * menuSwipeScroll.frame.width, y: 0, width: 0.9 * menuSwipeScroll.frame.width, height: defaultHeight * 0.95)
            cell.titleLabel.frame = CGRect(x: 0.01 * menuSwipeScroll.frame.width, y: 0, width: 0.8 * menuSwipeScroll.frame.width, height: defaultHeight * 0.95)
            cell.downArrowImageView.frame = CGRect(x: 0.82 * menuSwipeScroll.frame.width, y: 0.38 * defaultHeight, width: 0.3 * defaultHeight, height: 0.2 * defaultHeight)
            var y : CGFloat = verticalSpace
            let descriptions = IconInfo().descriptions[levels[indexPath.row]]!
            for section in descriptions {
                for labelName: String in section.keys.array {
                var x : CGFloat = widthPadding
                let labelView = UIView()
                if UIImage(named: labelName) != nil {
                    let labelImage = UIImageView(frame: CGRect(x: x, y: 0, width: 0.1 * susIconTableView.frame.width, height: 0.1 * susIconTableView.frame.width))
                    labelImage.image = UIImage(named: labelName)
                    labelImage.contentMode = .ScaleToFill
                    x += labelImage.frame.width + widthPadding
                    labelView.addSubview(labelImage)
                }
                let labelDescription = UITextView(frame: CGRect(x: x, y: 0, width: susIconTableView.frame.width - x - 2.5 * widthPadding, height: 0))
                    labelDescription.editable = false
                    labelDescription.scrollEnabled = false
                    labelDescription.backgroundColor = UIColor.clearColor()
                labelDescription.text = section[labelName]!

                labelDescription.textAlignment = .Left
                labelDescription.font = UIFont(name: "Helvetica", size: susIconTableView.frame.width * 0.05)
                labelView.frame = CGRect(x: 0, y: y, width: susIconTableView.frame.width, height: UIScreen.mainScreen().bounds.height)
                labelDescription.sizeToFit()
                labelView.addSubview(labelDescription)
                labelView.sizeToFit()
                cell.susContentView.addSubview(labelView)
                y = y + labelDescription.frame.height
            }
            }
            cell.backgroundColor = UIColor.clearColor()
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        
        
        }
        if tableView == susInfoTableView {
            var cell = tableView.dequeueReusableCellWithIdentifier("susCell", forIndexPath: indexPath) as! ExpandTableViewCell
            cell.selectionStyle = .None
            cell.foodSystemImageView.hidden = !(indexPath.row == 6)
            if indexPath.row == 6 {
                cell.foodSystemImageView.frame = CGRect(x:0.03 * menuSwipeScroll.frame.width, y: 0, width:menuSwipeScroll.frame.width * 0.9, height:getHeight(indexPath.row))
                cell.foodSystemImageView.image = UIImage(named: "foodSystem")
                cell.foodSystemImageView.contentMode = .ScaleToFill
            }
            cell.susContentView.frame = CGRect(x:0.05 * menuSwipeScroll.frame.width, y:defaultHeight, width:menuSwipeScroll.frame.width * 0.9, height:getHeight(indexPath.row))
            cell.contentLabel.frame = CGRect(x:0, y:0, width: menuSwipeScroll.frame.width * 0.88, height:getHeight(indexPath.row))
            cell.susContentView.backgroundColor = UIColor.clearColor()
            cell.contentLabel.textAlignment = .Left
            cell.contentLabel.backgroundColor = UIColor.clearColor()
            cell.titleLabel.text = self.subTitles[indexPath.row]
            cell.titleView.backgroundColor = UIColor(red: 60/255.0, green: 96/255.0, blue: 128/255.0, alpha: 1)
            cell.titleView.layer.cornerRadius = 8
            cell.titleView.layer.masksToBounds = true
            cell.titleView.frame = CGRect(x: 0.05 * menuSwipeScroll.frame.width, y: 0, width: 0.9 * menuSwipeScroll.frame.width, height: defaultHeight * 0.95)
            cell.titleLabel.frame = CGRect(x: 0.01 * menuSwipeScroll.frame.width, y: 0, width: 0.8 * menuSwipeScroll.frame.width, height: defaultHeight * 0.95)
            cell.contentLabel.attributedText = self.susInfo[indexPath.row]
            cell.downArrowImageView.frame = CGRect(x: 0.81 * menuSwipeScroll.frame.width, y: 0.38 * defaultHeight, width: 0.3 * defaultHeight, height: 0.2 * defaultHeight)
            cell.backgroundColor = UIColor.clearColor()
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            return cell
        } else {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as! TypesTableViewCell
        cell.selectionStyle = .None
        if indexPath.row == 0 {
            cell.delegate = self
            cell.textLabel!.text = "About Sustainability"
        }
        if indexPath.row == 1 {
            cell.delegate = self
            cell.textLabel!.text = "Sustainability Icons"
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
        if tableView == susInfoTableView || tableView == susIconTableView {
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
        if tableView == susInfoTableView || tableView == susIconTableView {
        (cell as! ExpandTableViewCell).watchFrameChanges()
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == susInfoTableView || tableView == susIconTableView {
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
        if tableView == susIconTableView {
            if indexPath == selectedIndexPath {
                return getHeightForIcon(indexPath.row) + self.defaultHeight + verticalSpace
            } else {
                return self.defaultHeight
            }
        }
        return self.defaultHeight
    }
    
    func getHeight(index : Int) -> CGFloat{
        let testLabel = UITextView(frame: CGRect(x: 0, y: 0, width: susInfoTableView.frame.width * 8, height: 0))
        testLabel.attributedText = susInfo[index]
        testLabel.frame.size.width = susInfoTableView.frame.width
        testLabel.sizeToFit()
        return testLabel.frame.height * 1.15
    }
    
    func getHeightForIcon(index : Int) -> CGFloat{
        var testSusView = UIView(frame: CGRect(x: 0, y: 0, width: 0.9 * susIconTableView.frame.width, height: 0))
        var y : CGFloat = verticalSpace
        let descriptions = IconInfo().descriptions[levels[index]]!
        for section in descriptions {
            for labelName: String in section.keys.array {
            var x : CGFloat = widthPadding
            let labelView = UIView()
            if UIImage(named: labelName) != nil {
                let labelImage = UIImageView(frame: CGRect(x: x, y: 0, width: 0.1 * susIconTableView.frame.width, height: 0.1 * susIconTableView.frame.width))
                labelImage.image = UIImage(named: labelName)
                labelImage.contentMode = .ScaleToFill
                x += labelImage.frame.width + widthPadding
                labelView.addSubview(labelImage)
            }
            let labelDescription = UITextView(frame: CGRect(x: x, y: 0, width: susIconTableView.frame.width - x - 3 * widthPadding, height: 0))
            labelDescription.text = section[labelName]!
            labelDescription.textAlignment = .Left
            labelDescription.font = UIFont(name: "Helvetica", size: susIconTableView.frame.width * 0.05)
            labelView.frame = CGRect(x: 0, y: y, width: susIconTableView.frame.width, height: UIScreen.mainScreen().bounds.height)
            labelDescription.sizeToFit()
            labelView.addSubview(labelDescription)
            labelView.sizeToFit()
            testSusView.addSubview(labelView)
            y = y + labelDescription.frame.height
        }
        }
        return y
    }
    
    
    func goToType(type: String){
        menuSwipeScroll.setContentOffset(CGPoint(x: 0.635 * menuSwipeScroll.frame.width, y: 0), animated: true)
        if type == "About Sustainability" {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.iconSusView.alpha = 0
                    self.aboutSusView.alpha = 1
                }, completion: nil)
            self.title = "About Sustainability"
        } else {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.iconSusView.alpha = 1
                self.aboutSusView.alpha = 0
                }, completion: nil)
            self.title = "Sustainability Icon"
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