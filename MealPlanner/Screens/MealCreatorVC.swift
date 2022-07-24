//
//  MealCreatorVC.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class MealCreatorVC: UIViewController {
    
    let titleLabel              = MPTitleLabel()
    let titleTextField          = MPTextField()
    
    let descriptionLabel        = MPTitleLabel()
    let descriptionTextField    = MPTextField()
    
    let submitButton            = MPButton(backgroundColor: .systemGreen, title: "Submit")
    
    var isTitleEntered: Bool {
        return !titleTextField.text!.isEmpty
    }
    
    let sidePadding: CGFloat        = 20
    let elementPadding: CGFloat     = 10
    let bodyLabelHeight: CGFloat    = 40
    
    var mealToSubmit: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutViews()
        configureSubmitButton()
        createDismissKeyboardTapGesture()
        
        titleLabel.text         = "Title"
    }
    
    init(with importedMeal: Meal?) {
        super.init(nibName: nil, bundle: nil)
        titleTextField.text         = importedMeal?.title ?? ""
//        descriptionTextField.text   = importedMeal?.shortDescription ?? ""
        mealToSubmit                = importedMeal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubmitButton() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc func submitButtonTapped() {
        /// all meals must have a title, check to see if it has been entered
        guard isTitleEntered else {
            presentMPAlertOnMainThread(title: "Empty Title", message: "Please enter a title", buttonTitle: "Ok")
            return
        }
        /// create a meal based on the set parameters
        
        /// if the meal to submit contains data, then update the existing data with stuff from the view.
        if mealToSubmit != nil {
            mealToSubmit?.title             = titleTextField.text!
//            mealToSubmit?.shortDescription  = descriptionTextField.text
        } else { /// otherwise, create a new meal with stuff from the view.
            mealToSubmit = Meal(withTitle: titleTextField.text!/*, shortDescription: descriptionTextField.text*/)
        }
        
        /// save the meal to userdefaults
        PersistenceManager.updateWith(meal: mealToSubmit!, actionType: .add, toList: .allMeals) { [weak self] error in
            guard let self = self else {return}
            guard let error = error else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    /// drop the keyboard when tapping on the view
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func layoutViews() {
        
        view.addSubviews(titleLabel,
                         titleTextField,
//                         descriptionLabel,
//                         descriptionTextField,
                         submitButton)
        
        /// could maybe look at tinyconstraints but meh i think i'd rather make this page with swiftUI instead
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            titleLabel.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: elementPadding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            titleTextField.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
//            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: elementPadding),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
//            descriptionLabel.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
//
//            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: elementPadding),
//            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
//            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
//            descriptionTextField.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
            submitButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 50),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}
