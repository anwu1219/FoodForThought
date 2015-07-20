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
}