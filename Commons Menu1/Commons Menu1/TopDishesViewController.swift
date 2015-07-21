//
//  TopDishesViewController.swift
//  FoodForThought
//
//  Created by Bjorn Ordoubadian on 20/7/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit
import Parse


class TopDishesViewController: UIViewController {

    var dishes: Dishes!
    var topDishes = [Dish]()
    
    @IBOutlet weak var topDishesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the background image
        let bkgdImage = UIImageView()
        bkgdImage.frame = CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height)
        bkgdImage.image = UIImage(named: "DishLevelPagebackground")
        bkgdImage.contentMode = .ScaleAspectFill
        self.view.addSubview(bkgdImage)
        self.view.sendSubviewToBack(bkgdImage)
        println(dishes)
        getPopularDishes()
        
        topDishesTableView.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkDishContains(name: String, location: String) -> (contain: Bool, dish: Dish?) {
        for restProf in dishes.dishes.keys.array {
            if restProf.name == location {
                for dish in dishes.dishes[restProf]! {
                    if dish.name == name {
                        return (true, dish)
                    }
                }
            }
        }
        return (false, nil)
    }
    
    func getPopularDishes() {
        var query = PFQuery(className:"TopDishes")
        query.findObjectsInBackgroundWithBlock { (topdishes:[AnyObject]?, error: NSError?) -> Void in
            if let topdishes = topdishes as? [PFObject] {
                for topdish: PFObject in topdishes {
                    if let restaurant = topdish["location"] as?String{
                        if let dishName = topdish["name"] as? String{
                            let result = self.checkDishContains(dishName, location: restaurant)
                            if !result.contain {
                            self.addDishWithName(restaurant, name: dishName, like: false, dislike: false)
                            
                            }
                            else {
                                self.topDishes.append(result.dish!)
                                
                            }
                        }
                    }
                }
            }
        }
        }
    
    /**
    Add a dish with specific location and name to the dishes object
    */
    func addDishWithName(location: String, name: String, like : Bool, dislike: Bool){
        var query = PFQuery(className:"dishInfo")
        query.whereKey("name", equalTo: name)
        query.getFirstObjectInBackgroundWithBlock{
            (object: PFObject?, error: NSError?) -> Void in
            if let object = object{
                if let name = object["name"] as? String {
                    if let location = object["location"] as? String{
                        if let ingredients = object["ingredients"] as? [String]{
                            if let labels = object["labels"] as? [[String]]{
                                if let type = object["type"] as? String{
                                    if let susLabels = object["susLabels"] as? [String]{
                                        if let index = object["index"] as? Int{
                                            if let eco = object["eco"] as? [String] {
                                                if let fair = object["fair"] as? [String]{
                                                    if let humane = object["humane"] as? [String] {
                                                        if let price = object["price"] as? String{
                                                            if let userImageFile = object["image"] as? PFFile{
                                                                let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels, eco: eco, fair: fair, humane: humane, imageFile: userImageFile)
                                                                dish.like = like
                                                                dish.dislike = dislike
                                                                self.dishes.addDish(location, dish: dish)
                                                                self.dishes.addPulled(index)
                                                                self.topDishes.append(dish)
                                                            } else{
                                                                let dish = Dish(name: name, location: location, type: type, ingredients: ingredients, labels: labels, index : index, price: price, susLabels: susLabels, eco: eco, fair: fair, humane: humane)
                                                                dish.like = like
                                                                dish.dislike = dislike
                                                                self.dishes.addDish(location, dish: dish)
                                                                self.dishes.addPulled(index)
                                                                self.topDishes.append(dish)

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
