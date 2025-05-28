//
//  ContentView.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import SwiftUI
import stellarsdk

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    @State private var versionInfo: String?
    @State private var mnemonic: String?
    @State private var accountID: String?
    @State private var isLoadingVersion: Bool = false
    @State private var isLoadingAccount: Bool = false

    var body: some View {
        BackgroundView {
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Spacer()
                versionView()
                accountView()
            }
            .padding()
        }.onAppear {
            loadStoredAccount()
        }
    }

    private func versionView() -> some View {
        return Group {
            Button(action: {
                fetchVersion()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.imaginBlack)
                    Text("Get Version")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.imaginBlack)
                    Spacer()
                }
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(8)
            
            }
            if let versionInfo {
                Text("Version: \(versionInfo)")
                    .foregroundColor(.imaginWhite)
                    .padding()
            } else {
                Text(" ").padding()
            }
        }
    }

    private func accountView() -> some View {
        return Group {
            Button(action: {
                accountID == nil ? generateAccount() : deleteAccount()

            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.imaginBlack)
                    Text(accountID == nil ? "Create Account" : "Delete Account")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.imaginBlack)
                }
                .padding()
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(8)
            }
            if let accountID {
                Text("AccountID: \(accountID)")
                    .foregroundColor(.imaginWhite)
                    .padding()
            }
            if let mnemonic {
                Text("Mnemonic: \(mnemonic)")
                    .foregroundColor(.imaginWhite)
                    .padding()
            }
        }
    }

    private func fetchVersion() {
        isLoadingVersion = true

        Task {
            do {
                let response = try await appState.grpcClient.version()
                await MainActor.run {
                    self.versionInfo = response.id
                    self.isLoadingVersion = false
                }
            } catch {
                await MainActor.run {
                    self.versionInfo = "Error: \(error.localizedDescription)"
                    self.isLoadingVersion = false
                }
            }
        }
    }

    private func generateAccount() {
        isLoadingAccount = true

        Task {
            let newMnemonic = WalletUtils.generate24WordMnemonic()

            do {
                try AccountKeys.storeDefaultmnemonic(newMnemonic)

                let keyPair = try AccountKeys.getDefaultAccount()

                await MainActor.run {
                    self.mnemonic = newMnemonic
                    self.accountID = keyPair.accountId
                    self.isLoadingAccount = false
                }
            } catch {
                await MainActor.run {
                    self.accountID = "Error: \(error.localizedDescription)"
                    self.mnemonic = nil
                    self.isLoadingAccount = false
                }
            }
        }
    }

    private func deleteAccount() {
        isLoadingAccount = true

        Task {
            do {
                if let accountID {
                    try AccountKeys.deleteAccount(accountID: accountID)
                    await MainActor.run {
                        self.mnemonic = nil
                        self.accountID = nil
                        self.isLoadingAccount = false
                    }
                }
            } catch {
                // failed to delete account
                await MainActor.run {
                    self.accountID = "Error: \(error.localizedDescription)"
                    self.mnemonic = nil
                    self.isLoadingAccount = false
                }
            }
        }
    }

    private func loadStoredAccount() {
        isLoadingAccount = true

        Task {
            do {
                if AccountKeys.hasDefaultAccount() {
                    let keyPair = try AccountKeys.getDefaultAccount()

                    await MainActor.run {
                        self.accountID = keyPair.accountId
                        self.isLoadingAccount = false
                    }
                }
            } catch AccountKeysError.accountNotFound {
                // no account
                self.mnemonic = nil
                self.accountID = nil
                return
            } catch {
                // failed to load account
                await MainActor.run {
                    self.accountID = "Error: \(error.localizedDescription)"
                    self.mnemonic = nil
                    self.isLoadingAccount = false
                }
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AppState(host: "devin.imag.in", port: 443))
}
