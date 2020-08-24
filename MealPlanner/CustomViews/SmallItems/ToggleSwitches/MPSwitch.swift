//
//  MPSwitch.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MPSwitch: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        HOW TO CHANGE THE COLOR OF THE BUTTON
//        self.thumbTintColor = .systemPink
//        self.onTintColor = .systemTeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
