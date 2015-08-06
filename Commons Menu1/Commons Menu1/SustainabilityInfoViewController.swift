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
    var susInfo : [NSMutableAttributedString]!
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
        
        
        let iconTopTextLabel = UILabel(frame: CGRect(x: 1 * xUnit, y: 2 * yUnit, width: 90 * xUnit, height: 18 * yUnit))
        iconTopTextLabel.text = "Sustainability Icons"
        iconTopTextLabel.font = UIFont(name: "HelveticaNeue-Bold", size: self.view.frame.width * 0.08)
        iconTopTextLabel.textAlignment = .Center
        
        
        iconSusView.frame = CGRect(x: 60 * xUnit, y: 0, width: menuSwipeScroll.frame.width, height: menuSwipeScroll.frame.height)
        iconSusView.layer.borderColor = UIColor(red: 0.114, green: 0.22, blue: 0.325, alpha: 0.9).CGColor
        iconSusView.layer.borderWidth = 10
        iconSusView.layer.cornerRadius = 5
        iconSusView.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.9, alpha: 0.9)
        iconSusView.alpha = 0
        
        susIconTableView.frame = CGRect(x: 0, y: 0.20 * menuSwipeScroll.frame.height, width: menuSwipeScroll.frame.width, height: 0.79 * menuSwipeScroll.frame.height)
        susIconTableView.backgroundColor = UIColor.clearColor()
        
        
        iconSusView.addSubview(susIconTableView)
        iconSusView.addSubview(iconTopTextLabel)

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