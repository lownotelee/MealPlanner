//
//  UIView+Ext.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//
//  Taken from Sean Allen tutorials
//  Allows many views to be added to a subview in one line
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
