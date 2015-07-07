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
    var dish: Dish?
    // Var that determines if the cell needs to be deleted 
    var deleteOnDragRelease = false
    // Center point of the cell
    var originalCenter = CGPoint()
    
    
//    // Label to help visualize the deletion of a cell
//    var crossLabel: UILabel
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
        
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
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
