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

    var body: some Scene {
        WindowGroup {
            SignupPageView()
                .environmentObject(appState)
        }
    }
}
