//
//  MPTitleLabel.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MPTitleLabel: UILabel {

    override init(frame: CGRect) {  // designated initialiser
        super.init(frame: frame)
        configure()
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)     // calls the override init above
        self.textAlignment  = textAlignment
    }
    
    private func configure() {
        textColor                   = .label
        font                        = UIFont.preferredFont(forTextStyle: .title2)     // gives dynamic type
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
