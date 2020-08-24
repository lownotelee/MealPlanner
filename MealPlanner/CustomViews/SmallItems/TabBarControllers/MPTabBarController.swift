//
//  MPTabBarController.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MPTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemIndigo
        
        viewControllers = [createWeekNC(), createMealsListNC()]
    }
    
    func createWeekNC() -> UINavigationController {
        let weekVC = WeekVC()
        weekVC.title = "Week"
        weekVC.tabBarItem = UITabBarItem(title: "Week", image: SFSymbols.calendar, tag: 0)
        return UINavigationController(rootViewController: weekVC)
    }
    
    func createMealsListNC() -> UINavigationController {
        let mealsListVC = MealsListVC()
        mealsListVC.title = "Meals"
        mealsListVC.tabBarItem = UITabBarItem(title: "Meals", image: SFSymbols.list, tag: 1)
        return UINavigationController(rootViewController: mealsListVC)
    }
}
