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
    
    var menuPFObjects = [PFObject]()
    var menu = [Dish]()
    var restaurants = [String: [Dish]]()
    var preferences = [String: [String]]()
    var dislikes = [String: [String]]()
    var restauranto = [RestProfile]()

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
        self.getDishes()
        self.getRestaurant()
        if let user = PFUser.currentUser() {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1))
            dispatch_after(delayTime, dispatch_get_main_queue()){
                self.emailAddress.text = user.username
                self.password.text = user.password
                self.fetchPreferenceData()
                self.fetchDisLikesData()
                println("Logged in successfully")
                self.performSegueWithIdentifier("signInToNavigationSegue", sender: self)
            }
        }
    }
    
    
    //from http://blog.bizzi-body.com/2015/02/10/ios-swift-1-2-parse-com-tutorial-users-sign-up-sign-in-and-securing-data-part-3-or-3/
    @IBAction func signUp(sender: AnyObject) {
        // Build the terms and conditions alert
        if isValidEmail(emailAddress.text) == true {
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
            handler: nil
            )
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)
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
            } else {
                println(error)
               self.activityIndicator.stopAnimating()
            }
        }
      
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //from http://stackoverflow.com/questions/9407571/to-stop-segue-and-show-alert
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "signInToNavigationSegue" {
             var segueShouldOccur = true // you determine this
            if isValidEmail(emailAddress.text) == false {
            // perform your computation to determine whether segue should occur
                segueShouldOccur = false
            }
           
            if !segueShouldOccur {
                let notPermitted = UIAlertView(title: "Alert", message: "Email is not valid.", delegate: nil, cancelButtonTitle: "OK")
                
                // shows alert to user
                notPermitted.show()
                
                // prevent segue from occurring
                return false
            }
        }
        
        // by default perform the segue transition
        return true
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
                self.fetchPreferenceData()
                self.fetchDisLikesData()
                println("Logged in successfully")
                
                // Cache the user name
                PFUser.currentUser()?.pinInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                })
                
                self.performSegueWithIdentifier("signInToNavigationSegue", sender: self)
                } else {
                println(error)
                let notPermitted = UIAlertView(title: "Alert", message: "Username or password is not valid.", delegate: nil, cancelButtonTitle: "OK")
                // shows alert to user
                notPermitted.show()
                self.password.text == ""

            }
        }
    }

    
    func clearTextField(){
        emailAddress.text = ""
        password.text = ""
        
    }
    
    
    func getDishes() {
        var query = PFQuery(className:"dishInfo")
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil{
                if let objectsArray = objects{
                    for object: AnyObject in objectsArray{
                        self.menuPFObjects.append(object as! PFObject)
                        if let name = object["name"] as? String {
                            if let userImageFile = object["image"] as? PFFile{
                                userImageFile.getDataInBackgroundWithBlock {
                                    (imageData: NSData?, error: NSError?) ->Void in
                                    if error == nil {                               if let data = imageData{                                                if let image = UIImage(data: data){
                                        if let location = object["location"] as? String{
                                            let dish = Dish(name: name, image: image, location: location)
                                            self.menu.append(dish)
                                            self.addToRestaurants(location, dish: dish)
                                        }
                                        }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addToRestaurants(location: String, dish: Dish){
        if !contains(self.restaurants.keys, location){
            restaurants[location] = [Dish]()
        }
        restaurants[location]?.append(dish)
    }
    
    //regex function to check if email is in valid format
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
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
                        self.menuPFObjects.append(object as! PFObject)
                        if let name = object["name"] as? String {
                            if let userImageFile = object["image"] as? PFFile{
                                userImageFile.getDataInBackgroundWithBlock {
                                    (imageData: NSData?, error: NSError?) ->Void in
                                    if error == nil {                               if let data = imageData{                                                if let image = UIImage(data: data){
                                        if let address = object["address"] as? String{
                                            if let phoneNumber = object["number"] as? String{
                                            if let  hours = object["openHours"] as? String{
                                                if let restDescript = object["restDescription"] as? String{
                                                    if let susDescript = object["susDescription"] as? [String]{
                                                        if let label = object["labelDescription"] as? [[String]]{
                                                            let restaurant =    RestProfile(name: name, image: image, restDescript: susDescript, address: address, weekdayHours: hours, weekendHours: hours, phoneNumber: phoneNumber, label: label)
                                                            self.addToRestauranto(restaurant)
                                                        }
                                                    }
                                                }
                                                }
                                            }
                                        }
                                        }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func addToRestauranto(restaurant: RestProfile){
        restauranto.append(restaurant)
    }
    
    
    func fetchPreferenceData(){
        if let currentUser = PFUser.currentUser(){
            var user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            var query = PFQuery(className:"Preference")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                if let restaurant = pFObject["location"] as?String{
                                    if let dishName = pFObject["dishName"] as? String{
                                        self.addToPreferences(restaurant, dishName: dishName)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func addToPreferences(restaurant: String, dishName: String){
        if !contains(preferences.keys, restaurant){
            preferences[restaurant] = [String]()
        }
        preferences[restaurant]?.append(dishName)
    }
    
    
    func fetchDisLikesData(){
        if let currentUser = PFUser.currentUser(){
            var user = PFObject(withoutDataWithClassName: "_User", objectId: currentUser.objectId)
            var query = PFQuery(className:"Disliked")
            query.whereKey("createdBy", equalTo: user)
            query.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil{
                    if let objectsArray = objects{
                        for object: AnyObject in objectsArray{
                            if let pFObject: PFObject = object as? PFObject{
                                if let restaurant = pFObject["location"] as?String{
                                    if let dishName = pFObject["dishName"] as? String{
                                        self.addToDislikes(restaurant, dishName: dishName)
                                    }
                                }
                            }
                        }
                    }
                }
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
    
    
    func addToDislikes(restaurant: String, dishName: String){
        if !contains(dislikes.keys, restaurant){
            dislikes[restaurant] = [String]()
        }
        dislikes[restaurant]?.append(dishName)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signInToNavigationSegue" {
            let mainMenuViewController = segue.destinationViewController as! MainMenuViewController
            mainMenuViewController.signUpViewControllerDelegate = self
            mainMenuViewController.menu = menu
            mainMenuViewController.restaurants = restaurants
            mainMenuViewController.preferences = preferences
            mainMenuViewController.dislikes = dislikes
            mainMenuViewController.restauranto = restauranto
        }
    }
}
