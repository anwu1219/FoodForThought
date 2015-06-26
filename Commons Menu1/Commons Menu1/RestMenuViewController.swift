//
//  RestMenuViewController.swift
//  
//
//  Created by Bjorn Ordoubadian on 17/6/15.
//
//

import UIKit
import Parse

/**
Shows all the resturants with available menus
*/
class RestMenuViewController: UIViewController {
    
    var menuPFObjects = [PFObject]()
    var menu = [Dish]()
    var test = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
    }
    
    func getData() {
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
                                        self.menu.append(Dish(name: name, image: image))
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
        
//                query.getObjectInBackgroundWithId("fl6MKsTbrO") {
//                    (dish: PFObject?, error: NSError?) -> Void in
//                    if error == nil && dish != nil {
//                        if let name = dish?["name"] as? String{
//                                self.test = name
//                            if let userImageFile = dish?["image"] as? PFFile{
//                                userImageFile.getDataInBackgroundWithBlock {
//                                    (imageData: NSData?, error: NSError?) -> Void in
//                                    if error == nil {
//                                        if let data = imageData{
//                                            self.image = UIImage(data: data)
//                                        }
//                                    }
//                                }
//                            }
//                        } else {
//                            println(error)
//                        }
//                    } else {
//                        println(error)
//                    }
//                }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "restToMenuSegue"{
        let menuSwipeViewController = segue.destinationViewController as! MenuSwipeViewController
    //            if let name = test{
    //                menuSwipeViewController.test = name
    //                if let img = image{
    //                    menuSwipeViewController.image = img
    //                }
    //            }
            menuSwipeViewController.menuLoad = menu
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}