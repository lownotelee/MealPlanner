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
    
    let vegetarianLabel         = MPBodyLabel()
    let vegetarianToggle        = MPSwitch()
    
    let glutenLabel             = MPBodyLabel()
    let glutenToggle            = MPSwitch()
    
    let hstackview1             = UIStackView()
    let hstackview2             = UIStackView()
    
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
        setUpHStacks()
        layoutViews()
        configureSubmitButton()
        createDismissKeyboardTapGesture()
        
        titleLabel.text         = "Title"
        descriptionLabel.text   = "Description"
        vegetarianLabel.text    = "Vegetarian?"
        glutenLabel.text        = "Gluten Free?"
    }
    
    init(with importedMeal: Meal?) {
        super.init(nibName: nil, bundle: nil)
        titleTextField.text         = importedMeal?.title ?? ""
        descriptionTextField.text   = importedMeal?.shortDescription ?? ""
        glutenToggle.isOn           = importedMeal?.glutenFree ?? false
        vegetarianToggle.isOn       = importedMeal?.vegetarian ?? false
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
            mealToSubmit?.shortDescription  = descriptionTextField.text
            mealToSubmit?.vegetarian        = vegetarianToggle.isOn
            mealToSubmit?.glutenFree        = glutenToggle.isOn
        } else { /// otherwise, create a new meal with stuff from the view.
            mealToSubmit = Meal(withTitle: titleTextField.text!, shortDescription: descriptionTextField.text, isVegetarian: vegetarianToggle.isOn, isGlutenFree: glutenToggle.isOn)
        }
        
        /// save the meal to userdefaults
        PersistenceManager.updateWith(meal: mealToSubmit!, actionType: .add) { [weak self] error in
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
    
    /// horizontal stacks that contain dietary toggles
    func setUpHStacks() {
        hstackview1.alignment = .trailing
        hstackview1.axis = .horizontal
        hstackview1.addArrangedSubview(vegetarianLabel)
        hstackview1.addArrangedSubview(vegetarianToggle)
        hstackview1.distribution = .equalCentering
        hstackview1.translatesAutoresizingMaskIntoConstraints = false
        
        hstackview2.alignment = .trailing
        hstackview2.axis = .horizontal
        hstackview2.addArrangedSubview(glutenLabel)
        hstackview2.addArrangedSubview(glutenToggle)
        hstackview2.distribution = .equalCentering
        hstackview2.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layoutViews() {
        
        view.addSubviews(titleLabel,
                         titleTextField,
                         descriptionLabel,
                         descriptionTextField,
                         hstackview1,
                         hstackview2,
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
            
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: elementPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            descriptionLabel.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: elementPadding),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            descriptionTextField.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
            hstackview1.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: elementPadding),
            hstackview1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            hstackview1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            hstackview1.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
            hstackview2.topAnchor.constraint(equalTo: hstackview1.bottomAnchor, constant: elementPadding),
            hstackview2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            hstackview2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            hstackview2.heightAnchor.constraint(equalToConstant: bodyLabelHeight),
            
            submitButton.topAnchor.constraint(equalTo: hstackview2.bottomAnchor, constant: 50),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
}
