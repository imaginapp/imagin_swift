//
//  LaunchScreenView.swift
//  imagin
//
//  Created by Nicholas Terrell on 7/6/2025.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var pulseScale: CGFloat = 1.0
    @State private var circleScale: CGFloat = 1.0
    @State private var didAnimateLoading: Bool = false
    @State private var didAnimateFinished: Bool = false

    private let baseCircleSize: CGFloat = 100
    private var fullScreenScale: CGFloat {
        let screen = UIScreen.main.bounds
        let diameter = sqrt(
            screen.width * screen.width + screen.height * screen.height
        )
        return diameter / baseCircleSize
    }

    var body: some View {
        ZStack {
            Color.imaginBlack.ignoresSafeArea()

            ZStack {
                Image("LogoWhite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                Circle()
                    .fill(Color.imaginYellow)
                    .frame(width: baseCircleSize, height: baseCircleSize)
                    .scaleEffect(circleScale)
                    .zIndex(3)

                Circle()
                    .fill(Color.imaginYellow)
                    .frame(width: baseCircleSize, height: baseCircleSize)
                    .scaleEffect(pulseScale)
                    .zIndex(1)
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 0.7).repeatForever(
                                autoreverses: true
                            )
                        ) {
                            pulseScale = 2.0
                        }

                    }
            }

        }
        .onAppear {
            setupInitialState()
        }
        .onChange(of: launchScreenState.state) { newState in
            handleStepChange(newState)
        }
    }

    private func setupInitialState() {
        if launchScreenState.state == .loading {
            circleScale = fullScreenScale
            didAnimateLoading = false
            didAnimateFinished = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                handleStepChange(.loading)
            }
        }
    }

    private func handleStepChange(_ step: LaunchScreenStep) {
        switch step {
        case .loading:
            if !didAnimateLoading {
                circleScale = fullScreenScale
                withAnimation(.easeInOut(duration: 0.7)) {
                    circleScale = 1.0
                }
                didAnimateLoading = true
                didAnimateFinished = false
            }
        case .finished:
            if !didAnimateFinished {
                circleScale = 1.0
                withAnimation(.easeInOut(duration: 0.7)) {
                    circleScale = fullScreenScale
                }
                didAnimateFinished = true
                didAnimateLoading = false
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var step: LaunchScreenStep = .loading
        @ObservedObject private var launchScreenStateManager =
            LaunchScreenStateManager()

        var body: some View {
            ZStack {
                LaunchScreenView()
                    .environmentObject(launchScreenStateManager)
                    .onTapGesture {
                        step = (step == .loading) ? .finished : .loading
                        launchScreenStateManager.set(state: step)
                    }

                Text("the state is: \(launchScreenStateManager.state)")
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
