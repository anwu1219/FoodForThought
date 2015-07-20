//
//  IconDescription.swift
//  FoodForThought
//
//  Created by Wu, Andrew on 7/15/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

struct IconDescription{
    let descriptions = [
        "FS":  "This icon indicates that the restaurant prepares meals from scratch. This reduces the purchase and consumption of pre-prepared or processed foods, which can contain many preservatives! \n ",
        "L":  "This icon indicates that the restaurant purchases a variety of food grown within 100 miles of the restaurant. This supports local famers, the local economy, reduces emissions from transportation, and brings fresh food to your area!\n ",
        "SE": "This icon indicates that an ingredient in this dish is in season. Using seasonal ingredients reduces the need to source from non-local sources!  ",
        
        
        "FSD": "This icon indicates that the dish was prepared from scratch. Fresh ingredients mean fresh food! \n ",
        
        
        "AI":  "This icon indicates that the restaurant provides allergen information upon request.  Educated employees provide accurate information to concerned consumers! \n ",
        "CA":  "This icon indicates that the restaurant offers catering services. Catering an event is a great way to connect with other members in your community! \n ",
        "FD":  "This icon indicates that the restaurant frequently donates prepared food to charities, churches, or food banks. In doing so, these restaurants aid in serving the community’s efforts to combat hunger!\n ",
        "MD":  "This icon indicates that the restaurant provides monetary donations to charitable groups in the community. Supporting local charities is a great way to promote social welfare! \n ",
        "VO":  "This icon indicates that the restaurant promotes volunteering opportunities to its employees. Participating in volunteering activities is a great way to support good causes within the community! \n ",
        
        
        "C":  "This icon indicates that the restaurant actively composts food scraps. Composting is a great way to minimize food waste!\n ",
        "LA":  "This icon indicates that the restaurant offers local alcohol options, which promotes the work of local breweries. \n ",
        "R":  "This icon indicates that the restaurant recycles appropriate materials, such as cardboards, plastics, or metals. Recycling is a great way to reduce waste sent to landfills! \n ",
        "LD": "This icon indicates that an Ingredient in this dish comes from a local producer. Local ingredients minimize time from farm to table, which allows restaurants to serve the freshest ingredient to their customers!\n ",
        
        "CE":  "This icon indicates that this ingredient is a good source of carb energy. Carb Energy is the body’s preferred source of fuel and will provide important B vitamins and fiber. \n  ",
        "ES":  "This icon indicates that the restaurant uses Energy Star appliances, which are great for saving energy and money!\n ",
        "HF":  "This icon indicates that this ingredient is a good source of healthy fat. Healthy fats add flavor and satiety to food, are heart healthy, prevent inflammation, aid in the absorption of fat-soluble vitamins and provide energy. \n ",
        "PP":  "This icon indicates that this ingredient is a good source of protein. Proteins form most of the solid material in the body such as hair, muscles, tendons and skin. They also have functional properties for carrying out metabolic processes such as transporting oxygen throughout the body. \n ",
        "VN":  "This icon indicates that this ingredient is rich in nutrients such as essential vitamins and minerals. Nutrient rich foods are important for immune health, energy metabolism and disease prevention.\n ",
        
        
        "Humane": "This humane label is awarded to this restaurant because: \n",
        "Eco": "This Eco label is awarded to this restaurant because: \n",
        "Fair": "This Fair label i awarded to this restaurant because: \n",
        
        
        "COB": "This restaurant uses Canada Organic Biologique Certified ingredients, which reduce the use of artificial agents or fertilizers",
        "CBF": "This restaurant offers Certified Bird Friendly coffee, which preserves bird habits and minimizes erosion",
        "CLS": "This restaurant uses Local Food Plus ingredients in its food, promoting sustainable practices by farmers and other food producers",
        "IFO": "This restaurant uses IFOAM-endorsed standard Certified Organic ingredients. Organic foods can be more eco-friendly than their alternatives",
        "DCB" : "This restaurant uses Demeter Certified Biodynamic ingredients, promoting biodiversity and the use of natural farming practices",
        "EUO" : "This restaurant uses European Union Organic ingredients, which avoid the use of GMO’s",
        "FAC" : "This restaurant uses Food Alliance Certified ingredients. These ingredients contain no artificial preservatives or flavors",
        "MSC" : "This restaurant serves Marine Stewardship Council Blue seafood. These fish are raised in a sustainable way that maintains their ecosystems",
        "MBA": "This restaurant serves Monterey Bay Seafood Watch “Best Choice” seafood, which preserves marine populations",
        "PHC" :  "This restaurant serves Protected Harvest Certified food. These foods are certified for being sustainably grown",
        "RAC" : "This restaurant offers Rainforest Alliance Certified food products, which are recognized for their social and ecological benevolence",
        "USDA" : "This restaurant offers USDA Certified Organic food, which are recognized for their protection of resources and promotion of biodiversity",
        "EFT": "This restaurant serves Ecocert Fair Trade food, recognized for the fair working conditions of the food producers",
        "FFS":  "This restaurant serves Fair Food Standards Council ingredients, promoting fair labor practices and conditions",
        "FL" : "This restaurant serves Fair for Life food, which promotes fair working conditions and sustainable food production practices",
        "FT" : "This restaurant serves Fairtrade certified products, which means flexibility and fair working conditions for the food producers",
        "FW" : "This restaurant serves FairWild Certified products, which preserves species and habitats",
        "FJC" : "This restaurant serves Food Justice Certified food, promoting fair wages and other forms of social justice",
        "SPS" : "This restaurant serves Small Producers’ Symbol food, supporting small, family farms",
        "AGA":  "This restaurant serves AGA Grassfed food products, respecting the natural habits and needs of animals",
        "AHC": "This restaurant serves American Humane Certified food products, promoting animal welfare",
        "AWA": "This restaurant serves Animal Welfare Approved food products, promoting the fair and responsible treatment of animals",
        "CHR" : "This restaurant serves Certified Humane Raised and Handled food products, improving the lives of animals",
        "GAP" : "This restaurant serves Global Animal Partnership Certified food products, expressing a commitment to animal welfare",
        
        "COBD" : "This restaurant uses Canada Organic Biologique Certified ingredients in this dish, which reduce the use of artificial agents or fertilizers",
        
        "CBFD": "This restaurant offers Certified Bird Friendly coffee, which preserves bird habits and minimizes erosion",
        
        "CLSD": "This restaurant uses Local Food Plus ingredients in this dish, promoting sustainable practices by farmers and other food producers",
        
        "IFOD": "This restaurant uses IFOAM-endorsed standard Certified Organic ingredients in this dish. Organic foods can be more eco-friendly than their alternatives",
        
        "DCBD":  "This restaurant uses Demeter Certified Biodynamic ingredients in this dish, promoting biodiversity and the use of natural farming practices",
        
        "EUOD": "This restaurant uses European Union Organic ingredients in this dish, which avoid the use of GMO’s",
        
        "FACD": "This restaurant uses Food Alliance Certified ingredients in this dish. These ingredients contain no artificial preservatives or flavors",
        
        "MSCD": "This restaurant serves Marine Stewardship Council Blue seafood in this dish. These fish are raised in a sustainable way that maintains their ecosystems",
        
        "MBAD": "This restaurant serves Monterey Bay Seafood Watch “Best Choice” seafood in this dish, which preserves marine populations",
        
        "PHCD": "This restaurant serves Protected Harvest Certified ingredients in this dish. These foods are certified for being sustainably grown",
        
        "RACD" : "This restaurant offers Rainforest Alliance Certified food products, which are recognized for their social and ecological benevolence",
        
        "USDAD": "This restaurant offers USDA Certified Organic ingredients in this dish, which are recognized for their protection of resources and promotion of biodiversity",
        
        "EFTD": "This restaurant serves Ecocert Fair Trade ingredients in this dish, recognized for the fair working conditions of the food producers",
        
        "FFSD": "This restaurant serves Fair Food Standards Council ingredients in this dish, promoting fair labor practices and conditions",
        
        "FLD" : "This restaurant serves Fair for Life ingredients in this dish, which promotes fair working conditions and sustainable food production practices",
        
        "FTD" : "This restaurant serves Fairtrade certified ingredients in this dish, which means flexibility and fair working conditions for the food producers",
        
        "FWD" : "This restaurant serves FairWild Certified ingredients in this dish, which preserves species and habitats",
        
        "FJCD" : "This restaurant serves Food Justice Certified ingredients in this dish, promoting fair wages and other forms of social justice",
        
        "SPSD" : "This restaurant serves Small Producers’ Symbol ingredients in this dish, supporting small, family farms",
        
        "AGAD" : "This restaurant serves AGA Grassfed food in this dish, respecting the natural habits and needs of animals",
        
        "AHCD" : "This restaurant serves American Humane Certified food in this dish, promoting animal welfare",
        
        "AWAD" : "This restaurant serves Animal Welfare Approved food in this dish, promoting the fair and responsible treatment of animals",
        
        "CHRD" : "This restaurant serves Certified Humane Raised and Handled food in this dish, improving the lives of animals",
        
        "GAPD" : "This restaurant serves Global Animal Partnership Certified food in this dish, expressing a commitment to animal welfare"
        
    ]
    
