//
//  MPTextField.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MPTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius  = 10
        layer.borderWidth   = 2
        layer.borderColor   = UIColor.systemGray4.cgColor
        
        textColor           = .label
        tintColor           = .label
        textAlignment       = .natural
        font                = UIFont.preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth = true
        minimumFontSize     = 12
        
        backgroundColor     = .tertiarySystemBackground
        clearButtonMode     = .whileEditing     // gives a button to clear the text field
        placeholder         = "write some text here"
    }

}
