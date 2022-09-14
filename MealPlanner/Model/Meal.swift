//
//  Meal.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

struct Meal: Codable, Hashable {
    let identifier: UUID
    
    var title: String           // title of the meal

    //var subTitle: String?       // other bits of the recpie eg pumpkin soup with croutons
    //var avatar: UIImage?        // picture of the meal
    //let sourceURL: String?      // URL where recipe/meal was found
    //var shortDescription: String?   // quick description of the meal
    
    
    struct attributes {
        
//        var vegan: Bool
//        var dairyFree: Bool
//        var fodmapFriendly: Bool
    }
    
    init(withTitle title: String/*, shortDescription: String?*/) {
        identifier = UUID()
        self.title = title
        //self.shortDescription = shortDescription
    }
}
