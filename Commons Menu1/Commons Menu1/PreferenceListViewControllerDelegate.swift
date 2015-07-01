//
//  PreferenceListViewControllerDelegate.swift
//  Commons Menu1
//
//  Created by Chadinha, Spencer on 6/25/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol PreferenceListViewControllerDelegate {
    /**
    Reverts cell background color to original when removed from preference list
    */
    func updatePreferences(preferenceList: [Dish])
}