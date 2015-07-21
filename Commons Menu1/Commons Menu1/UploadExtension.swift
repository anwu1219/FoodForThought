//
//  UploadExtension.swift
//  Commons Menu1
//
//  Created by Wu, Andrew on 7/12/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

extension UIViewController {
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
    
    
    /**
    Uploads the preference list
    */
    func uploadPreference(dish: Dish){
        if let user = PFUser.currentUser(){
            let newPreference = PFObject(className:"Preference")
            newPreference["createdBy"] = PFUser.currentUser()
            newPreference["dishName"] = dish.name
            newPreference["location"] = dish.location
            newPreference.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    user["tinderViewed"] = true
                    user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        
                    })
                } else {
                    // There was a problem, check error.description
                }
            })
        }
    }
    
    
    /**
    Uploads the preference list
    */
    func uploadDislike(dish: Dish){
        if let user = PFUser.currentUser(){
            let newPreference = PFObject(className:"Disliked")
            newPreference["createdBy"] = PFUser.currentUser()
            newPreference["dishName"] = dish.name
            newPreference["location"] = dish.location
            newPreference.saveInBackgroundWithBlock({
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            })
        }
    }
    
}