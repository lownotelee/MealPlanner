//
//  TestMealCreatorVC.swift
//  MealPlanner
//
//  Created by Lee on 1/8/20.
//  Copyright © 2020 radev. All rights reserved.
//

import SwiftUI

struct TestMealCreatorVC: View {
    @State private var description: String = ""
    
    var body: some View {
        VStack{
            TextField("Description", text: $description).padding()

            Button(action: {self.buttonAction()}) {
                Text("Submit").padding()
            }
        }
    }
    
    func buttonAction() {
        print("yeah gday fellas")
    }
}



struct TestMealCreatorVC_Previews: PreviewProvider {
    static var previews: some View {
        TestMealCreatorVC()
    }
}
