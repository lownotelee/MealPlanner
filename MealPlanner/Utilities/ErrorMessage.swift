//
//  ErrorMessage.swift
//  MealPlanner
//
//  Created by Lee on 8/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import Foundation

enum MPError: String, Error {
    
    //case invalidUsername        = "This username creates an invalid request. Please try again"               // probably isnt relevant
    case unableToComplete       = "Unable to complete your request. Please check your internet connection"
    case invalidResponse        = "Invalid response from the server. Please try again"
    case invalidData            = "The data received from the server was invalid. Please try again"
    case unableToSave           = "There was an error in saving this meal. Please try again"
    case alreadyInMealsList     = "Meal already in meals list"
}
