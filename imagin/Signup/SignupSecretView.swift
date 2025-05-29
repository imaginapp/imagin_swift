//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI
import stellarsdk

struct SignupSecretView: View {
    @State private var isLoadingSecret: Bool = false
    @State private var mnemonic: String?

    var body: some View {
        NavigationView {
            BackgroundView(linearGradient: Gradient.threeColorAngled) {
                VStack {
                    ThinCard {
                        VStack {
                            // title text
                            Text("Your account secret.")
                                .font(.system(size: 24).bold())
                                .padding(4)
                            // content text
                            Text(
                                "This is your account secret. It's used to restore your account. Save it in a secure place, you might need it in the future!"
                            )
                            .font(.system(size: 16))
                            .padding(.bottom, 8)

                        }
                        .padding()

                    }.fixedSize(horizontal: false, vertical: true)

                    ThinCard {
                        VStack {
                            FlowLayout(
                                items: mnemonic?.split(separator: " ").map(
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
                            Divider()
                            Button(action: {
                                print("pressed!!")
                            }) {
                                HStack {
                                    Image(systemName: "document.on.document")
                                        .font(.system(size: 16))
                                        .foregroundColor(.imaginBlack)
                                    Text("Copy secret")
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

            }.onAppear {
                generateMnemonic()
            }
            .navigationBarItems(
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
    }

    private func generateMnemonic() {
        isLoadingSecret = true

        Task {
            let newMnemonic = WalletUtils.generate24WordMnemonic()

            do {
                try AccountKeys.storeDefaultmnemonic(newMnemonic)

                await MainActor.run {
                    self.mnemonic = newMnemonic
                    self.isLoadingSecret = false
                }
            } catch {
                await MainActor.run {
                    self.mnemonic = nil
                    self.isLoadingSecret = false
                }
            }
        }
    }

}

#Preview {
    SignupSecretView()
}
