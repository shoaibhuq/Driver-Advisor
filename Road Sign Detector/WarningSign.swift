//
//  WarningSign.swift
//  Road Sign Detector
//
//  Created by Jake Spann on 11/13/22.
//

import SwiftUI

struct WarningSign: View {
    @State var critical: Bool = false
    var text: String = "Warning"
    
    var body: some View {
        Rectangle()
            .foregroundColor(critical ? .red : .orange)
            .frame(width: 200, height: 250)
            .cornerRadius(20)
            .overlay {
                ZStack {
                    Text(text)
                        .fontWeight(.bold)
                        .font(.system(size: 35))
                        .multilineTextAlignment(.center)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 175, height: 225)
                }
            }
            .opacity(0.8)
    }
}

struct WarningSign_Previews: PreviewProvider {
    static var previews: some View {
        WarningSign()
    }
}
