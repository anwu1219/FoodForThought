//
//  PreferenceListViewController.swift
//  Commons Menu1
//
//  Created by Andrew Wu on 6/18/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class PreferenceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var preferenceListTableView: UITableView!
    var dishPreferences = Bunduru().Commons
    
    let preferences1 = ["Meal 1",
        "Meal 2",
        "Meal 3",
        "Meal 4",
        "Meal 5",
        "Meal 6"]
    
    let preferences2 = ["Meal 1",
        "Meal 2",
        "Meal 3",
        "Meal 4",
        "Meal 5",
        "Meal 6"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceListTableView.dataSource = self
        preferenceListTableView.delegate = self
        
    }
    
    //number of section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 //can be customized to number of restuarant
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return preferences1.count
        }
        return preferences2.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        if indexPath == 0{
            let dish = preferences1[indexPath.row]
            cell.textLabel?.text = dish
            cell.detailTextLabel?.text = "Hey"
        } else {
        let dish = preferences2[indexPath.row]
        cell.textLabel?.text = dish
        cell.detailTextLabel?.text = "Hey"
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Commons"
        } else {
            return "Union"
        }
    }
    
    
}