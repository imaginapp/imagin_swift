//
//  LaunchScreenView.swift
//  imagin
//
//  Created by Nicholas Terrell on 7/6/2025.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var pulseScale: CGFloat = 1
    @State private var circleScale: CGFloat = 1
    @State private var didAnimateLoading: Bool = false
    @State private var didAnimateFinished: Bool = false

    private let baseCircleSize: CGFloat = 20
    // Ratio of the circle's diameter to the width of the logo/image area
    private let circleDiameterRatio: CGFloat = 0.07
    // X and Y ratios are the relative position of the yellow circle on the logo (as a percentage of width/height)
    private let circleXRatio: CGFloat = 0.7616 // 76% from the left
    private let circleYRatio: CGFloat = 0.5427 // 54% from the top
    private let animationDuration: Double = 0.7
    
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
            Gradient.threeColorAngled.ignoresSafeArea()

            GeometryReader { geo in
                let circleDiameter = geo.size.width * circleDiameterRatio

                ZStack {
                    Image("LogoWhite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height
                        )

                    Circle()
                        .fill(Color.imaginYellow)
                        .frame(
                            width: circleDiameter,
                            height: circleDiameter
                        )
                        .zIndex(3)
                        .scaleEffect(circleScale)
                        .position(circlePosition(in: geo.size))

                    Circle()
                        .fill(Color.imaginYellow)
                        .frame(
                            width: circleDiameter,
                            height: circleDiameter
                        )
                        .scaleEffect(pulseScale)
                        .shadow(
                            color: Color.imaginYellow.opacity(0.9),
                            radius: 12 * pulseScale
                        )
                        .shadow(
                            color: Color.imaginWhite.opacity(0.3),
                            radius: 48 * pulseScale
                        )
                        .position(circlePosition(in: geo.size))
                        .onAppear {
                            withAnimation(
                                Animation.easeInOut(duration: animationDuration)
                                    .repeatForever(
                                        autoreverses: true
                                    )
                            ) {
                                pulseScale = 1.2
                            }

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
    
    private func circlePosition(in size: CGSize) -> CGPoint {
        CGPoint(x: size.width * circleXRatio, y: size.height * circleYRatio)
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
//                circleScale = fullScreenScale
                withAnimation(.easeInOut(duration: animationDuration)) {
                    circleScale = 1.0
                }
                didAnimateLoading = true
                didAnimateFinished = false
            }
        case .closing:
            if !didAnimateFinished {
//                circleScale = 1.0
                withAnimation(.easeInOut(duration: animationDuration)) {
                    circleScale = fullScreenScale
                }
                didAnimateFinished = true
                didAnimateLoading = false
            }
        case .finished:
            break
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
                        step = (step == .loading) ? .closing : .loading
                        launchScreenStateManager.set(state: step)
                    }

                //                Text("the state is: \(launchScreenStateManager.state)")
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
