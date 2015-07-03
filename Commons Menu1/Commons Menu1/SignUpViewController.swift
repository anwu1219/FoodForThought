//
//  SignUpViewController.swift
//  Commons Menu1
//
//  Created by Anstrom, Kaity on 6/29/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Parse
import UIKit

protocol SignUpViewControllerDelegate {
    func clearTextField()
}

class SignUpViewController: UIViewController, UITextFieldDelegate, SignUpViewControllerDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBAction func signUp(sender: AnyObject) {
        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func processSignUp() {
        
        var userEmailAddress = emailAddress.text
        var userPassword = password.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                println("Signed up successfully")
                self.performSegueWithIdentifier("signInToNavigationSegue", sender: self)
                
            } else {
                println(error)
//                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userEmailAddress = emailAddress.text
        userEmailAddress = userEmailAddress.lowercaseString
        
        var userPassword = password.text
        PFUser.logInWithUsernameInBackground(userEmailAddress, password: userPassword){
            (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                println("Logged in successfully")
                } else {
                println(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "wheat")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        emailAddress.layer.masksToBounds = false
        emailAddress.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        emailAddress.layer.shadowColor = UIColor.blackColor().CGColor
        emailAddress.layer.shadowOpacity = 0.3
        emailAddress.layer.shadowRadius = 5.0
        emailAddress.layer.shadowOffset = CGSizeMake(5.0, 5.0)
        
        password.layer.masksToBounds = false
        password.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        password.layer.shadowColor = UIColor.blackColor().CGColor
        password.layer.shadowOpacity = 0.3
        password.layer.shadowRadius = 5.0
        password.layer.shadowOffset = CGSizeMake(5.0, 5.0)
        
        self.emailAddress.delegate = self
        self.password.delegate = self
        
    }
    
    
    func clearTextField(){
        emailAddress.text = ""
        password.text = ""
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signInToNavigationSegue" {
            let mainMenuViewController = segue.destinationViewController as! MainMenuViewController
            mainMenuViewController.signUpViewControllerDelegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
