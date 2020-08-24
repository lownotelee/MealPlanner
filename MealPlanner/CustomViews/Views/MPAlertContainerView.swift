//
//  MPAlertContainerView.swift
//  MealPlanner
//
//  Created by Lee on 9/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MPAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius    = 16
        layer.borderWidth     = 2
        layer.borderColor     = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor       = .systemBackground
    }
}
