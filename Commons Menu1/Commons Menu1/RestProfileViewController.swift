//
//  RestProfileViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 6/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class RestProfileViewController: UIViewController, UIScrollViewDelegate {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var restProf : RestProfile!
    let styles = Styles()

    @IBOutlet weak var restProfDescription: UILabel!
    @IBOutlet weak var restProfImage: UIImageView!
    @IBOutlet weak var restProfName: UINavigationItem!
    @IBOutlet var restProfileView: UIView!
    @IBOutlet weak var restProfScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restProf?.name
        restProfImage.image = restProf.image
        // Do any additional setup after loading the view.
        restProfScrollView.delegate = self
        restProfScrollView.contentSize.height = 800
        restProfScrollView.layer.borderWidth = 2
        restProfScrollView.layer.borderColor = UIColor.blackColor().CGColor
        restProfScrollView.backgroundColor = UIColor(red: 147/255.0, green: 143/255.0, blue: 161/255.0, alpha: 0.75)
        
        let openHourLabel = UILabel()
        
        
       // restWeekdayHoursLabel.text = restProf!.weekdayHours
       // restWeekendHoursLabel.text = restProf!.weekendHours
       // restWeekdayHoursLabel.numberOfLines = 2
       // restWeekendHoursLabel.numberOfLines = 2
       // restPhoneNumLabel.text = restProf!.phoneNumber
       // restAddressLabel.text = restProf!.address
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
