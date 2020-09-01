//
//  WeekVC.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

class WeekVC: MPDataLoadingVC {
    
    let buttonViewArea = UIView()
    let randomiseButton = MPButton(backgroundColor: .systemBlue, title: "Feed me")
    
    var weekOfMeals: [Meal] = []
    
    let tableView = UITableView()
    
    let noMealsWarning = "\(GeneralConstants.noMeals)\n\(GeneralConstants.useMealsList)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureButtonViewArea()
        configureTableView()
        configureSubmitButton()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.rowHeight     = 70
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(MealsCell.self, forCellReuseIdentifier: MealsCell.reuseID)
        tableView.removeExcessCells()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: buttonViewArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getWeekMeals() {
        PersistenceManager.retrieveMealsList(fromList: .weekMeals, completed: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let weekMealsList):
                self.updateUI(with: weekMealsList)
                
            case .failure(let error):
                self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        })
    }
    
    func updateUI(with meals: [Meal]) {
        if meals.isEmpty {
            self.showEmptyStateView(with: noMealsWarning, in: self.view)
        } else {
            self.weekOfMeals = meals
            DispatchQueue.main.async {
                self.tableView.reloadData()
                /// bring table view to front in case the empty state view was there before
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    func configureViewController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    func configureButtonViewArea() {
        view.addSubviews(buttonViewArea, randomiseButton)
        
        buttonViewArea.translatesAutoresizingMaskIntoConstraints = false
        randomiseButton.translatesAutoresizingMaskIntoConstraints = false
        buttonViewArea.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            buttonViewArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonViewArea.heightAnchor.constraint(equalToConstant: 60),
            
            randomiseButton.centerYAnchor.constraint(equalTo: buttonViewArea.centerYAnchor),
            randomiseButton.centerXAnchor.constraint(equalTo: buttonViewArea.centerXAnchor),
            randomiseButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configureSubmitButton() {
        randomiseButton.addTarget(self, action: #selector(getMealsForWeek), for: .touchUpInside)
    }
    
    func getAllMeals() -> [Meal] {
        var weekMealList: [Meal] = []
        
        PersistenceManager.retrieveMealsList(fromList: .allMeals, completed: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let allMealsList):
                weekMealList = allMealsList
                
            case .failure(let error):
                self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                
            }
        })
        
        return weekMealList
    }
    
    @objc func getMealsForWeek() {
        var weekList: [Meal] = []
        let allMeals = getAllMeals()
        var listOfSevenRandomNumbers = Array(0..<allMeals.count)
        
        listOfSevenRandomNumbers.shuffle()
        if listOfSevenRandomNumbers.count > 7 {
            listOfSevenRandomNumbers.removeSubrange(7...)
        }
        
        for element in listOfSevenRandomNumbers {
            weekList.append(allMeals[element])
        }
        updateUI(with: weekList)
    }
}

extension WeekVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekOfMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealsCell.reuseID) as! MealsCell
        cell.set(meal: weekOfMeals[indexPath.row])
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
        let action = UIContextualAction(style: .normal, title: "Change") { (action, view, nil) in
            print("fucken lol")
            //            self.navigationController?.pushViewController(MealCreatorVC(with: self.meals[indexPath.row]), animated: true)
        }
        action.backgroundColor = UIColor.systemGreen
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            PersistenceManager.updateWith(meal: self.weekOfMeals[indexPath.row], actionType: .remove, toList: .weekMeals) { [weak self] error in
                guard let self  = self else {return}
                guard let error = error else {
                    
                    self.weekOfMeals.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.weekOfMeals.isEmpty {
                        self.showEmptyStateView(with: self.noMealsWarning, in: self.view)
                    }
                    return
                }
                self.presentMPAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = weekOfMeals[indexPath.row]
        let destVC = MealDetailVC(meal: selectedMeal)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