    let urls = [
        "FS":  "http://sites.davidson.edu/sustainabilityscholars/",
        "L":  "Thttp://sites.davidson.edu/sustainabilityscholars/",
        "SE": "http://sites.davidson.edu/sustainabilityscholars/",
        
        
        "FSD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        
        "AI":  "http://sites.davidson.edu/sustainabilityscholars/",
        "CA":  "Thttp://sites.davidson.edu/sustainabilityscholars/",
        "FD":  "http://sites.davidson.edu/sustainabilityscholars/",
        "MD":  "http://sites.davidson.edu/sustainabilityscholars/",
        "VO":  "http://sites.davidson.edu/sustainabilityscholars/",
        
        
        "C":  "http://sites.davidson.edu/sustainabilityscholars/",
        "LA":  "http://sites.davidson.edu/sustainabilityscholars/",
        "R":  "http://sites.davidson.edu/sustainabilityscholars/",
        "LD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "CE":  "http://sites.davidson.edu/sustainabilityscholars/",
        "ES":  "http://sites.davidson.edu/sustainabilityscholars/",
        "HF":  "http://sites.davidson.edu/sustainabilityscholars/",
        "PP":  "http://sites.davidson.edu/sustainabilityscholars/",
        "VN":  "http://sites.davidson.edu/sustainabilityscholars/",
        
        
        "Humane": "http://sites.davidson.edu/sustainabilityscholars/",
        "Eco": "http://sites.davidson.edu/sustainabilityscholars/",
        "Fair": "http://sites.davidson.edu/sustainabilityscholars/",
        
        
        "COB": "http://sites.davidson.edu/sustainabilityscholars/",
        "CBF": "http://sites.davidson.edu/sustainabilityscholars/",
        "CLS": "http://sites.davidson.edu/sustainabilityscholars/",
        "IFO": "http://sites.davidson.edu/sustainabilityscholars/",
        "DCB" : "http://sites.davidson.edu/sustainabilityscholars/",
        "EUO" : "http://sites.davidson.edu/sustainabilityscholars/",
        "FAC" : "http://sites.davidson.edu/sustainabilityscholars/",
        "MSC" : "http://sites.davidson.edu/sustainabilityscholars/",
        "MBA": "http://sites.davidson.edu/sustainabilityscholars/",
        "PHC" :  "http://sites.davidson.edu/sustainabilityscholars/",
        "RAC" : "http://sites.davidson.edu/sustainabilityscholars/",
        "USDA" : "http://sites.davidson.edu/sustainabilityscholars/",
        "EFT": "http://sites.davidson.edu/sustainabilityscholars/",
        "FFS":  "http://sites.davidson.edu/sustainabilityscholars/",
        "FL" : "http://sites.davidson.edu/sustainabilityscholars/",
        "FT" : "http://sites.davidson.edu/sustainabilityscholars/",
        "FW" : "http://sites.davidson.edu/sustainabilityscholars/",
        "FJC" : "http://sites.davidson.edu/sustainabilityscholars/",
        "SPS" : "http://sites.davidson.edu/sustainabilityscholars/",
        "AGA":  "http://sites.davidson.edu/sustainabilityscholars/",
        "AHC": "http://sites.davidson.edu/sustainabilityscholars/",
        "AWA": "http://sites.davidson.edu/sustainabilityscholars/",
        "CHR" : "http://sites.davidson.edu/sustainabilityscholars/",
        "GAP" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "COBD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "CBFD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "CLSD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "IFOD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "DCBD":  "http://sites.davidson.edu/sustainabilityscholars/",
        
        "EUOD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "FACD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "MSCD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "MBAD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "PHCD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "RACD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "USDAD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "EFTD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "FFSD": "http://sites.davidson.edu/sustainabilityscholars/",
        
        "FLD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "FTD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "FWD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "FJCD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "SPSD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "AGAD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "AHCD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "AWAD" : "http://sites.davidson.edu/sustainabilityscholars/",
        
        "CHRD" : "Thttp://sites.davidson.edu/sustainabilityscholars/",
        
        "GAPD" : "http://sites.davidson.edu/sustainabilityscholars/"
        
    ]
}