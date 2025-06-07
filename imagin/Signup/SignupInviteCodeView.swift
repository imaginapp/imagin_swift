//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupInviteCodeView: View {
    @EnvironmentObject var signupState: SignupState
    @EnvironmentObject var appState: AppState
    // dismiss to close sheet
    @Environment(\.dismiss) private var dismiss

    @State private var code: String = ""
    @State private var isCheckingCode: Bool = false

    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool

    private let maxLength = 6

    var body: some View {
        BackgroundView(linearGradient: Gradient.threeColorAngled) {
            ScrollView {
                VStack {
                    ThinCard {
                        VStack {
                            Text("Invite code")
                                .font(.title)
                                .padding(5)

                            Text(
                                "To create an account you will need a invite code. Please enter the code below to proceed."
                            )
                            .multilineTextAlignment(.center)
                            .font(.body)

                            InviteCodeInputView(
                                code: $code,
                                maxLength: maxLength,
                                isFocused: $isFocused,
                                error: errorMessage != nil,
                                onChange: { newCode in
                                    if errorMessage != nil {
                                        errorMessage = nil
                                    }
                                },
                                onSubmit: { newCode in
                                    if errorMessage != nil {
                                        errorMessage = nil
                                    }
                                    if newCode.count == maxLength {
                                        verifyCode(code)
                                    }
                                }
                            )
                            .disabled(isCheckingCode)
                            .padding(.vertical)

                            Text(errorMessage ?? " ")
                                .font(.body)
                                .foregroundColor(.red)

                            if isCheckingCode {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(
                                            tint: .imaginBlack
                                        )
                                    )
                                    .scaleEffect(2.0, anchor: .center)
                                    .padding(.vertical, 18)
                            } else {
                                PillButton(
                                    text: "Verify Code",
                                    disabled: code.count != 6,
                                    action: {
                                        verifyCode(code)
                                    },
                                )
                            }

                        }
                        .padding()
                    }
                    InfoCard(
                        icon: "ellipsis.rectangle",
                        title: "need an invite code?"
                    ) {
                        Text("Click here to request an invite code")
                            .multilineTextAlignment(.center)

                        SmallPillButton(
                            image: "ellipsis.rectangle",
                            text: "Get Invite Code",
                            action: {
                                print("pressed!!")
                            }
                        )
                    }
                    .fixedSize(horizontal: false, vertical: true)

                }
                .padding()
            }.scrollDismissesKeyboard(.interactively)

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16).bold())
                        .foregroundColor(.imaginBlack)
                        .padding(10)
                        .background(.thinMaterial)
                        .cornerRadius(45)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // validation and navigation logic
                    verifyCode(code)
                }) {
                    Text("Next")
                        .font(.system(size: 16).bold())
                        .foregroundColor(.imaginBlack)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }
                .disabled(code.count != 6)
            }

        }
        .onAppear {
            if signupState.inviteCode != nil {
                code = signupState.inviteCode!
            }
        }

    }

    private func verifyCode(_ code: String) {
        if isCheckingCode {
            return
        }

        errorMessage = nil

        if code.isEmpty {
            errorMessage = "Invite code is required"
            return
        }

        if code == signupState.inviteCode {
            self.signupState.navigateToNext()
            return
        }

        self.isCheckingCode = true

        Task {
            defer {
                Task { @MainActor in
                    self.isCheckingCode = false
                }
            }
            do {
                let response = try await appState.grpcClient.validateInviteCode(
                    code
                )
                await MainActor.run {
                    if response.isValid {
                        self.signupState.inviteCode = code
                        self.signupState.navigateToNext()
                    } else {
                        errorMessage = "Invite code is invalid"
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Invite code is invalid"
                }
            }
        }
    }
}

#Preview {
    SignupInviteCodeView()
        .environmentObject(SignupState())
        .environmentObject(AppState(host: "preview.example.com"))
}
