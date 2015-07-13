//
//  FoodTinderTableViewCell.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 30/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//


import UIKit
import QuartzCore
import Parse


/**
Manages the cell representation of a dish in a menu
*/
class FoodTinderTableViewCell: UITableViewCell {
    let styles = Styles()
    let gradientLayer = CAGradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, likeOnDragRelease = false
    var tickLabel: UILabel, crossLabel: UILabel
    let label: UILabel
    var itemLikeLayer = CALayer()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var chefNoteLabel: UILabel
    var susLabels: UIScrollView
    //var ecoLabel: UILabel

    // The object that acts as delegate for this cell
    var delegate: FoodTinderViewCellDelegate?
    // The dish that this cell renders
    var dish: Dish? {
        didSet {
            label.text = dish!.name
         //   chefNoteLabel.text = dish!.chefNote
               chefNoteLabel.text = "Lorem ipsum"
         //   ecoLabel.text = dish!.ecoLabel
            
            itemLikeLayer.hidden = !dish!.like
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // create a label that renders the to-do item text
        label = UILabel(frame: CGRect.nullRect)
        label.textColor = styles.labelTextColor
        label.font = UIFont.boldSystemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        
        chefNoteLabel = UILabel(frame: CGRect.nullRect)
        chefNoteLabel.textColor = styles.labelTextColor
        //chefNoteLabel.font = UIFont.boldSystemFontOfSize(16)
        chefNoteLabel.backgroundColor = UIColor.clearColor()
        
        susLabels = UIScrollView(frame: CGRect.nullRect)
        
        
        /**
        utility method for creating the contextual cues
        */
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.nullRect)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.boldSystemFontOfSize(32.0)
            label.backgroundColor = UIColor.clearColor()
            return label
        }
        
        // tick and cross labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .Right
        crossLabel = createCueLabel()
        crossLabel.text = "\u{2717}"
        crossLabel.textAlignment = .Left
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(chefNoteLabel)
        addSubview(tickLabel)
        addSubview(crossLabel)
        //addSubview(boarder)
        // remove the default blue highlight for selected cells
        selectionStyle = .None
        
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)
        
        
        // add a layer that renders a green background when a user like the dish %anwu
        itemLikeLayer = CALayer(layer: layer)
        itemLikeLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).CGColor
        itemLikeLayer.hidden = true
        layer.insertSublayer(itemLikeLayer, atIndex: 0)
        
        // add a pan recognizer
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    //Label Location in cell
    let kLabelLeftMargin: CGFloat = 50.0
    let kLabelTopMargin: CGFloat = 0.0

    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let halfScreen = screenWidth/2
        
        // ensure the gradient layer occupies the full bounds
        gradientLayer.frame = bounds
        itemLikeLayer.frame = bounds
        label.frame = CGRect(x: (screenWidth*0.06), y: 0,
            width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()

        chefNoteLabel.frame = CGRect(x: (screenWidth*0.06), y: 85,
            width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
        chefNoteLabel.bounds = CGRectMake(0, 100, (screenWidth*0.8), 200)
        chefNoteLabel.textColor = UIColor.whiteColor()
        chefNoteLabel.textAlignment = NSTextAlignment.Center
        chefNoteLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        chefNoteLabel.numberOfLines = 0

        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
        
        self.imageView?.bounds = CGRectMake(0, 0, screenWidth - 20, screenHeight * 0.5 - 20)
        self.imageView?.frame = CGRect(x: 0, y: 0, width: screenWidth - 20, height: screenHeight * 0.5 - 20)
        self.imageView?.contentMode = .ScaleToFill
        let darkBlueColor = UIColor(red: 0.0/255, green: 7.0/255, blue: 72.0/255, alpha: 0.75)
        self.imageView?.layer.borderColor = darkBlueColor.CGColor
        self.imageView?.layer.borderWidth = 8.0
        //self.imageView?.layer.cornerRadius = 5
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.masksToBounds = true
    }
    
    
    /**
    MARK: - horizontal pan gesture methods
    */
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            // Updates the center point of the cell so that cell is animatable when panned
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/Like?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            likeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            // fades the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            // indicates when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = likeOnDragRelease ? UIColor.greenColor() : UIColor.whiteColor()
            crossLabel.textColor = deleteOnDragRelease ? UIColor.redColor() : UIColor.whiteColor()
        }
        // 3
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                if delegate != nil && dish != nil {
                    // notify the delegate that this item should be deleted
                    dish?.like = false
                    dish?.dislike = true
                    self.delegate!.toDoItemDeleted(self.dish!)
                    self.delegate!.uploadDislike(self.dish!)
                }
            } else if likeOnDragRelease {
                if dish != nil {
                    dish!.like = true
                    //removes cell once it is liked
                    dish?.dislike = false
                    self.delegate!.toDoItemDeleted(self.dish!)
                    self.delegate!.uploadPreference(self.dish!)
                }
            } else {
                UIView.animateWithDuration(0.3, animations: {self.frame = originalFrame})
            }
        }
    }
    
    
    /**
    MARK: - tap gesture methods
    */
    
    
    /**
    Returns true when a gesture should begin
    */
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        // pan gesture recognizer
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        // pan gesture recognizer
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer {
            return true
        }
        return false
    }
}
