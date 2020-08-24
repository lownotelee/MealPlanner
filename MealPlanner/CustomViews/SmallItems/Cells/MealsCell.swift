//
//  MealsCell.swift
//  MealPlanner
//
//  Created by Lee on 9/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MealsCell: UITableViewCell {
    
    static let reuseID  = "MealCell"
    let mealLabel       = MPTitleLabel(textAlignment: .natural, fontSize: 20)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func set(meal: Meal) {
        mealLabel.text = meal.title
    }

    private func configure() {
        addSubviews(mealLabel)
        
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            mealLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            mealLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            mealLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
