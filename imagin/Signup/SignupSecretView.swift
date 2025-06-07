//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI
import stellarsdk

struct SignupSecretView: View {
    @EnvironmentObject var signupState: SignupState

    @State private var isLoadingSecret: Bool = false
    @State private var showCopiedMessage: Bool = false

    var body: some View {
        BackgroundView(linearGradient: Gradient.threeColorAngled) {
            ScrollView {
                VStack(alignment: .center) {
                    InfoCard(title: "Your account secret.") {
                        Text(
                            "This is your account secret. It's used to restore your account. Save it in a secure place, you might need it in the future!"
                        )
                    }.fixedSize(horizontal: false, vertical: true)

                    ThinCard {
                        VStack {
                            FlowLayout(
                                items: signupState.mnemonic?.split(
                                    separator: " "
                                ).map(
                                    String.init
                                ) ?? [],
                                alignment: .center,
                            ) { word in
                                Text(word)
                                    .lineLimit(1)
                                    .fixedSize(
                                        horizontal: true,
                                        vertical: false
                                    )
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(
                                        .thinMaterial,
                                        in: Capsule()
                                    )
                            }

                            Divider().padding(.vertical, 8)

                            SmallPillButton(
                                image: "document.on.document",
                                text: showCopiedMessage
                                    ? "Copied!" : "Copy secret",
                                action: {
                                    if let mnemonic = signupState.mnemonic {
                                        UIPasteboard.general.string =
                                            mnemonic
                                        // Optionally add haptic feedback
                                        let impactFeedback =
                                            UIImpactFeedbackGenerator(
                                                style: .medium
                                            )
                                        impactFeedback.impactOccurred()
                                    }

                                    withAnimation {
                                        showCopiedMessage = true
                                    }

                                    DispatchQueue.main.asyncAfter(
                                        deadline: .now() + 2
                                    ) {
                                        withAnimation {
                                            showCopiedMessage = false
                                        }
                                    }
                                }
                            )
                        }.padding()
                    }
                    .fixedSize(
                        horizontal: false,
                        vertical: true,
                    )

                }
                .padding()
            }
        }.onAppear {
            if signupState.mnemonic == nil {
                generateMnemonic()
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
                .disabled(signupState.mnemonic == nil)
            }
        }
    }

    private func generateMnemonic() {
        isLoadingSecret = true

        Task {
            let newMnemonic = WalletUtils.generate24WordMnemonic()

            do {
                try AccountKeys.storeDefaultmnemonic(newMnemonic)

                await MainActor.run {
                    signupState.mnemonic = newMnemonic
                    self.isLoadingSecret = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingSecret = false
                }
            }
        }
    }

}

#Preview {
    SignupSecretView()
        .environmentObject(SignupState())
        .environmentObject(AppState(host: "preview.example.com"))
}
