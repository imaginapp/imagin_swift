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
                let circleDiameter = geo.size.width * 0.07

                ZStack {
                    Image("LogoWhite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height
                        )

                    // Calculate the position as a percentage of the image's size
                    let circleX = geo.size.width * 0.7616  // 75% from the left
                    let circleY = geo.size.height * 0.5427  // 55% from the top

                    Circle()
                        .fill(Color.imaginYellow)
                        .frame(
                            width: circleDiameter,
                            height: circleDiameter
                        )
                        .zIndex(3)
                        .scaleEffect(circleScale)
                        .position(x: circleX, y: circleY)

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

                        .position(x: circleX, y: circleY)
                        .onAppear {
                            withAnimation(
                                Animation.easeInOut(duration: 1)
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
        case .closing:
            if !didAnimateFinished {
                circleScale = 1.0
                withAnimation(.easeInOut(duration: 0.7)) {
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
                        step = (step == .loading) ? .finished : .loading
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
