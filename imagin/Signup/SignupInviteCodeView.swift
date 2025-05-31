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
                        .font(.system(size: 16))

                        inviteCodeInput(
                            onChange: { code in
                                if errorMessage != nil {
                                    // clear erorr message
                                    errorMessage = nil
                                }
                                if code.count == maxLength {
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
                .disabled(signupState.inviteCode?.isEmpty ?? true)
            }

        }.onAppear {
            if signupState.inviteCode != nil {
                code = signupState.inviteCode!
            }
        }

    }

    private func verifyCode(_ code: String) {
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

    private func inviteCodeInput(onChange: @escaping (String) -> Void)
        -> some View
    {
        return ZStack(alignment: .center) {

            // boxes
            HStack(spacing: 12) {
                ForEach(0..<maxLength, id: \.self) { index in
                    let isFilled = index < code.count
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                isFocused ? Color.imaginBlack : Color.gray,
                                lineWidth: 1
                            )
                            .frame(width: 40, height: 45)

                        if isFilled {
                            let charIndex = code.index(
                                code.startIndex,
                                offsetBy: index
                            )
                            Text(String(code[charIndex]))
                                .font(.system(size: 24, weight: .medium))
                        }
                    }
                }
            }
            // text input
            TextField("", text: $code)
                .focused($isFocused)
                .keyboardType(.default)
                .textContentType(.oneTimeCode)  // Enables auto-fill from SMS
                .textInputAutocapitalization(.characters)
                .frame(width: 280, height: 60)
                .opacity(0.001)  // Almost invisible but still functional
                .onChange(of: code) { newValue in
                    code = newValue.uppercased()
                    if code.count > maxLength {
                        code = String(code.prefix(maxLength))
                    }
                    if newValue.count > maxLength {
                        code = String(newValue.prefix(maxLength))
                    }
                    onChange(code)
                }
                .multilineTextAlignment(.center)

        }
        .frame(height: 60)
        .contentShape(Rectangle())  // Makes the entire area tappable
        .onTapGesture {
            isFocused = true
        }
    }
}

#Preview {
    SignupInviteCodeView()
}
