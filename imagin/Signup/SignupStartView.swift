//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupStartView: View {
    @StateObject private var signupState = SignupState()
    var onComplete: (() -> Void)? = nil
    
    var body: some View {
        NavigationStack(path: $signupState.navigationPath) {
            SignupInviteCodeView()
                .environmentObject(signupState)
                .navigationDestination(for: SignupState.SignupStep.self) {
                    step in
                    switch step {
                    case .inviteCode:
                        SignupInviteCodeView()
                            .environmentObject(signupState)
                    case .profile:
                        SignupProfileView()
                            .environmentObject(signupState)
                    case .secret:
                        SignupSecretView()
                            .environmentObject(signupState)
                    case .complete:
                        SignupCompleteView(onComplete: onComplete)
                            .environmentObject(signupState)
                    }
                }
        }
    }
}
#Preview {
    SignupStartView()
}
