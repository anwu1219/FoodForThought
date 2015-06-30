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
    
    var menuPFObjects = [PFObject]()
    var menu = [Dish]()
    var restaurants = [String: [Dish]]()
    

    @IBAction func showRestaurants(sender: AnyObject) {
        performSegueWithIdentifier("mainToRestaurantsSegue", sender: sender)
    }
    
    @IBAction func foodTinderAction(sender: AnyObject) {
        performSegueWithIdentifier("foodTinderSegue", sender: sender)
    }
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var sustainabilityInfoButton: UIButton!
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOut()
    }
    
    let styles = Styles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        menuButton.backgroundColor = styles.buttonBackgoundColor
        menuButton.layer.cornerRadius = styles.buttonCornerRadius
        menuButton.layer.borderWidth = 1
        
        self.getData("test")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "foodTinderSegue"{
            let foodTinderViewController = segue.destinationViewController as! FoodTinderViewController
            menu.sort({$0.name<$1.name})
            foodTinderViewController.menuLoad = menu
        }
        if segue.identifier == "mainToRestaurantsSegue" {
            let restMenuViewController = segue.destinationViewController as! RestMenuViewController
            menu.sort({$0.name<$1.name})
            restMenuViewController.menu = menu
            restMenuViewController.restaurants = restaurants
        }
    }
    
    
    
    func getData(name: String) {
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
                                            self.addToRestaurant(location, dish: dish)
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
    
    
    func addToRestaurant(location: String, dish: Dish){
        if !contains(self.restaurants.keys, location){
            restaurants[location] = [Dish]()
        }
        restaurants[location]?.append(dish)
    }
    
}

