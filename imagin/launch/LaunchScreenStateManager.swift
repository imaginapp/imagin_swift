//
//  LaunchScreenStateManager.swift
//  imagin
//
//  Created by Nicholas Terrell on 7/6/2025.
//

import Foundation

final class LaunchScreenStateManager: ObservableObject {

    @MainActor @Published private(set) var state: LaunchScreenStep = .loading

    @MainActor func loading() {
        Task {
            self.state = .loading
        }
    }

    @MainActor func finished() {
        Task {
            self.state = .closing

            try? await Task.sleep(for: .milliseconds(700))
            
            self.state = .finished
        }
    }

    @MainActor func set(state newState: LaunchScreenStep) {
        state = newState
    }
}

