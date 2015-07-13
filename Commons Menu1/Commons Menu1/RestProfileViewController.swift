//
//  RestProfileViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class RestProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var restProf : RestProfile!
    let styles = Styles()


    @IBOutlet weak var restProfDescription: UILabel!
    @IBOutlet weak var restProfImage: UIImageView!
    @IBOutlet weak var restProfName: UINavigationItem!
    @IBOutlet var restProfileView: UIView!
    @IBOutlet weak var restProfTable: UITableView!
    
    @IBOutlet weak var restAddressLabel: UILabel!
    @IBOutlet weak var restPhoneNumLabel: UILabel!
    @IBOutlet weak var restWeekdayHoursLabel: UILabel!
    @IBOutlet weak var restWeekendHoursLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restProf?.name
        restProfImage.image = restProf.image
        // Do any additional setup after loading the view.
        restProfTable.dataSource = self
        restProfTable.delegate = self
        restProfTable.rowHeight = 200;
        restProfTable.layer.borderWidth = 2
        restProfTable.layer.borderColor = UIColor.blackColor().CGColor
        restProfTable.backgroundColor = UIColor(red: 122/255.0, green: 118/255.0, blue: 162/255.0, alpha: 1)
        restProfTable.separatorStyle = .SingleLine
        restProfTable.backgroundView = styles.backgroundImage
        restProfTable.backgroundView?.contentMode = .ScaleAspectFill
        
        restWeekdayHoursLabel.text = restProf!.weekdayHours
        restWeekendHoursLabel.text = restProf!.weekendHours
        restWeekdayHoursLabel.numberOfLines = 2
        restWeekendHoursLabel.numberOfLines = 2
        restPhoneNumLabel.text = restProf!.phoneNumber
        restAddressLabel.text = restProf!.address
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    /**
    Returns the number of sections in the table
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    
    /**
    Returns the number of rows in the table
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /**
    Generates cells and adds items to the table
    */
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            //initiates the cell
            let cell = tableView.dequeueReusableCellWithIdentifier("restProfCell", forIndexPath: indexPath) as! RestaurantProfileTableViewCell
            let restCommentsLabel = UILabel()
            
            restCommentsLabel.frame = CGRectMake(30, 50, self.restProfTable.frame.size.width, 50)
            //
            restCommentsLabel.textAlignment = .Center
            restCommentsLabel.text = "Restaurant Comments"
            restCommentsLabel.textColor = UIColor.whiteColor()

            cell.textLabel?.text = "test"
            cell.selectionStyle = .None

            return cell
    }
    
    
    /**
    Returns the title of each section
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Environmental"
        }
        if section == 1 {
            return "Social"
        }
       return "Economic"
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewLabel = UILabel()
        headerViewLabel.frame = CGRectMake(0, 0, restProfTable.frame.size.width, 100)
        headerViewLabel.backgroundColor = UIColor(red: 122/255.0, green: 118/255.0, blue: 162/255.0, alpha: 1)
        
        
        if section == 0 {
            headerViewLabel.text = "Environmental"
        }
        if section == 1 {
            headerViewLabel.text =  "Social"
        }
        if section == 2 {
            headerViewLabel.text =  "Economic"
        }
        
        headerViewLabel.textAlignment = .Center
        headerViewLabel.textColor = UIColor.whiteColor()
        headerViewLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        headerViewLabel.layer.borderColor = UIColor(red: 116/255.0, green: 70/255.0, blue: 37/255.0, alpha: 0.75).CGColor
        headerViewLabel.layer.borderWidth = 1.0
        
        return headerViewLabel
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
