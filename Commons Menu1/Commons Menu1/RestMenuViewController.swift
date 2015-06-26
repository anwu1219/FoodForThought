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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var horizonScroll: UIScrollView!
    
    //let viewContainer = UIView()
    var styles = Styles()
    var menuPFObjects = [PFObject]()
    var menu = [Dish]()
    var test = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData("test")
        horizonScroll.contentSize.width = 1000
        horizonScroll.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.75)
        //horizonScroll.addSubview(viewContainer)
        placeButtons(5)
        
    }
    
    func placeButtons(numButtons: Int) {
        for i in 0..<numButtons {
            var button = UIButton()
            var leftAlign: CGFloat = 10
            var width: CGFloat = 0.2 * horizonScroll.bounds.width
            var height: CGFloat = 0.3 * horizonScroll.bounds.height
            var x: CGFloat = (width+10) * CGFloat(i)
            var y: CGFloat = (0 - (0.5 * height))
            button.frame = CGRectMake(leftAlign + x, y, width, height)
            button.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.75, alpha: 0.95)
            button.setTitle("Touch Me" + String(i), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "toMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var image = UIImageView(image: UIImage(named: "heartHands"))
            image.frame = CGRectMake(leftAlign + x, (y+height+5), width, width)
            
            horizonScroll.addSubview(button)
            horizonScroll.addSubview(image)
        }
    }
    
    func toMenu(sender: UIButton!) {
        // use get data function to get the menu for the selected restaurant
        // call performSegueWithIdentifier to menuSwipeViewController 
        //self.getData(sender.titleLabel!.text!)
        println(sender.titleLabel!.text!)
        performSegueWithIdentifier("restToMenuSegue", sender: sender)
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
        
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "restToMenuSegue"{
        let menuSwipeViewController = segue.destinationViewController as! MenuSwipeViewController
            menu.sort({$0.name<$1.name})
            menuSwipeViewController.menuLoad = menu
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}