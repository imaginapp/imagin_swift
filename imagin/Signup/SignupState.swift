//
//  SignupState.swift
//  imagin
//
//  Created by Nicholas Terrell on 31/5/2025.
//

import Foundation
import SwiftUI

class SignupState: ObservableObject {

    // Navigation
    @Published var navigationPath = NavigationPath()
    @Published var currentStep: SignupStep = .inviteCode

    // invite
    @Published var inviteCode: String?

    // secret
    @Published var mnemonic: String?

    // profile
    @Published var name: String?
    @Published var aboutMe: String?
    @Published var avatarPath: String?

    enum SignupStep: String, CaseIterable, Hashable {
        case inviteCode = "invite"
        case profile = "profile"
        case secret = "secret"
        case complete = "complete"
    }

    func navigateToNext() {
        switch currentStep {
        case .inviteCode:
            currentStep = .secret
            navigationPath.append(SignupStep.secret)
        case .secret:
            currentStep = .profile
            navigationPath.append(SignupStep.profile)
        case .profile:
            currentStep = .complete
            navigationPath.append(SignupStep.complete)
        case .complete:
            break
        }
    }

    func navigateToPrev() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
        switch currentStep {
        case .complete:
            currentStep = .profile
        case .profile:
            currentStep = .secret
        case .secret:
            currentStep = .inviteCode
        case .inviteCode:
            break
        }
    }

}
