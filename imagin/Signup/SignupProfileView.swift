//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupProfileView: View {
    @State private var avatarImage: Image?
    @State private var showImagePicker = false
    @State private var selectedUIImage: UIImage?
    @State private var profileName: String = ""
    @State private var profileAboutMe: String = ""

    var body: some View {
        NavigationView {
            BackgroundView(linearGradient: Gradient.threeColorAngled) {
                ScrollView {
                    VStack {

                        VStack {
                            if let avatarImage = avatarImage {
                                avatarImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 240, height: 240)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 40,
                                            style: .continuous
                                        )
                                    )
                            } else {
                                Image(systemName: "person.crop.square.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 240, height: 240)
                                    .foregroundColor(.imaginWhite)
                                    .opacity(0.2)
                            }

                            Button(action: {
                                showImagePicker = true
                            }) {
                                HStack {
                                    Image(
                                        systemName:
                                            "person.crop.circle.badge.plus"
                                    )
                                    .foregroundColor(.imaginBlack)
                                    Text(
                                        selectedUIImage == nil
                                            ? "Add Avatar" : "Edit Avatar"
                                    )
                                    .foregroundColor(.imaginBlack)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(.thinMaterial)
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 32)

                        ThinCard {
                            VStack {
                                Image(systemName: "person.circle")
                                    .font(.title)
                                    .padding(.bottom, 5)
                                Text("Profile")
                                    .font(.title)
                                    .padding(4)
                                Text("Enter your name and a bit about yourself")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 16))
                                Divider()
                                TextField(
                                    "Enter your name",
                                    text: $profileName
                                )
                                .font(.title)
                                .onSubmit {
                                    //                                    validate(name: username)
                                }
                                .multilineTextAlignment(.center)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 8)

                                Divider()

                                MultilineTextField(
                                    placeholder: "Something about yourself",
                                    text: $profileAboutMe
                                )
                                .frame(minHeight: 100)
                            }.padding()

                        }.fixedSize(horizontal: false, vertical: true)

                    }.padding()
                }
            }.navigationBarItems(
                leading:
                    Button(action: {
                        print("pressed!!")
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.imaginBlack)
                        }
                        .padding(10)
                        .background(.thinMaterial)
                        .cornerRadius(45)
                    },
                trailing:
                    Button(action: {
                        print("pressed!!")
                    }) {
                        HStack {
                            Text("Next")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.imaginBlack)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)

                        }
                        .background(.thinMaterial)
                        .cornerRadius(45)
                    }
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedUIImage, isShown: $showImagePicker)
        }
        .onChange(of: selectedUIImage) { newImage in
            if let newImage = newImage {
                avatarImage = Image(uiImage: newImage)
            }
        }

    }
}

#Preview {
    SignupProfileView()
}
