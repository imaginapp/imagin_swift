//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupProfileView: View {
    @EnvironmentObject var signupState: SignupState

    @State private var avatarImage: Image?
    @State private var selectedUIImage: UIImage?
    @State private var profileName: String = ""
    @State private var profileAboutMe: String = ""

    @State private var profileNameError: String = ""
    @State private var profileAboutMeError: String = ""

    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var isAboutMeFieldFocused: Bool

    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
            BackgroundView(linearGradient: Gradient.threeColorAngled) {
                ScrollViewReader { proxy in
                    ScrollView {
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

                            CustomPhotoPicker(
                                selectedImage: $selectedUIImage
                            )
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
                                .id("nameField")
                                .focused($isNameFieldFocused)
                                .font(.title)
                                .onChange(of: profileName) { value in
                                    if !profileNameError.isEmpty {
                                        withAnimation {
                                            profileNameError = ""
                                        }
                                    }
                                }
                                .multilineTextAlignment(.center)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(.horizontal, 8)

                                if !profileNameError.isEmpty {
                                    Text(profileNameError)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.top, 4)
                                }

                                Divider()

                                TextField(
                                    "Something about you...",
                                    text: $profileAboutMe,
                                    axis: .vertical
                                )
                                .lineLimit(2...4)
                                .id("aboutMeField")
                                .focused($isAboutMeFieldFocused)
                                .font(.body)
                                .onChange(of: profileName) { value in
                                    if !profileAboutMeError.isEmpty {
                                        withAnimation {
                                            profileAboutMeError = ""
                                        }
                                    }
                                }
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)

                                if !profileAboutMeError.isEmpty {
                                    Text(profileAboutMeError)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.top, 4)
                                }
                            }.padding()

                        }
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)

                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: isNameFieldFocused) { focused in
                        if focused {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("nameField", anchor: .center)
                            }
                        }
                    }
                    .onChange(of: isAboutMeFieldFocused) { focused in
                        if focused {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("aboutMeField", anchor: .center)
                            }
                        }
                    }
                }

            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // go to next signup step
                        signupState.navigateToPrev()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.imaginBlack)
                        }
                        .padding(10)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // validation and navigation logic
                        signupState.navigateToNext()
                    }) {
                        Text("Next")
                            .font(.system(size: 16).bold())
                            .foregroundColor(.imaginBlack)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(.thinMaterial)
                            .clipShape(Capsule())
                    }
                }
            
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
