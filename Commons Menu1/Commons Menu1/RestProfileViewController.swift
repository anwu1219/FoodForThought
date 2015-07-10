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

    @IBOutlet weak var restProfDescription: UILabel!
    @IBOutlet weak var restProfImage: UIImageView!
    @IBOutlet weak var restProfName: UINavigationItem!
    @IBOutlet weak var restProfile: UITableView!
    @IBOutlet weak var restScrollView: UIScrollView!
    @IBOutlet var restProfileView: UIView!
    
    @IBOutlet weak var restAddressLabel: UILabel!
    @IBOutlet weak var restPhoneNumLabel: UILabel!
    @IBOutlet weak var restWeekdayHoursLabel: UILabel!
    @IBOutlet weak var restWeekendHoursLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       restProfName.title = RestProfile?.name
        restProfImage.image = restProf.image
        // Do any additional setup after loading the view.
        
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "forkmenubackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        restScrollView.contentSize.width = screenSize.width
        restScrollView.contentSize.height = 600
        restScrollView.backgroundColor = UIColor.whiteColor()
        
        restWeekdayHoursLabel.text = restProf!.weekdayHours
        restWeekendHoursLabel.text = restProf!.weekendHours
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
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            
            //
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
