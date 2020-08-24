//
//  UITableView+Ext.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

extension UITableView {
    
    // This function tends to get called a fair bit in other code
    // so it kinda makes sense to make it an extension function
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    // removes the horizontal lines for empty elements of a UITableView
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
