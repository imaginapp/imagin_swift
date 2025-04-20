//
//  ContentView.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    @State private var versionInfo: String?
    @State private var isLoading: Bool = false

    var body: some View {
        BackgroundView {
            VStack {
                Image("LogoWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Button(action: {
                    fetchVersion()
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.imaginBlack)
                        Text("Get Version")
                            .font(.system(size: 20).bold())
                            .foregroundColor(.imaginBlack)
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
            .padding()
        }
    }

    private func fetchVersion() {
        isLoading = true

        Task {
            do {
                let response = try await appState.grpcClient.version()
                await MainActor.run {
                    self.versionInfo = response.id
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.versionInfo = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AppState(host: "devin.imag.in", port: 443))
}
