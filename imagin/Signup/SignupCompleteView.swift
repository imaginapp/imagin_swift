//
//  SignupView.swift
//  imagin
//
//  Created by Nicholas Terrell on 24/5/2025.
//

import SwiftUI

struct SignupCompleteView: View {
    @EnvironmentObject var signupState: SignupState
    @EnvironmentObject var appState: AppState

    // this callback closes the fullScreenCover view
    var onComplete: (() -> Void)? = nil

    enum SignupStatus {
        case loading
        case failed(error: String)
        case complete
    }

    @State private var status: SignupStatus = .loading

    var body: some View {
        BackgroundView(linearGradient: Gradient.threeColorAngled) {
            VStack {
                switch status {
                case .loading:
                    completingOrderCard()
                case .failed(let error):
                    failedOrderCard(error: error)
                case .complete:
                    setupCompleteCard()
                }

                // For demo/testing: buttons to toggle status
                PillButton(
                    text: "Set Loading",
                    action: { withAnimation { status = .loading } }
                )
                PillButton(
                    text: "Set Failed",
                    action: {
                        withAnimation {
                            status = .failed(
                                error:
                                    "Something went wrong, try again!"
                            )
                        }
                    }
                )
                PillButton(
                    text: "Set Complete",
                    action: { withAnimation { status = .complete } }
                )

            }
            .padding()

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // go to prev signup step
                    signupState.navigateToPrev()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 16).bold())
                            .foregroundColor(.imaginBlack)
                    }
                    .padding(10)
                    .background(.thinMaterial)
                    .clipShape(Circle())
                }
                .disabled(isNotFailed())
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    done()
                }) {
                    Text("Done")
                        .font(.system(size: 16).bold())
                        .foregroundColor(.imaginBlack)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }
                .disabled(isNotComplete())
            }
        }
    }

    private func done() {
        onComplete?()
    }

    func isNotComplete() -> Bool {
        if case .complete = status {
            return false
        }

        return true
    }

    func isNotFailed() -> Bool {
        if case .failed = status {
            return false
        }
        return true
    }

    func completingOrderCard() -> some View {
        return ThinCard {
            VStack {
                Image("LogoBlack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250.0)
                    .padding(.bottom)
                // title text
                Text("Completing signup...")
                    .font(.title)
                    .padding(.bottom, 8)
                // content text
                Text(
                    "Please wait while we complete the setup for your account. This may take a few seconds."
                ).multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .padding(.bottom, 16)

                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(
                            tint: .imaginBlack
                        )
                    )
                    .scaleEffect(2.0, anchor: .center)
                    .padding(.vertical, 18)

            }
            .padding()

        }.fixedSize(horizontal: false, vertical: true)
    }

    func failedOrderCard(error: String) -> some View {
        return ThinCard {
            VStack {
                Image("LogoBlack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250.0)
                    .padding(.bottom)
                // title text
                Text("Signup failed")
                    .font(.title)
                    .padding(.bottom, 8)
                // content text
                Text(
                    "Something went wrong while setting up your account. Try again!"
                ).multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .padding(.bottom, 16)

                Text(error).font(.body).foregroundColor(.red)

                PillButton(
                    image: "arrow.trianglehead.clockwise.rotate.90",
                    text: "Retry",
                    action: {
                        print("retry setup")
                        status = .loading
                    },
                )

            }
            .padding()

        }.fixedSize(horizontal: false, vertical: true)
    }

    func setupCompleteCard() -> some View {
        return ThinCard {
            VStack {
                Image("LogoBlack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250.0)
                    .padding(.bottom)
                // title text
                Text("Signup complete!")
                    .font(.title)
                    .padding(.bottom, 8)

                PillButton(
                    image: "checkmark",
                    text: "Done",
                    action: {
                        done()
                    },
                )

            }
            .padding()

        }.fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    SignupCompleteView(onComplete: {
        print("done!")
    })
    .environmentObject(SignupState())
    .environmentObject(AppState(host: "preview.example.com"))
}
