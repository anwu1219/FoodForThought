//
//  DayExtension.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 7/13/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func getDayOfWeek()->Int {
        let date = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: date)
        let weekDay = myComponents.weekday
        return weekDay - 1
    }
    
    func getDate() -> String {
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        return dateFormatter.stringFromDate(date)
    }
    
    func noInternetAlert(message: String) {
        let alertController = UIAlertController(title: "No Internet Connection",
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            }        )
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setBackground(fileName : String){
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: fileName)
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
    }
}