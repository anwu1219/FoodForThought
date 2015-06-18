//
//  MenuSwipeViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 18/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class MenuSwipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
   
    var toDoItems = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.blackColor()
        tableView.rowHeight = 50;
        
        if toDoItems.count > 0 {
            return
        }
        toDoItems.append(ToDoItem(text: "Menu Item 1"))
        toDoItems.append(ToDoItem(text: "Menu Item 2"))
        toDoItems.append(ToDoItem(text: "Menu Item 3"))
        toDoItems.append(ToDoItem(text: "Menu Item 4"))
        toDoItems.append(ToDoItem(text: "Menu Item 5"))
        toDoItems.append(ToDoItem(text: "Menu Item 6"))
        toDoItems.append(ToDoItem(text: "Menu Item 7"))
        toDoItems.append(ToDoItem(text: "Menu Item 8"))
        toDoItems.append(ToDoItem(text: "Menu Item 9"))
        toDoItems.append(ToDoItem(text: "Menu Item 10"))
        toDoItems.append(ToDoItem(text: "Menu Item 11"))
        toDoItems.append(ToDoItem(text: "Menu Item 12"))
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
            //            cell.textLabel?.backgroundColor = UIColor.clearColor()
            
            cell.selectionStyle = .None
            let item = toDoItems[indexPath.row]
            //            cell.textLabel?.text = item.text
            cell.delegate = self
            cell.toDoItem = item
            return cell
    }
    
    func toDoItemDeleted(toDoItem: ToDoItem) {
        // could use this to get index when Swift Array indexOfObject works
        // let index = toDoItems.indexOfObject(toDoItem)
        // in the meantime, scan the array to find index of item to delete
        var index = 0
        for i in 0..<toDoItems.count {
            if toDoItems[i] === toDoItem {  // note: === not ==
                index = i
                break
            }
        }
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        toDoItems.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
    }
    
    // MARK: - Table view delegate
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    // support for versions of iOS prior to iOS 8
    func tableView(tableView: UITableView, heightForRowAtIndexPath
        indexPath: NSIndexPath) -> CGFloat {
            return tableView.rowHeight;
    }
    
}
