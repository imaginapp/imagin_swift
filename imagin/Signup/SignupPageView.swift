//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupPageView: View {
    @State private var showSignup = false

    var body: some View {
        BackgroundView(linearGradient: Gradient.threeColorAngled) {

            VStack {
                Spacer()
                ThinCard {

                    VStack {
                        Image("LogoBlack")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250.0)
                            .padding(.bottom)
                        // title text
                        Text("Welcome!")
                            .font(.title)
                            .padding(.bottom, 8)
                        // content text
                        Text(
                            "Lets create your new account, it's quick and easy!"
                        ).multilineTextAlignment(.center)
                            .font(.system(size: 16))

                        FullWidthPillButton(
                            text: "Create Account",
                            action: {
                                showSignup = true
                            }
                        ).padding()

                    }
                    .padding()
                    //                        .frame(maxWidth: .infinity, alignment: .leading)

                }
                InfoCard(
                    icon: "text.document",
                    title: "Terms of Service",
                ) {
                    VStack {
                        Text(
                            "By Creating an account you agree to our Terms of Service."
                        )
                        .multilineTextAlignment(.center)

                        SmallPillButton(
                            image: "text.document",
                            text: "View Terms of Service"
                        ) {
                            print("Pressed!!")
                        }
                    }

                }
                .fixedSize(horizontal: false, vertical: true)

            }.padding()
        }.fullScreenCover(isPresented: $showSignup) {
            SignupStartView(onComplete: {
                showSignup = false
            })
        }

    }
}

#Preview {
    SignupPageView()
}
