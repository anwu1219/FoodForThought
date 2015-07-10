//
//  preferenceListTableViewCell.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/23/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

/**
Manages the cell representation of a dish in a preference list
*/
class preferenceListTableViewCell: UITableViewCell {
    var delegate: MenuTableViewCellDelegate?
    // The item that this cell renders.
    // Var that determines if the cell needs to be deleted 
    var deleteOnDragRelease = false
    // Center point of the cell
    var originalCenter = CGPoint()
    let label: UILabel
    var dish: Dish?{
        didSet {
            label.text = dish!.name
        }
    }
    
//    // Label to help visualize the deletion of a cell
//    var crossLabel: UILabel
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // create a label that renders the to-do item text
        label = UILabel(frame: CGRect.nullRect)
        label.textColor = UIColor.whiteColor()
        //label.font = UIFont.boldSystemFontOfSize(20)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
      
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
        
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    override func layoutSubviews() {
        var width = 0.01 * bounds.size.width
        var height = 0.01 * bounds.size.height
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 5 * width, y: 3 * width, width: 25 * width, height: 75 * height)
        self.imageView?.layer.borderColor = UIColor.blackColor().CGColor
        self.imageView?.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(red: 153/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1).CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor(red: 215.0/255, green: 203.0/255, blue: 188.0/255, alpha: 0.75)
        let kLabelLeftMargin: CGFloat = 36 * width
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
        self.detailTextLabel?.font =  UIFont(name: "Helvetica Neue", size: 20)
    }

    func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            if self.delegate != nil && dish != nil {
                self.delegate!.viewDishInfo(dish!)
            }
        }
    }
    
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
        }
        // 3
        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                if self.delegate != nil && dish != nil {
                    // notify the delegate that this item should be deleted
                    dish!.like = false
                    self.delegate!.toDoItemDeleted(dish!)
                    dish?.dislike = false
                }
            }
            else {
                UIView.animateWithDuration(0.3, animations: {self.frame = originalFrame})
            }
        }
    }

    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer {
            //delegate!.viewDishInfo(dish!)
            return true
            
        }
        return false
    }
}
