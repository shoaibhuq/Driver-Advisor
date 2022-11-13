//
//  Profile Editor.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

struct ProfileEditorView: View {
    @AppStorage("userName") var userName: String = "John"
    @AppStorage("userAge") var userAge: String = "20"
    @AppStorage("carMakeModel") var carMakeModel: String = "Toyota Supra"
    @AppStorage("language") var language: String = "en-US"
    
    var body: some View {
        NavigationView {
            VStack {
                FormTextField(text: $userName, title: "Name")
                FormTextField(text: $userAge, title: "Age")
                FormTextField(text: $carMakeModel, title: "Car")
                FormTextField(text: $language, title: "Language")
                Spacer()
            }
            .padding(.top, 60)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Profile")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("Save") {
                            
                        }
                    }
                }
            }
        }
    }
}

struct ProfileEditorViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView()
    }
}
