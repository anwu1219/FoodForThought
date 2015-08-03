//
//  ExpandTableViewCell.swift
//  Foodscape
//
//  Created by Wu, Andrew on 8/3/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import UIKit

class ExpandTableViewCell: UITableViewCell {
    let titleLabel : UILabel
    let contentLabel : UILabel
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel(frame: CGRect.nullRect)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping

        
        
        contentLabel = UILabel(frame: CGRect.nullRect)
        contentLabel.textColor = UIColor.blackColor()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        contentLabel.frame = CGRect(x:0, y:self.frame.height, width:self.frame.width, height:2 * self.frame.height)
        contentLabel.sizeToFit()
    }
    
    
    func checkHeight() {
        contentLabel.hidden = (frame.size.height < ExpandTableViewCell.expandedHeight)
    }
        
    func watchFrameChanges() {
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New|NSKeyValueObservingOptions.Initial, context: nil)
    }
        
    func ignoreFrameChanges() {
        removeObserver(self, forKeyPath: "frame")
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change:[NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
