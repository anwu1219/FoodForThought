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
                self.fetchPreferenceData()
                self.fetchDisLikesData()
                println("Logged in successfully")
                self.performSegueWithIdentifier("signInToNavigationSegue", sender: self)
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
        self.getDishes()
        self.getRestaurant()
    }
    
    
    func clearTextField(){
        emailAddress.text = ""
        password.text = ""
        
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
                                                            let restaurant =    RestProfile(name: name, image: image, restDescript: susDescript, address: address, hours: hours, phoneNumber: phoneNumber, label: label)
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
    
}
