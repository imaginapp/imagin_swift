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
                VStack {
                    ThinCard {
                        VStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 24)).padding(.bottom, 5)
                            Text("Add an avatar")
                                .font(.system(size: 24).bold())
                                .padding(4)

                            if let avatarImage = avatarImage {
                                avatarImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                            } else {
                                //                                Image(systemName: "person.crop.square.fill")
                                //                                    .resizable()
                                //                                    .scaledToFit()
                                //                                    .frame(width: 120, height: 120)
                                //                                    .foregroundColor(.imaginWhite)
                            }

                            Button(action: {
                                showImagePicker = true
                            }) {
                                HStack {
                                    Image(
                                        systemName:
                                            "person.crop.circle.badge.plus"
                                    ).font(
                                        .system(size: 16)
                                    )
                                    .foregroundColor(.imaginBlack)
                                    Text("Add Avatar")
                                        .font(.system(size: 16).bold())
                                        .foregroundColor(.imaginBlack)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(.thinMaterial)
                                .cornerRadius(45)
                            }
                        }.padding()

                    }.fixedSize(horizontal: false, vertical: true)

                    ThinCard {
                        VStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 24)).padding(.bottom, 5)
                            Text("Profile")
                                .font(.system(size: 24).bold())
                                .padding(4)
                            Text("Enter your name and a bit about yourself")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16))
                            Divider()
                            TextField(
                                "Enter your name",
                                text: $profileName
                            )
                            .font(.system(size: 24).bold())
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
