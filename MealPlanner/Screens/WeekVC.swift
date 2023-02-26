//
//  WeekVC.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//

/// NOTES
/// So I fixed the inital bug that the list wasnt appearing when the view was loaded
/// But now the list changes whenever the view appears again
/// It looks like I'm not actually saving the list anywhere, so I need to use the persistenceManager
/// stuff from MealCreatorVC to save it to userdefaults and then grab it again when the view appears
///


import UIKit

class WeekVC: MPDataLoadingVC {
    
    let buttonViewArea = UIView()
    let randomiseButton = MPButton(backgroundColor: .systemBlue, title: "Feed me")
    
    var weekOfMealIDs: [UUID] = []      /// list of UUIDs of meals for the week. This is the one that's stored
    var weekOfMealObjects: [Meal] = []  /// list of meals built by associating meals from the list of UUIDs
    
    let tableView = UITableView()
    
    let noMealsWarning = "\(GeneralConstants.noMeals)\n\(GeneralConstants.useMealsList)"
    
    override func viewDidLoad() {
        // TODO: Load up meals from the list
        super.viewDidLoad()
        
        configureViewController()
        configureButtonViewArea()
        configureTableView()
        configureSubmitButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWeekMealIDsFromUserDefaults()
        weekOfMealObjects = associateMealObjectsList()
        updateUI(with: weekOfMealObjects)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        // TODO: Figure out how to dynamically set row height based on text size
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
    
    func getWeekMealIDsFromUserDefaults() {
        WeekListPersistenceManager.retrieveIDList(fromList: .weekMeals, completed: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let weekMealsList):
                self.weekOfMealIDs = weekMealsList
                
            case .failure(let error):
                self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        })
    }
    
    private func saveWeekMealsToUserDefaults(arrayOfIDs: [UUID]) {
        for id in arrayOfIDs {
            WeekListPersistenceManager.updateWith(id: id, actionType: .add, toList: .weekMeals) { [weak self] error in
                guard let self = self else {return}
                guard let error = error else {
                    return
                }
                self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    /// created this function because it'll be useful in swipe to delete actions
    private func removeIDFromWeekList(idToRemove: UUID) {
        WeekListPersistenceManager.updateWith(id: idToRemove, actionType: .remove, toList: .weekMeals) { [weak self] error in
            guard let self = self else {return}
            guard let error = error else {return}
            self.presentMPAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    private func removeWeekMealsFromUserDefaults(arrayOfIDs: [UUID]) {
        for id in arrayOfIDs {
            removeIDFromWeekList(idToRemove: id)
        }
    }
    
    func updateUI(with meals: [Meal]) {
        if meals.isEmpty {
            print("meal list is empty")
            //self.showEmptyStateView(with: noMealsWarning, in: self.view)
        } else {
            self.weekOfMealObjects = meals
            DispatchQueue.main.async {
                self.tableView.reloadData()
                /// bring table view to front in case the empty state view was there before
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    private func configureButtonViewArea() {
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
    
    private func configureSubmitButton() {
        randomiseButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func getAllMeals() -> [Meal] {
        var weekMealList: [Meal] = []
        
        MealListPersistenceManager.retrieveMealsList(fromList: .allMeals, completed: { [weak self] result in
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
    
    @objc private func buttonAction() {
        print("button hit")
        if !weekOfMealIDs.isEmpty {
            removeWeekMealsFromUserDefaults(arrayOfIDs: weekOfMealIDs)
        }
        weekOfMealIDs = createWeekMealsList()
        saveWeekMealsToUserDefaults(arrayOfIDs: weekOfMealIDs)
        weekOfMealObjects = associateMealObjectsList()
        updateUI(with: weekOfMealObjects)
    }
    
    func associateMealObjectsList() -> [Meal] {
        
        var newList: [Meal] = []
        let allMeals = getAllMeals()
        
        for i in 0..<weekOfMealIDs.count {
            if let newMeal = allMeals.first(where: {$0.identifier == weekOfMealIDs[i]}) {
                newList.append(newMeal)
            } else {
                // TODO: Create a default meal
            }
        }
        
        return newList
    }
    
    // TODO: Figure out how to pad out the list if it's less than 7 meals, and fill them with placeholder/takeaway meals
    func createWeekMealsList() -> [UUID] {
        var weekList: [UUID] = []
        let allMeals = getAllMeals().shuffled()
        
        let numberOfMeals = (allMeals.count >= 7) ? 7 : allMeals.count
        
        for i in 0..<numberOfMeals {
            weekList.append(allMeals[i].identifier)
        }
        
        return weekList
    }
}

extension WeekVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekOfMealIDs.count
    }
    
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealsCell.reuseID) as! MealsCell
        cell.set(meal: weekOfMealObjects[indexPath.row])
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
    
    // TODO: Make this do something
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Change") { (action, view, nil) in
            print("lol")
            //            self.navigationController?.pushViewController(MealCreatorVC(with: self.meals[indexPath.row]), animated: true)
        }
        action.backgroundColor = UIColor.systemGreen
        return action
    }
    
    /// Remove meal from list
    /// Replace with default meal
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            WeekListPersistenceManager.updateWith(id: self.weekOfMealIDs[indexPath.row], actionType: .remove, toList: .weekMeals) { [weak self] error in
                guard let self  = self else {return}
                guard let error = error else {
                    
                    self.weekOfMealIDs.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self.weekOfMealIDs.isEmpty {
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
    
    /// Look up meal with corresponding UUID and use that to load up the meal detail VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = weekOfMealObjects[indexPath.row]
        let destVC = MealDetailVC(meal: selectedMeal)
        show(destVC, sender: self)
        
        //navigationController?.pushViewController(destVC, animated: true)
    }
}
