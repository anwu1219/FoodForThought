//
//  TypesTableViewCell.swift
//  FoodForThought
//
//  Created by Wu, Andrew on 7/20/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit


class TypesTableViewCell: UITableViewCell {

    var delegate: TypesTableViewCellDelegate?
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // create a label that renders the to-do item text
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            if delegate != nil {
                if let text = self.textLabel?.text!{
                    delegate!.goToType(text)
                }
            }
        }
    }
    

}