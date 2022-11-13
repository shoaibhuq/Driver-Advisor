//
//  ContentView.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var results: ScanResults = ScanResults(signType: .empty)
    
    var body: some View {
        ZStack {
            ARViewContainer(results: results)
                .ignoresSafeArea(.all)
            HStack {
               /* Text(results.signType.rawValue ?? "None")
                    .padding()
                    .background(.regularMaterial)*/
                Spacer()
                VStack {
                    if results.signType != .empty {
                        WarningSign(severity: results.severity, text:  results.signType.rawValue ?? "NONE")
                    } else {
                        Spacer()
                    }
                    Button("Done Driving", action: {})
                        .frame(width: 200, height: 70)
                        .background(.red)
                        .cornerRadius(20)
                       // .buttonStyle(.borderedProminent)
                        .tint(.white)
                        //.controlSize(.large)
                        .opacity(0.8)
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
