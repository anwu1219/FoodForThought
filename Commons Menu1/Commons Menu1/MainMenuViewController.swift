//
//  MainMenuViewController.swift
//  Commons Menu1
//
//  Created by Bjorn Ordoubadian on 16/6/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse

/**
Welcome page view controller and search type for user
*/
class MainMenuViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var sustainabilityInfoButton: UIButton!
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOut()
        self.signInPopUp()
    }
    
    let styles = Styles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInPopUp()
        
        menuButton.backgroundColor = styles.buttonBackgoundColor
        menuButton.layer.cornerRadius = styles.buttonCornerRadius
        menuButton.layer.borderWidth = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signInPopUp() {
        if PFUser.currentUser() == nil{
            var loginAlert:UIAlertController = UIAlertController(title: "Sign Up / Login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your password"
                textfield.secureTextEntry = true
            })
            
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as! NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as! UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as! UITextField
                
                if let usernameTextField = textFields.objectAtIndex(0) as? UITextField{
                    if let passwordTextField = textFields.objectAtIndex(1) as? UITextField{
                        if let user = usernameTextField.text{
                            if let password = passwordTextField.text{
                                PFUser.logInWithUsername(user, password: password)
                            }
                        }
                    }
                }
                
                
            }))
            
            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as! NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as! UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as! UITextField
                
                var user:PFUser = PFUser()
                user.username = usernameTextfield.text.lowercaseString
                user.password = passwordTextfield.text
                
                user.signUpInBackgroundWithBlock{
                    (success: Bool, error:NSError?)->Void in
                    if error == nil{
                        println("Sign Up successful.")
                    }else{
                        let errorString = error!.localizedDescription
                        println(errorString)
                    }
                }
            }))
            
            self.presentViewController(loginAlert, animated: true, completion: nil)
        } else {
            println("logged in")
        }
    }
}

