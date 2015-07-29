//
//  SignUpViewController.swift
//  Commons Menu1
//
//  Created by Anstrom, Kaity on 6/29/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Parse
import UIKit


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var dishes = Dishes()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(-130.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "SignInBackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        
        // - Style of the textfield, button, and label
        func textFieldStyle(textField : UITextField){
            textField.layer.masksToBounds = false
            textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
            textField.layer.shadowColor = UIColor.blackColor().CGColor
            textField.layer.shadowOpacity = 0.5
            textField.layer.shadowRadius = 4.0
            textField.layer.shadowOffset = CGSizeMake(5.0, 5.0)
            textField.delegate = self
        }
        
        textFieldStyle(emailAddress)
        textFieldStyle(password)
        
        
        func buttonStyle(button: UIButton){
            button.layer.shadowColor = UIColor.blackColor().CGColor
            button.layer.shadowOffset = CGSizeMake(5, 5)
            button.layer.shadowRadius = 2
            button.layer.shadowOpacity = 1.0
        }
        
        buttonStyle(signUpButton)
        buttonStyle(signInButton)
        
        
        func labelStyle(label : UILabel){
            label.layer.shadowColor = UIColor.blackColor().CGColor
            label.layer.shadowOffset = CGSizeMake(5, 5)
            label.layer.shadowRadius = 5
            label.layer.shadowOpacity = 1.0
        }
        
        labelStyle(welcomeLabel)
        labelStyle(passwordLabel)
        labelStyle(emailLabel)

        
        //keyboard listener
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) { // 1
            self.getRestaurant()
            for restaurant : RestProfile in self.dishes.dishes.keys {
                self.dishes.dishes[restaurant]?.removeAll(keepCapacity: false)
            } //needs update to cache
            self.dishes.date = self.getDate()
        }
        
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)) {
            let isReachable = Reachability.isConnectedToNetwork()
            dispatch_async(dispatch_get_main_queue()) {
                if !isReachable {
                    self.noInternetAlert("")
                }
            }
        }
    }
    
    
    //functions that raise the view when keyboard is shown, so that the password field is not hidden underneath
    //the keyboard. From http://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
    func keyboardWillShow(sender: NSNotification) {
        let screenHeight = screenSize.height
        if self.view.frame.origin.y > -0.4 * screenHeight {
            self.view.frame.origin.y -= 0.25 * screenHeight
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBarHidden = false
        }
        super.viewWillDisappear(animated)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    // -: Process sign up and sign in
    func cancelSignUp() -> Bool {
        // cancels signup, needs stop segue to next menu
        self.activityIndicator.stopAnimating()
        return true
    }
    
    
    //Check the password's length
    func checkPasswordLengthShort(password: String) -> Bool {
        if count(password) >= 6 && count(password) <= 20{
            return true
        }
        else {
            return false
        }
    }
    
    
    func processSignUp() {
        var userEmailAddress = emailAddress.text
        var userPassword = password.text
      
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString
        
        // Add email address validation
        if isValidEmail(userEmailAddress) == false {
            println("The email you entered is not valid")
        }
        
        
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
                //performs automatic segue to main menu
                self.performSegueWithIdentifier("instructionSegue", sender: nil)

            } else {
                println(error)
                
                let signUpFailed = UIAlertView(title: "Sign Up Error", message: "Email Already Exists", delegate: nil, cancelButtonTitle: "OK")
                // shows alert to user
                signUpFailed.show()

               self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
    
    
    //from http://blog.bizzi-body.com/2015/02/10/ios-swift-1-2-parse-com-tutorial-users-sign-up-sign-in-and-securing-data-part-3-or-3/
    @IBAction func signUp(sender: AnyObject) {
        // Build the terms and conditions alert
        if isValidEmail(emailAddress.text) == true {
            //ensure password is longer than 6 characters and is shorter than 20 characters
            if checkPasswordLengthShort(password.text) == true {
                let alertController = UIAlertController(title: "Agree to terms and conditions",
                    message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alertController.addAction(UIAlertAction(title: "I AGREE",
                    style: UIAlertActionStyle.Default,
                    handler: { alertController in self.processSignUp()}
                    )
                )
                alertController.addAction(UIAlertAction(title: "I do NOT agree",
                    style: UIAlertActionStyle.Default,
                    //handler: nil
                    handler: { alertController in self.cancelSignUp() }
                    )
                )
                
                // Display alert
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                let passwordLengthNotPermitted = UIAlertView(title: "Password Length Error", message: "Password must be between 6 and 20 characters", delegate: nil, cancelButtonTitle: "OK")
                // shows alert to user
                passwordLengthNotPermitted.show()
            }
        }
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
                if let tinderViewed = PFUser.currentUser()!["tinderViewed"] as? Bool {
                    if let menuViewed = PFUser.currentUser()!["menuViewed"] as? Bool {
                        self.dishes.learned["tinder"] = tinderViewed
                        self.dishes.learned["menuSwipe"] = menuViewed
                        println("Logged in successfully")
                }
            }
            
                // Cache the user name
                PFUser.currentUser()?.pinInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        println("Successfully cached user name")
                    } else {
                        // There was a problem, check error.description
                        println("Failed to cache user name")
                    }
                })
                
                self.performSegueWithIdentifier("signInToNavigationSegue", sender: self)
                } else {
                println(error)
                let notPermitted = UIAlertView(title: "Alert", message: "Username or password is not valid.", delegate: nil, cancelButtonTitle: "OK")
                self.activityIndicator.stopAnimating()
                // shows alert to user
                notPermitted.show()
                self.password.text == ""
            }
        }
    }

    
    //button action to reset forgotten password
    //found at http://stackoverflow.com/questions/28610031/parse-password-reset-function
    @IBAction func resetPasswordPressed(sender: AnyObject) {
        let titlePrompt = UIAlertController(title: "Reset password",
            message: "Enter the email you registered with:",
            preferredStyle: .Alert)
        
        var titleTextField: UITextField?
        titlePrompt.addTextFieldWithConfigurationHandler { (textField) -> Void in
            titleTextField = textField
            textField.placeholder = "Email"
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        titlePrompt.addAction(cancelAction)
        
        titlePrompt.addAction(UIAlertAction(title: "Reset", style: .Destructive, handler: { (action) -> Void in
            if let textField = titleTextField {
                self.resetPassword(textField.text)
            }
        }))
        
        self.presentViewController(titlePrompt, animated: true, completion: nil)
    }
    
    
    func clearTextField(){
        emailAddress.text = ""
        password.text = ""
        
    }
    
    
    //regex function to check if email is in valid format
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    func getRestaurant() {
        var query = PFQuery(className:"Restaurant")
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil{
                if let objectsArray = objects{
                    for object: AnyObject in objectsArray{
                        let restaurant = object as! RestProfile
                        restaurant.name = object["name"] as! String
                        restaurant.imageFile = object["image"] as! PFFile
                        restaurant.address = object["address"] as! String
                        restaurant.phoneNumber = object["number"] as! String
                        restaurant.hours = object["hours"] as! [String]
                        restaurant.restDescript = object["restDescription"] as! String
                        restaurant.labels = object["labelDescription"] as! [[String]]
                        restaurant.healthScore = object["healthScore"] as! Double
                        restaurant.mealPlanHours = object["mealPlanHours"] as! [String]
                        restaurant.url = object["website"] as! String
                        restaurant.eco = object["eco"] as! [String]
                        restaurant.fair = object["fair"] as! [String]
                        restaurant.humane = object["humane"] as! [String]
                        restaurant.dynamicTypes = object["dynamic"] as! [String]
                        self.dishes.addRestaurant(restaurant)
                    }
                    if let user = PFUser.currentUser() {
                        self.emailAddress.text = user.username
                        self.password.text = user.password
                        println("Logged in successfully")
                        self.performSegueWithIdentifier("signInToNavigationSegue", sender: self)
                    }
                }
            }
        }
    }
    
 
    //Parse function to reset forgotten password
    func resetPassword(email : String){
        
        // convert the email string to lower case
        let emailToLowerCase = email.lowercaseString
        // remove any whitespaces before and after the email address
        let emailClean = emailToLowerCase.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        PFUser.requestPasswordResetForEmailInBackground(emailClean) { (success, error) -> Void in
            if (error == nil) {
                let success = UIAlertController(title: "Success", message: "Success! Check your email!", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                success.addAction(okButton)
                self.presentViewController(success, animated: false, completion: nil)
                
            }else {
                let errormessage = error!.userInfo!["error"] as! NSString
                let error = UIAlertController(title: "Cannot complete request", message: errormessage as String, preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                error.addAction(okButton)
                self.presentViewController(error, animated: false, completion: nil)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //from http://stackoverflow.com/questions/9407571/to-stop-segue-and-show-alert
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "signInToNavigationSegue" {
            var segueShouldOccur = true
            var segueShouldOccurEULA = true
            
            if isValidEmail(emailAddress.text) == false {
                // perform your computation to determine whether segue should occur
                segueShouldOccur = false
            }
            
            if cancelSignUp() == true {
                segueShouldOccurEULA = false
            }
            
            if !segueShouldOccur {
                let notPermitted = UIAlertView(title: "Alert", message: "Email is not valid.", delegate: nil, cancelButtonTitle: "OK")
                
                // shows alert to user
                notPermitted.show()
                
                // prevent segue from occurring
                return false
            }
            
            if !segueShouldOccurEULA {
                // prevent segue from occurring
                return false
            }
        }
        // by default perform the segue transition
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signInToNavigationSegue" {
            let mainMenuViewController = segue.destinationViewController as! MainMenuViewController
            println("Hello \(PFUser.currentUser())")
            mainMenuViewController.dishes = dishes
        }
        if segue.identifier == "instructionSegue" {
            let instructionViewController = segue.destinationViewController as! InstructionViewController
            instructionViewController.dishes = dishes
        }
    }
}
