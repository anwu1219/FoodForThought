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
    
    var menuPFObjects = [PFObject]()
    var menu = [Dish]()
    var test = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
        horizonScroll.contentSize.width = 1000
        horizonScroll.backgroundColor = UIColor.redColor()
        //horizonScroll.addSubview(viewContainer)
        placeButtons(5)
        
    }
    
    func placeButtons(numButtons: Int) {
        for i in 0..<numButtons {
            var button = UIButton()
            var width: CGFloat = 140
            var height: CGFloat = 50
            var x: CGFloat = (width+10) * CGFloat(i)
            var y: CGFloat = 0
            button.frame = CGRectMake(x, y, width, height)
            button.backgroundColor = UIColor.blackColor()
            button.setTitle("Touch Me", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            
            
            var image = UIImageView(image: UIImage(named: "davidsonLogo"))
            image.frame = CGRectMake(x, (y+height+5), width, width)
            
            horizonScroll.addSubview(button)
            horizonScroll.addSubview(image)
        }
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


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "restToMenuSegue"{
        let menuSwipeViewController = segue.destinationViewController as! MenuSwipeViewController
            menuSwipeViewController.menuLoad = menu
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}