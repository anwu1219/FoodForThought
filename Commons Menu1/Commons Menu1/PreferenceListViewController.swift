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
    //var dishPreferences = Bunduru().Commons
    
    var preferences: [Dish]!
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
        return 1 //can be customized to number of restuarant
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return preferences.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            let dish = preferences[indexPath.row].name
            cell.textLabel?.text = dish

//        var cell = UITableViewCell()
//        cell.textLabel?.text = "Hey!"
        
        var sloth = UIImage(named: "sloth")
        cell.imageView?.image = sloth
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Commons"
    }
}