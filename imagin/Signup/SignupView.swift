//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        BackgroundView(linearGradient: Gradient.threeColorAngled) {
            VStack {
                Spacer()
                Image("LogoBlack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Spacer()
                Button(action: {
                    print("pressed!!")
                }) {
                    HStack {
                        Spacer()
                        Text("Create Account")
                            .font(.system(size: 20).bold())
                            .foregroundColor(.imaginBlack)
                        Spacer()
                    }
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(45)
                }
            }.padding()
            
        }
    }
}

#Preview {
    SignupView()
}
