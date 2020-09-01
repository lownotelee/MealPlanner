//
//  PersistenceManager.swift
//  MealPlanner
//
//  Created by Lee on 8/8/20.
//  Copyright © 2020 radev. All rights reserved.
//


import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys: String {
        case allMeals     = "meals"
        case weekMeals    = "weekMeals"
    }

    static func updateWith(meal: Meal, actionType: PersistenceActionType, toList: Keys, completed: @escaping (MPError?) -> Void) {
        retrieveMealsList(fromList: toList) { result in
            switch result {
            case .success(var mealsList):
                
                switch actionType {
                case .add:
                    /// This bit had a check to see if the objects were the same, same as in the GHFollowers project.
                    /// This compared hash values, which in this case were different because of the UUID
                    
                    /// If the title is the same on two different objects, give a popup warning thing
                    if let _ = mealsList.first(where: {$0.title == meal.title && $0.identifier != meal.identifier}) {
                        completed(.needUniqueTitle)
                        return
                    }
                    
                    /// if the meal list contains an item with the same identifier, replace it with the meal passed in.
                    if let i = mealsList.firstIndex(where: {$0.identifier == meal.identifier}) {
                        mealsList[i] = meal
                    } else {
                        /// If all is good, whack the meal on the list
                        mealsList.append(meal)
                    }

                case .remove:
                    mealsList.removeAll(where: {$0.identifier == meal.identifier})
                }
                
                completed(save(mealsList: mealsList, to: toList))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveMealsList(fromList: Keys, completed: @escaping (Result<[Meal], MPError>) -> Void) {
        
        guard let mealsData = defaults.object(forKey: fromList.rawValue) as? Data else {
            /// if this is nil, then there's no data in there
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let mealsList = try decoder.decode([Meal].self, from: mealsData)
            completed(.success(mealsList))
        } catch {
            completed(.failure(.unableToSave))
        }
        
    }
    
    static func save(mealsList: [Meal], to list: Keys) -> MPError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedMealsList = try encoder.encode(mealsList)
            defaults.set(encodedMealsList, forKey: list.rawValue)
            return nil
        } catch {
            return .unableToSave
        }
    }
}
