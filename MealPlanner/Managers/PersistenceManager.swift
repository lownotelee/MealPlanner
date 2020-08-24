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
    
    enum Keys {
        static let meals = "meals"
    }
    
    static func updateWith(meal: Meal, actionType: PersistenceActionType, completed: @escaping (MPError?) -> Void) {
        retrieveMealsList { result in
            switch result {
                case .success(var mealsList):
                    
                    switch actionType {
                        case .add:
                            guard !mealsList.contains(meal) else {
                                completed(.alreadyInMealsList)
                                return
                            }
                            mealsList.append(meal)
                        
                        case .remove:
                            mealsList.removeAll(where: {$0.title == meal.title})
                }
                    completed(save(mealsList: mealsList))
                
                case .failure(let error):
                    completed(error)
            }
        }
    }
    
    static func retrieveMealsList(completed: @escaping (Result<[Meal], MPError>) -> Void) {
        
        guard let mealsData = defaults.object(forKey: Keys.meals) as? Data else {
            // if this is nil, then theres no data in there
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
    
    static func save(mealsList: [Meal]) -> MPError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedMealsList = try encoder.encode(mealsList)
            defaults.set(encodedMealsList, forKey: Keys.meals)
            return nil
        } catch {
            return .unableToSave
        }
    }
}
