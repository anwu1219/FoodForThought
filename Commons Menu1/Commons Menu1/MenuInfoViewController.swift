//
//  MenuInfoViewController.swift
//  Commons Menu1
//
//  Created by Chadinha, Spencer on 6/22/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

/**
Displays information on a given dish
*/
class MealInfoViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var dishName: UINavigationItem!
    @IBOutlet weak var susLabelView: UIScrollView!
    @IBOutlet weak var labelsLabel: UILabel!
    
    var dish: Dish!
    private let screenSize: CGRect = UIScreen.mainScreen().bounds
    private let progDishImage = UIImageView()
    private let progScrollInfo = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground("dishlevelInfopagebackground")
        progScrollInfo.showsVerticalScrollIndicator = false
        dishName.title = dish?.name
        

        if dish.imageFile != nil {
            dish.imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) ->Void in
                if error == nil {
                    if let data = imageData{
                        if let image = UIImage(data: data){
                            self.progDishImage.image = image
                            self.dish.image = image
                        }
                    }
                }
            }
        } else {
            self.progDishImage.image = UIImage(named: "sloth")
            dish.image =  UIImage(named: "sloth")
        }
        
        // set the programmatical image
        progDishImage.frame = CGRectMake(16, 76, screenSize.width-32, 180)
        progDishImage.contentMode = .ScaleAspectFill
        let darkGreenColor = UIColor(red: 25.0/255, green: 58.0/255, blue: 46/255, alpha: 1)
        progDishImage.layer.borderWidth = 6
        progDishImage.layer.borderColor = darkGreenColor.CGColor
        progDishImage.layer.masksToBounds = true
        
        progScrollInfo.frame = CGRectMake(16, 280, screenSize.width-32, screenSize.height - 280)

        
        self.view.addSubview(progDishImage)
        self.view.addSubview(progScrollInfo)

        
        layoutPage()
    }
    
    /**
    Put dish information into the progScrollInfo
    */
    private func layoutPage() {
        let width: CGFloat = 0.01 * screenSize.width // a unit of x
        let height: CGFloat = 0.01 * screenSize.height // a unit of y
        var x: CGFloat = 0.01 * screenSize.width // current x coordinate
        var y: CGFloat = 0.01 * screenSize.height // current y coordinate
        if let susLabels = dish?.susLabels {
                
                let container = UIView()
                
                let title = UILabel()
                title.text = "Dish Sustainability Info"
                title.frame = CGRectMake(0, y, 85 * width, 10*height)
                title.textAlignment = .Center
                title.font = UIFont(name: "HelveticaNeue-Light", size: 7 * x)
                
                title.textColor = UIColor.whiteColor()
                container.addSubview(title)
                y += 10 * height
            
                let labelWidth = 6 * height
                let labelHeight = 9 * height
                let labelSpace = 0.5 * width
            
            if susLabels.isEmpty && dish!.eco.isEmpty && dish!.humane.isEmpty && dish!.fair.isEmpty {
                
                let noIconLabel = UILabel()
                noIconLabel.text = "No icon information available"
                noIconLabel.frame = CGRectMake(0, y, 85 * width, 10*height)
                noIconLabel.textAlignment = .Center
                noIconLabel.font = UIFont(name: "HelveticaNeue-Light", size: 5 * x)
            
                y += 10 * height
            
                noIconLabel.textColor = UIColor.lightGrayColor()
                container.addSubview(noIconLabel)
            }
            
                let labelPicsScroll = UIScrollView()
            
                let length = (CGFloat(susLabels.count + boolToInt(!dish!.eco.isEmpty) + boolToInt(!dish!.humane.isEmpty) + boolToInt(!dish!.fair.isEmpty))) * (labelWidth+labelSpace) + labelSpace
                labelPicsScroll.frame = CGRectMake((title.frame.width - length) / 2, y, length,  10*height)
                labelPicsScroll.contentSize = CGSizeMake((CGFloat(susLabels.count + dish!.eco.count + dish!.humane.count + dish!.fair.count)) * (labelWidth+labelSpace) + labelSpace, labelHeight)
                
                var initX: CGFloat = 0
            
            var frame = CGRectMake(initX, height, labelWidth, labelWidth)
            if dish!.eco.count > 0 {
                let ecoIcon = SuperIconButton(labels: dish!.eco, frame: frame, name: "Eco")
                ecoIcon.frame = CGRectMake(initX, height, labelWidth, labelWidth)
                ecoIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                labelPicsScroll.addSubview(ecoIcon)
                initX += labelSpace + labelWidth
            }
            
            if dish!.humane.count > 0 {
                let humaneIcon = SuperIconButton(labels: dish!.humane, frame: frame, name: "Humane")
                humaneIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                humaneIcon.frame = CGRectMake(initX, height, labelWidth, labelWidth)
                labelPicsScroll.addSubview(humaneIcon)
                initX += labelSpace + labelWidth
            }
            
            if dish!.fair.count > 0 {
                let fairIcon = SuperIconButton(labels: dish!.fair, frame: frame, name: "Fair")
                fairIcon.frame = CGRectMake(initX, height, labelWidth, labelWidth)
                fairIcon.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                labelPicsScroll.addSubview(fairIcon)
                initX += labelSpace + labelWidth
            }


                for var i = 0; i < susLabels.count; i++ {
                    let labelImage = IconButton(name: susLabels[i], frame: CGRectMake(initX, height, labelWidth, labelWidth))
                    labelImage.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                    labelPicsScroll.addSubview(labelImage)
                    initX += labelSpace + labelWidth
                }

            
                container.addSubview(labelPicsScroll)
                y += 10 * height
                
                container.frame = CGRect(x: 0, y: 0, width: 91*width, height: 20*height)
                container.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                container.layer.shadowOffset = CGSizeMake(2.0, 2.0)
                container.layer.shadowOpacity = 0.7
                container.sizeToFit()
                progScrollInfo.addSubview(container)
            
        }
        if let location = dish?.location {
            let label = UILabel()
            label.text = "Restaurant: \(location)"
            label.frame = CGRectMake( x, y, 91 * width, 10 * height)
            label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
            label.textColor = UIColor.whiteColor()
            label.numberOfLines = 0
            label.sizeToFit()
            //label.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
            progScrollInfo.addSubview(label)
            y += label.frame.height + (3 * height)
        }
        
        if let price = dish?.price {
            if count(price) > 0 {
                let label = UILabel()
                //label.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 0.6, alpha: 0.8)
                label.text = "Price: \(price)"
                label.frame = CGRectMake(x, y, 91 * width, 10 * height)
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
                label.textColor = UIColor.whiteColor()
                progScrollInfo.addSubview(label)
                y += label.frame.height + (1*height)
            }
        }
        
        if let ingredients = dish?.ingredients {
            if count(ingredients) > 0 {
                let ingLabel = UILabel()
                //ingLabel.backgroundColor = UIColor(red: 0.6, green: 0.3, blue: 0.6, alpha: 0.8)
                ingLabel.text = "Ingredients:"
                ingLabel.frame = CGRectMake(x, y, 91 * width, 10 * height)
                ingLabel.numberOfLines = 0
                ingLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                ingLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
                ingLabel.textColor = UIColor.whiteColor()
                progScrollInfo.addSubview(ingLabel)
                y += ingLabel.frame.height + (3*height)
            }
            for var i = 0; i < ingredients.count; i++ {
                let ingredient = UILabel()
                ingredient.font = UIFont(name: "HelveticaNeue-Light", size: 14)
                ingredient.textColor = UIColor.whiteColor()
                ingredient.frame = CGRectMake( 2 * x, y, 91 * width, 10 * height)
                ingredient.text = "- \(ingredients[i])"
                ingredient.lineBreakMode = NSLineBreakMode.ByWordWrapping
                ingredient.numberOfLines = 0
                let num = CGFloat(2 * count(ingredients[i]))
                ingredient.frame = CGRectMake( 2 * x, y, 91 * width, 10 * height)

                //ingreident.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.8)
                ingredient.sizeToFit()
                progScrollInfo.addSubview(ingredient)

                if let labels = dish?.labels {
                    if !labels.isEmpty{
                        var nutLabelXPosition = screenSize.width * 0.75
                        for label: String in labels[i] {
                            let nutLabel = IconButton(name: label, frame: CGRectMake(nutLabelXPosition, y - 1 * height, 5 * height, 5 * height))
                            nutLabel.addTarget(self, action: "showLabelInfo:", forControlEvents: UIControlEvents.TouchUpInside)
                            progScrollInfo.addSubview(nutLabel)
                            nutLabelXPosition -= 6 * height
                        }
                    }
                }
                y += 5 * height
            }
        }
        progScrollInfo.contentSize.height = y
    }
    
    private func boolToInt(bool : Bool) -> Int {
        if bool {
            return 1
        }
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        linkButton.addTarget(self, action: "learnMoreLink:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let popScroll = UIScrollView()
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
}

extension MealInfoViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}