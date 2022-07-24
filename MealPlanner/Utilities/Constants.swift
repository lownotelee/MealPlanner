//
//  Constants.swift
//  MealPlanner
//
//  Created by Lee on 31/7/20.
//  Copyright © 2020 radev. All rights reserved.
//

import UIKit

enum GeneralConstants {
    static let daysInWeek: Int  = 7
    static let noMeals: String  = "You have no meals saved!"
    static let useAddButton     = "Add one by tapping the + button"
    static let useMealsList     = "Add one in the meals list"
}

struct Images {
    static let cellDefaultBackgroundImage = UIImage(named: "MP-Food_placeholder_3")!
}

enum SFSymbols {
    static let calendar         = UIImage(systemName: "calendar")
    static let list             = UIImage(systemName: "text.badge.plus")
}

enum ScreenSize {
    static let width            = UIScreen.main.bounds.size.width
    static let height           = UIScreen.main.bounds.size.height
    static let maxLength        = max(ScreenSize.width, ScreenSize.height)
    static let minLength        = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad   && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
