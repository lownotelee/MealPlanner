//
//  TestMealCreatorVC.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import SwiftUI

struct TestMealCreatorVC: View {
    
    @State private var isVegan          = false
    @State private var isVegetarian     = false
    @State private var isGlutenFree     = false
    @State private var isFodmapFriendly = false
    @State private var description: String = ""
    
    var body: some View {
        VStack{
            TextField("Description", text: $description).padding()
            HStack{
                VStack{
                    Toggle(isOn: $isVegan) {
                        Text("Vegan")
                    }.padding()
                    Toggle(isOn: $isVegetarian) {
                        Text("Vegetarian")
                    }.padding()
                }
                VStack {
                    Toggle(isOn: $isGlutenFree) {
                        Text("Gluten Free")
                    }.padding()
                    Toggle(isOn: $isFodmapFriendly) {
                        Text("FODMAP Friendly")
                    }.padding()
                }
                
            }
            Button(action: {self.buttonAction()}) {
                Text("Submit").padding()
            }
        }
    }
    
    func buttonAction() {
        print("vegan option is \(self.isVegan)")
    }
}



struct TestMealCreatorVC_Previews: PreviewProvider {
    static var previews: some View {
        TestMealCreatorVC()
    }
}
