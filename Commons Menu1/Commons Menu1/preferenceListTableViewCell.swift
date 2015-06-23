//
//  preferenceListTableViewCell.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/23/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class preferenceListTableViewCell: UITableViewCell {
    var delegate: MenuTableViewCellDelegate?
    // The item that this cell renders.
    var dish: Dish?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
    }
    

    func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            println(dish)
            println("Delegate: \(delegate)" )
            if delegate != nil && dish != nil {
                println("Recognized the tap")
                delegate!.viewDishInfo(dish!)
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
            //            self.label.text = "Changed"
            //            self.label.textColor = UIColor.yellowColor()
            //            testLabel.hidden = false
            //println("\(dish!.name)'s cell was clicked" )
            //var x = ()
            delegate!.viewDishInfo(dish!)
            
        }
        return false
    }
}
