//
//  ContentView.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var results: ScanResults = ScanResults(signType: .empty)
    @State var displayedResult: ScanResults?
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ARViewContainer(results: results)
                .ignoresSafeArea(.all)
                .onChange(of: results.signType, perform: {result in
                    displayedResult = ScanResults(signType: result)
                    displayedResult?.signType = result
                })
            HStack {
                Spacer()
                VStack {
                    if displayedResult != nil {
                        WarningSign(severity: displayedResult!.severity, text:  results.signType.rawValue ?? "NONE")
                            .onReceive(timer, perform: {output in
                                withAnimation {
                                    displayedResult = nil
                                }
                            })
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
