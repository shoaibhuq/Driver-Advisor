//
//  Road_Sign_DetectorApp.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

@main
struct Road_Sign_DetectorApp: App {
    @AppStorage("firstRun") var isFirstRun: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstRun {
                WelcomeFormView()
            } else {
                ContentView()
                //ProfileEditorView()
            }
        }
    }
}
