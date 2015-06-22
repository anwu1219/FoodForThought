//
//  MenuInfoViewController.swift
//  Commons Menu1
//
//  Created by Chadinha, Spencer on 6/22/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import UIKit

class MealInfoViewController: UIViewController {
    
    var dish: Dish?
    
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var ecoLabel: UILabel!
    
    @IBOutlet weak var ingredientsList: UILabel!
    
    @IBOutlet weak var alergenInfo: UILabel!
    
    //@IBOutlet weak var dishName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ecoLabel.text = dish!.name
        //        dishImage = dish!.image
        //        ecoLabel = dish!.ecoLabel
        //        ingredientsList = dish!.ingredients
        //        alergenInfo = dish!.alergens
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}