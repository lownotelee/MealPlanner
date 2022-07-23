//
//  MealDetailVC.swift
//  MealPlanner
//
//  Created by Lee on 9/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

// appears when a user taps a meal in the list

import UIKit

class MealDetailVC: UIViewController {
    
    var descriptionLabel = MPBodyLabel()
    
    var padding: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        //addDescriptionLabel()
        
    }
    /*
    func addDescriptionLabel() {
        view.addSubviews(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }*/
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemTeal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    init(meal: Meal) {
        super.init(nibName: nil, bundle: nil)
        title           = meal.title
        //descriptionLabel.text = meal.shortDescription ?? "no description"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
