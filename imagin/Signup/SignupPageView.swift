//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupPageView: View {
    var body: some View {
        NavigationView {
            BackgroundView(linearGradient: Gradient.threeColorAngled) {

                VStack {
                    Spacer()
                    ThinCard {

                        VStack {
                            Image("LogoBlack")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250.0)
                                .padding()
                            // title text
                            Text("Welcome!")
                                .font(.system(size: 24).bold())
                                .padding(4)
                            // content text
                            Text(
                                "Lets create your new account, it's quick and easy!"
                            ).multilineTextAlignment(.center)
                            .font(.system(size: 16))

                            FullWidthPillButton(
                                text: "Create Account",
                                action: {
                                    print("pressed!!")
                                }
                            ).padding()
                            
                        }
                        .padding()
                        //                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                    ThinCard {
                        VStack {
                            Image(systemName: "text.document").font(.system(size: 24)).padding(.bottom, 5)
                            Text("Terms of Service")
                                .font(.system(size: 18)).bold().foregroundStyle(Color.imaginBlack).padding(.bottom, 1)
                            Text("By Creating an account you agree to our Terms of Service.")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16))
                            
                            Button(action: {
                                print("pressed!!")
                            }) {
                                HStack {
                                    Image(systemName: "text.document").font(.system(size: 16))
                                        .foregroundColor(.imaginBlack)
                                    Text("View Terms of Service")
                                        .font(.system(size: 16).bold())
                                        .foregroundColor(.imaginBlack)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(.thinMaterial)
                                .cornerRadius(45)
                            }
                        }.padding()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    
                    //                    ThinCard {
                    //                            HStack {
                    //                                Button(action: {
                    //                                    print("pressed!!")
                    //                                }) {
                    //                                    HStack {
                    //                                        Image(systemName: "xmark")
                    //                                            .font(.system(size: 20).bold())
                    //                                            .foregroundColor(.imaginBlack)
                    //                                    }
                    //                                    .padding()
                    //                                    .background(.thinMaterial)
                    //                                    .cornerRadius(45)
                    //                                }.padding()
                    //                                Button(action: {
                    //                                    print("pressed!!")
                    //                                }) {
                    //                                    HStack {
                    //                                        Spacer()
                    //                                        Text("Create Account")
                    //                                            .font(.system(size: 20).bold())
                    //                                            .foregroundColor(.imaginBlack)
                    //                                        Spacer()
                    //                                    }
                    //                                    .padding()
                    //                                    .background(.thinMaterial)
                    //                                    .cornerRadius(45)
                    //                                }.padding()
                    //                            }
                    //                        }.fixedSize(
                    //                            horizontal: false, vertical: true)
                }.padding()

            }
//            .navigationBarItems(
//                leading:
//                    Button(action: {
//                        print("pressed!!")
//                    }) {
//                        HStack {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 16).bold())
//                                .foregroundColor(.imaginBlack)
//                        }
//                        .padding(10)
//                        .background(.thinMaterial)
//                        .cornerRadius(45)
//                    },
//                //                    Image("LogoBlack")
//                //                    .resizable()
//                //                    .aspectRatio(contentMode: .fit)
//                //                    .frame(height: 45.0)
//                //                    .padding(),
//                trailing:
//                    Button(action: {
//                        print("pressed!!")
//                    }) {
//                        HStack {
//                            Text("Create Account")
//                                .font(.system(size: 16).bold())
//                                .foregroundColor(.imaginBlack)
//                                .padding(.vertical, 10)
//                                .padding(.horizontal, 16)
//
//                        }
//                        .background(.thinMaterial)
//                        .cornerRadius(45)
//                    }
//            )
        }
    }
}

#Preview {
    SignupPageView()
}
