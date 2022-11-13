//
//  WelcomeFormView.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

struct WelcomeFormView: View {
    @AppStorage("firstRun") var isFirstRun: Bool = true
    @AppStorage("userName") var userName: String = "John"
    @AppStorage("userAge") var userAge: String = "20"
    @AppStorage("carMakeModel") var carMakeModel: String = "Toyota Supra"
    @AppStorage("language") var language: String = "en-US"
    
    var body: some View {
//        NavigationView {
            VStack {
                Text("Let us know a little about you")
                    .font(.system(size: 45, weight: .bold))
                    .padding(3)
                    .padding(.bottom, 50)
                Spacer()
                VStack {
                    FormTextField(text: $userName, title: "Name")
                    FormTextField(text: $userAge, title: "Age")
                    FormTextField(text: $carMakeModel, title: "Car")
                    FormTextField(text: $language, title: "Language")
                    Spacer()
                }
                
                Button("Continue") {
                    isFirstRun = false
                }
            }
        .navigationBarBackButtonHidden()
        //.background(Color(red: 44, green: 43, blue: 52))
    }
}

struct WelcomeFormView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeFormView(userName: "John Smith", userAge: "20", carMakeModel: "Toyota Supra", language: "en-US")
    }
}

struct FormTextField: View {
    @Binding var text: String
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            .padding(.bottom, -10)
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 217, green: 217, blue: 217))
                    .frame(height: 40)
                TextField("", text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.black)
                    .padding()
            }
        }
        .padding(.horizontal, 10)
    }
}

