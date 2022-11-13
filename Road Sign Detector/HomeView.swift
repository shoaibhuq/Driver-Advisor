//
//  HomeView.swift
//  Road Sign Detector
//
//  Created by Khang Nguyen on 11/13/22.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("userName") var userName: String = "John"
    @State var displayHelp = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Hello, \(userName)!")
                        .bold()
                        .padding(.horizontal, 32)
                    Spacer()
                    Button(action: { displayHelp.toggle() }, label: {
                        HStack {
                            Text("Help")
                                .bold()
                            Image(systemName: "info.circle")
                        }
                    })
                    .padding(.horizontal)
                }
                
                
                CarCard()
                    .padding(.horizontal)
                    .shadow(radius: 0.1)
                
                HStack {
                    NavigationLink(destination: {ProfileEditorView()}, label: {
                        SmallCard(imageName: "ProfileIcon", text: "Profile")
                            .padding()
                    })
                    SmallCard(imageName: "DataIcon", text: "Statistics")
                        .padding(.vertical)
                        .padding(.trailing)
                }
                
                Spacer()
                
                NavigationLink(destination: { ContentView() }, label: {
                    VStack {
                        Text("Start a Trip")
                            .font(.custom("Barlow Bold", size: 40))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.mainBG)
                                    .frame(width: 350, height: 130)
                            )
                            .padding()
                            .padding(.vertical)
                    }
                })
                .padding()
                .sheet(isPresented: $displayHelp, content: { HelpView() })
            }
        }
        .preferredColorScheme(.light)
    }
}

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.mainBG.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("How to use the app")
                    .font(.custom("Barlow Bold", size: 45))
                    .foregroundColor(.white)
                    .padding()
                
                Text(
                """
                1. Before starting a trip, make sure that you have your phone set up horizontal orientaion
                
                2. Make sure the back camera is facing towards the windshield and the front camera has a clear view of your face
                
                 3. Once these are you can start your trip
                """)
                    .font(.custom("Barlow Bold", size: 25))
                    .foregroundColor(.white)
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        VStack {
                            Text("Done")
                                .font(.custom("Barlow Bold", size: 30))
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(.black)
                                        .frame(width: 300, height: 70)
                                )
                                .padding()
                                .padding(.vertical)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct SmallCard: View {
    var imageName: String
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(red: 0.9541666507720947, green: 0.9541666507720947, blue: 0.9541666507720947))
                .frame(height: 150)
            VStack {
                Image(imageName)
                    .frame(height: 90)
                        .font(.custom("Barlow Bold", size: 15))
                Text(text)
            }
        }
    }
}

struct CarCard: View {
    @AppStorage("carMakeModel") var carMakeModel: String = "Toyota Supra"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(#colorLiteral(red: 0.9541666507720947, green: 0.9541666507720947, blue: 0.9541666507720947, alpha: 1)))
                .frame(height: 250)
            VStack {
                HStack {
                    Text("YOUR CAR")
                        .font(.custom("Barlow Regular", size: 15))
                        .foregroundColor(.gray)
                        .opacity(0.8)
                        .padding()
                    Spacer()
                }
                Image("CarProfile")
                    .scaledToFill()
                
                HStack {
                    Text(carMakeModel)
                        .font(.custom("Barlow Bold", size: 20))
                    Spacer()
                    Text("Last Trip: \(Date().formatted(.dateTime))")
                        .font(.custom("Barlow Semibold", size: 14))
                    
                }
                .padding()
                
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
