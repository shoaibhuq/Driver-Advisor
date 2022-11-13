//
//  HomeView.swift
//  Road Sign Detector
//
//  Created by Khang Nguyen on 11/13/22.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        NavigationView {
            
            VStack(alignment:.leading) {
                Spacer()
                Spacer()
                Image("CarHomeScreen")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Spacer()
                HStack {
                    Text("Drive Advisor")
                        .font(.system(size: 45)).bold()
                    Spacer()
                }
                .padding(.horizontal, 24)
                Text("An extra pair of eyes to keep you safe on the road")
                    .font(.title3)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 2)
                    .opacity(0.8)
                
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: { WelcomeFormView() }, label: {CustomButton(text: "Let's go")})
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.mainBG)
        }
    }
}

struct CustomButton: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .font(.title3)
                .foregroundColor(.mainBG)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                )
                .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .preferredColorScheme(.dark)
    }
}
