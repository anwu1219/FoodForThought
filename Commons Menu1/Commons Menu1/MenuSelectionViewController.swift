//
//  MenuSelectionViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class MenuSelectionViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!
    var menu = [Dish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.backgroundColor = UIColor.blackColor()
        menuTableView.separatorStyle = .None
        menuTableView.rowHeight = 50.0
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        if menu.count > 0 {
            return
        }
        menu.append(Dish(text: "feed the cat"))
        menu.append(Dish(text: "buy eggs"))
        menu.append(Dish(text: "watch WWDC videos"))
        menu.append(Dish(text: "rule the Web"))
        menu.append(Dish(text: "buy a new iPhone"))
        menu.append(Dish(text: "darn holes in socks"))
        menu.append(Dish(text: "write this tutorial"))
        menu.append(Dish(text: "master Swift"))
        menu.append(Dish(text: "learn to draw"))
        menu.append(Dish(text: "get more exercise"))
        menu.append(Dish(text: "catch up with Mom"))
        menu.append(Dish(text: "get a hair cut"))
        
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                forIndexPath: indexPath) as! TableViewCell
            let item = menu[indexPath.row]
            cell.textLabel?.text = item.name
            cell.selectionStyle = .None
            cell.delegate = self
            cell.dish = item
            return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat {
            return tableView.rowHeight;
    }
    
    
    // MARK: - Table view delegate
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = menu.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    
    func dishDeleted(dish: Dish) {
        let index = (menu as NSArray).indexOfObject(dish)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        menu.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        menuTableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        menuTableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        menuTableView.endUpdates()
    }
    

}