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
    let titleView: UIView
    let downArrowImageView : UIImageView
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        titleView = UIView(frame: CGRect.nullRect)
        titleLabel = UILabel(frame: CGRect.nullRect)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping

        downArrowImageView = UIImageView(frame: CGRect.nullRect)
        downArrowImageView.image = UIImage(named: "infoItemArrow")
        
        contentLabel = UILabel(frame: CGRect.nullRect)
        contentLabel.textColor = UIColor.blackColor()
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentLabel.textColor = UIColor.blueColor()    
        
        susContentView = UIView(frame: CGRect.nullRect)
        
        foodSystemImageView = UIImageView(frame: CGRect.nullRect)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        

        titleLabel.textAlignment = .Left
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: "HelveticaNeue-BoldItalic", size: frame.width * 0.055)
        titleLabel.layer.cornerRadius = 8
        layer.masksToBounds = true

        
        
        addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(downArrowImageView)
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
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if susContentView.subviews.count > 2 {
            for subview in susContentView.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change:[NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
