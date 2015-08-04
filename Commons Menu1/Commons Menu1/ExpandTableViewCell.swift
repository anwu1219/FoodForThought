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
    let susContentView : UIView
    let foodSystemImageView : UIImageView
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
        contentLabel.textColor = UIColor.blueColor()    
        
        susContentView = UIView(frame: CGRect.nullRect)
        
        foodSystemImageView = UIImageView(frame: CGRect.nullRect)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.backgroundColor = UIColor(red: 0.114, green: 0.22, blue: 0.325, alpha: 1)

        
        titleLabel.frame = CGRect(x: 0.04 * self.frame.width, y: 0, width: 0.83 * self.frame.width, height: self.frame.height)
        titleLabel.textAlignment = .Left
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-BoldItalic", size: frame.width * 0.052)
        titleLabel.layer.cornerRadius = 8
        layer.masksToBounds = true
        
        
        addSubview(titleLabel)
        susContentView.addSubview(contentLabel)
        susContentView.addSubview(foodSystemImageView)
        addSubview(susContentView)
    }
    
    
    func checkHeight() {
        susContentView.hidden = !(frame.size.height > UIScreen.mainScreen().bounds.height * 0.1)
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
