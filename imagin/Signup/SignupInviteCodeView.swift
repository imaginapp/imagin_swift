//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupInviteCodeView: View {
    @State private var code: String = ""
    @FocusState private var isFocused: Bool
    private let maxLength = 6

    var body: some View {
        BackgroundView(linearGradient: Gradient.threeColorAngled) {
            VStack {
                ThinCard {
                    VStack {
                        Text("Invite code")
                            .font(.system(size: 24).bold())
                            .padding(4)

                        Text(
                            "To create an account you will need a invite code. Please enter the code below to proceed."
                        )
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))

                        inviteCodeInput()
                            .padding(.vertical)

                        FullWidthPillButton(
                            text: "Verify Code",
                            action: {
                                print("Code entered: \(code)")
                            }
                        ).padding()
                    }
                    .padding()
                }
                ThinCard {
                    VStack {
                        Image(systemName: "ellipsis.rectangle").font(
                            .system(size: 24)
                        ).padding(.bottom, 5)
                        Text("Need an invite code?")
                            .font(.system(size: 18)).bold().foregroundStyle(
                                Color.imaginBlack
                            ).padding(.bottom, 1)
                        Text("Click here to request an invite code")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16))

                        Button(action: {
                            print("pressed!!")
                        }) {
                            HStack {
                                Image(systemName: "ellipsis.rectangle").font(
                                    .system(size: 16)
                                )
                                .foregroundColor(.imaginBlack)
                                Text("Get Invite Code")
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
            }.padding()
        }
    }

    private func inviteCodeInput() -> some View {
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
