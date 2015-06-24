//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eMailTextField.delegate = self
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        let user = PFUser()
        user.username = userNameTextField.text
        user.password = passwordTextField.text
        user.email = eMailTextField.text
        
        
        user.signUpInBackgroundWithBlock {(succeeded, error) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
            } else {
                // Examine the error object and inform the user.
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}