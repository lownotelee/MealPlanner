//
//  MealsCell.swift
//  MealPlanner
//
//  Created by Lee on 9/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit
import Metal
import MetalKit

class MealsCell: UITableViewCell {
    
    // Metal resources; used for blur effect
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var sourceTexture: MTLTexture!
    
    static let reuseID  = "MealCell"
    let mealLabel       = MPTitleLabel(textAlignment: .natural, fontSize: 20)
    var mealImageView   = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    func set(meal: Meal) {
        mealLabel.text = meal.title
    }

    private func configure() {
        addSubview(mealImageView)
        addSubviews(mealLabel)
        
        configureImageView()
        
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 12
        
        NSLayoutConstraint.activate([
            mealLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: mealImageView.leadingAnchor, constant: padding),
            mealLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            mealLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureImageView() {
        mealImageView.clipsToBounds         = true
        mealImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        mealImageView.image = Images.cellDefaultBackgroundImage
        
        mealImageView.translatesAutoresizingMaskIntoConstraints                                 = false
        mealImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                 = true
        mealImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                 = true
        mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive    = true
        mealImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive            = true
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
