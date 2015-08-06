//
//  IconInfo.swift
//  FoodForThought
//
//  Created by Wu, Andrew on 7/27/15.
//  Copyright (c) 2015 Davidson College Mobile App Team. All rights reserved.
//

import Foundation

struct IconInfo{
    let descriptions :  [String : [[String: String]]] = [
    "Dish-level Icons": [
        [

        "FSD": "This dish was prepared from scratch.\n ",
        
        "SE": "An ingredient in this dish is in season. Using seasonal ingredients reduces the need to source non-locally, which can be up to thousands of miles away.\n",
            
        "LD": "An ingredient in this dish comes from a local producer, which maximizes freshness and taste.\n "]
        ],
        
        
    "Davidson Nutritionist Icons": [
        [
            "CE":  "This food item is a good source of carb energy. Carbohydrates are the body’s preferred source of fuel and provide important B vitamins and fiber. \n  ",
            "HF":  "This food item is a good source of healthy fat. Healthy fats add flavor and satiety to food, are heart healthy, prevent inflammation, aid in the absorption of fat-soluble vitamins, and provide energy.\n ",
            "PP":  "This food item is a good source of protein. Proteins are the building blocks of most body tissues and carry out metabolic properties, such as transporting oxygen throughout the body.\n ",
            "VN":  "This food item is rich in nutrients such as essential vitamins and minerals. Nutrient-rich foods are important for immune system health, energy metabolism and disease prevention.\n "]
        ],
        
    "Restaurant-level Icons":[
        ["FS":  "This restaurant prepares meals from scratch. This approach to food preparation increases the restaurant's menu flexibility.\n ",
        "L":  "This restaurant provides food options from local farms that are within 250 miles. Local sourcing builds relationships among farmers, restaurant owners, and customers, which creates a sense of community and promotes the local economy.\n ",
        "R":  "This restaurant recycles appropriate materials, such as cardboard, correct plastics, glass, or certain metals. Promoting closed loop recycling saves raw materials for future generations.\n ",
        "ES":  "This restaurant uses Energy Star appliances to reduce energy consumption. \n ",
        
        "LA":  "This restaurant sources alcoholic beverages from local breweries and wineries. This builds relationships between producers, restaurant owners, and customers, which creates a sense of community and supports the local economy.\n ",
        "C":  "This restaurant composts food scraps instead of sending them to landfills. This process supports nutrient cycling and reduces food waste.\n "
        ],
        
        ["AI":  "This restaurant’s staff members are educated on common allergens, and this information is available upon request. \n ",
        "CA":  "This restaurant offers catering services. Beneficial services provided by the restaurant can help build a sense of community and bring people together, which promotes social welfare.\n ",
        "FD":  "This restaurant frequently donates prepared food to charities, churches, or food banks. \n ",
        "MD":  "This restaurant contributes monetary donations to charities, churches, or food banks, providing valuable resources to organizations serving underprivileged communities\n ",
        "VO":  "This restaurant promotes volunteering opportunities to its employees, such as helping run charity events, working at a soup kitchen, or helping at a local farm.\n "
        ]],
        
        
    "Ecologically Sound Icon": [
        ["Eco": "The Ecologically Sound Icon is displayed when either a restaurant or dish use a product that is certified for ecologically sound practices.\n"],
        ["Certified Bird Friendly coffee": "Certified Bird Friendly coffee:  created by the Smithsonian Migratory Bird Center, this certification requires that the coffee is grown organically and under a canopy of native trees. Growing coffee within the canopy of the forest prevents clear cutting, preserves migratory bird habitat, and sequesters carbon. \n",
        "Certified Local Sustainable (Local Food Plus)": "Certified Local Sustainable (Local Food Plus): created by the Land Food People Foundations, this non-profit organization seeks to \"promote sustainable agricultural practices that preserve and protect the environment and enhance human welfare and educate the public on the importance of local sustainable food systems.\" \n",
        "International Federation of Organic Agriculture Movements": "International Federation of Organic Agriculture Movements: a non-profit organization that created a globally accepted standard for organic. Their mission is to promote more than just organic foods, but to also advance health, ecology, fairness, and care.\n",
        "Demeter Certified Biodynamic" : "Demeter Certified Biodynamic:  founded in 1985, this non-profit organization’s motto is to \"heal the planet through agriculture\". \"The certification is a comprehensive organic farming method that requires the creation and management of a closed system minimally dependent on imported materials, and instead meets its needs from the living dynamics of the farm itself.\" \n",
        "European Union Organic" : "European Union Organic: an organic certification the focuses on the entire supply chain in order to ensure that every link along the chain adheres to strict regulations. These regulations aim to ensure environmental protection, food quality, animal welfare and consumer confidence.\n",
        "Food Alliance Certified" : "Food Alliance Certified: since 1998, this non-profit organization has developed comprehensive sustainability standards for the products, producers, and handlers, which include, but not limited to banning GMO’s/artificial flavors/preservatives, safe and fair working conditions, and reducing energy/water consumption.\n",
        "Marine Stewardship Council Blue Ecolabel" : "Marine Stewardship Council Blue Ecolabel: this independent, non-profit organization works with fisheries, scientists, conservation groups and stakeholders to set strict sustainability standards for fisheries. Their eco-label designates that the fish can be traced throughout the entire supply chain and met their criteria throughout the journey.\n",
        "Monterey Bay Seafood Watch \"Best Choice\" Seafood": "Monterey Bay Seafood Watch \"Best Choice\" Seafood: started by Monterey Bay Aquarium, this group created a consumer guide that labels fish species with a red, yellow or green tag that indicates whether or not the species is endangered. When a consumer looks for seafood, this organization recommends purchasing the green flagged species and avoiding the red flags. \n",
        "Protected Harvest Certified" :  "Protected Harvest Certified: this third party organization \"certifies that a producer has met region and crop-specific standards, as approved by its Sustainability Council… Certification covers growers, chain of custody, and licensing of the eco-label trademark in product packaging and point-of-sale promotional materials.\"\n",
        "Rainforest Alliance Certified" : "Rainforest Alliance Certified:  \"The Rainforest Alliance works to conserve biodiversity and improve livelihoods by promoting and evaluating the implementation of the most globally respected sustainability standards in a variety of fields. Through RA-Cert, the Rainforest Alliance's auditing division, we provide our forestry, agriculture and carbon/climate clients with independent and transparent verification, validation and certification services based on these standards, which are designed to generate ecological, social and economic benefits.\" \n",
        "USDA Certified Organic" : "USDA Certified Organic: \"USDA defines specific organic standards that cover the product from farm to table, including soil and water quality, pest control, livestock practices, and rules for food additives.\" Farms undergo annual inspection to ensure continuous adherence to the strict standards.\n"]],
        
    "Fair Icon" : [
        ["Fair": "The Fair Icon is displayed when either a restaurant or dish use a product that is certified for fair practices.\n"],
        ["Ecocert Fair Trade": "Ecocert Fair Trade: approved by Fair Trade, the Ecocert certification promotes the triple bottom line by requiring the \"10 K.O. (knock-out) criteria of the ESR standard\". These include, but are not limited to, “no practices violating human dignity, safe working conditions, and no actions threatening endangered species. \n",
        "Fair Food Standards Council":  "Fair Food Standards Council: currently applies to Floridian tomato workers, this council seeks to advance basic worker human-rights by requiring improvements to worker safety and worker income. This model will eventually be applicable beyond the tomato industry. \n",
        "Fair for Life" : "Fair for Life: applied to numerous industries, such as food and cosmetics, this certification mandates strict social and fair trade practices adapted to each local producer’s community. Transparent reporting increases their credibility.  \n",
        "Fairtrade" : "Fairtrade: a non-profit global organization that works with 1.2 million farmers in over 70 countries to promote sustainable farming, protect worker safety and make sure workers are fairly compensated. \n",
        "FairWild Certified" : "FairWild Certified: founded in 2008, this organization is dedicated to creating a framework for trading that requires application of sustainable wild plant collection, fair business transactions, and positively influences consumer decisions.\n",
        "Food Justice Certified" : "Food Justice Certified: \"a label based on high-bar social justice standards for farms, processors, and retailers… ensuring fair treatment of workers, fair pricing for farmers, and fair business practices.\" To qualify, 95% of the dry ingredient weight must meet FJC standards.\n",
        "Small Producers’ Symbol" : "Small Producers’ Symbol: founded in 2006 by the Latin American and Caribbean Network of Small Fair Trade Producers, this initiative promotes sustainable growing/harvesting practices and fair prices to benefit small communities and the environment.\n"]],
        
    "Humane Icon" : [
        ["Humane": "The Humane Icon is displayed when either a restaurant or dish use a product that is certified for humane practices.\n"],
        ["American Grassfed Association":  "American Grassfed Association: in conjunction with scientists, veterinarians, ranchers and land managers, this association set standards that require animals to be free range, grass-fed diets, no antibiotics/hormones and seeks to promote healthy consumer diets. \n",
        "American Humane Certified": "American Humane Certified: as the first welfare certification program in America, this organization works to ensure humane treatment of farm animals by creating standards that improve animal living conditions. \n",
        "Animal Welfare Approved": "Animal Welfare Approved: “in collaboration with scientists, veterinarians, researchers and farmers across the globe, [this certification works] to maximize practicable, high-welfare farm management with the environment in mind” by setting strict animal welfare standards.\n",
        "Certified Humane Raised and Handled" : "Certified Humane Raised and Handled: \"a national non-profit charity whose mission is to improve the lives of farm animals by providing viable, credible, duly monitored standards for humane food production and assuring consumers that certified products meet these standards.\"\n",
        "Global Animal Partnership" : "Global Animal Partnership: a specific 5–step structure that \"promotes and facilitates continuous improvement in animal agriculture, encourages animal welfare friendly farming practices, and better informs consumers.\" \n"
        ]]
    ]
}