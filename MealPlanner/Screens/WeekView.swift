//
//  WeekView.swift
//  MealPlanner
//
//  Created by Lee on 18/3/2023.
//  Copyright © 2023 radev. All rights reserved.
//

import SwiftUI

struct WeekView: View {
    
    @State private var selection = 0
    
    var body: some View {
        TabView {
            //Text("Home Tab")
            Text("Bookmark Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Week")
                }
                .tag(0)
            Text("Bookmark Tab")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Meals")
                }
                .tag(1)
            }
        .accentColor(.green)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView()
    }
}
