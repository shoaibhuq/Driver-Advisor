//
//  ContentView.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var results: ScanResults = ScanResults(signType: .doNotEnter)
    
    var body: some View {
        ZStack {
            ARViewContainer(results: results)
                .ignoresSafeArea(.all)
            HStack {
               /* Text(results.signType.rawValue ?? "None")
                    .padding()
                    .background(.regularMaterial)*/
                Spacer()
                WarningSign(critical: true, text:  results.signType.rawValue ?? "NONE")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
