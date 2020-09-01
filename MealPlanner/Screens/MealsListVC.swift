//
//  ListVC.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//
//  This view will have a list of all the meals entered into the app.
//  I want to have a place to filter all the meals by dietary
//

import UIKit

protocol AddButtonTappedDelegate: class {
    func addButtonTapped()
}

class MealsListVC: MPDataLoadingVC, AddButtonTappedDelegate {
    
    let tableView       = UITableView()
    var meals: [Meal]   = []      // empty array of meals
    
    let noMealsWarning = "\(GeneralConstants.noMeals)\n\(GeneralConstants.useAddButton)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        updateUI(with: meals)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        getMeals()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.rowHeight     = 70
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(MealsCell.self, forCellReuseIdentifier: MealsCell.reuseID)
        tableView.removeExcessCells()
    }
    
    func getMeals() {
        PersistenceManager.retrieveMealsList(fromList: .allMeals, completed: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let mealsList):
                self.updateUI(with: mealsList)
                
            case .failure(let error):
                self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        })
    }
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "Meals"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    func updateUI(with meals: [Meal]) {
        if meals.isEmpty {
            self.showEmptyStateView(with: noMealsWarning, in: self.view)
        } else {
            self.meals = meals
            DispatchQueue.main.async {
                self.tableView.reloadData()
                // bring table view to front in case the empty state view was there before
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    @objc func addButtonTapped() {
        navigationController?.pushViewController(MealCreatorVC(with: nil), animated: true)   // TODO: Figure out how to transition to a SwiftUI view
    }
}

extension MealsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealsCell.reuseID) as! MealsCell
        cell.set(meal: meals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            self.navigationController?.pushViewController(MealCreatorVC(with: self.meals[indexPath.row]), animated: true)
        }
        action.backgroundColor = UIColor.systemBlue
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            PersistenceManager.updateWith(meal: self.meals[indexPath.row], actionType: .remove, toList: .allMeals) { [weak self] error in
                guard let self  = self else {return}
                guard let error = error else {

                    self.meals.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.meals.isEmpty {
                        self.showEmptyStateView(with: self.noMealsWarning, in: self.view)
                    }
                    return
                }
                self.presentMPAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        action.backgroundColor = UIColor.systemRed
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = meals[indexPath.row]
        let destVC = MealDetailVC(meal: selectedMeal)

        navigationController?.pushViewController(destVC, animated: true)
    }
}
