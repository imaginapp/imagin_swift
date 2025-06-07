//
//  imaginApp.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import SwiftUI

@main
struct ImaginApp: App {
    @StateObject private var appState = AppState(
        host: "devin.imag.in",
        port: 443
    )
    @StateObject var launchScreenState = LaunchScreenStateManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                SignupPageView()
                    .environmentObject(appState)

                if launchScreenState.state != .finished {
                    LaunchScreenView()
                        .environmentObject(launchScreenState)
                        .opacity(launchScreenState.state == .closing ? 0 : 1)
                        .animation(
                            .easeInOut(duration: 0.7),
                            value: launchScreenState.state
                        )
                        .onTapGesture {
                            launchScreenState.finished()
                        }
                }
            }

        }
    }
}
