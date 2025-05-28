//
//  background.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    // Using an enum to handle either solid color or gradient
    enum Background {
        case solid(Color)
        case gradient(Gradient)
        case linearGradient(LinearGradient)
    }

    var background: Background
    let content: Content

    // Init with solid color (for backward compatibility)
    init(backgroundColor: Color = Color.imaginBlack, @ViewBuilder content: () -> Content) {
        self.background = .solid(backgroundColor)
        self.content = content()
    }

    // New init with gradient
    init(gradient: Gradient, @ViewBuilder content: () -> Content) {
        self.background = .gradient(gradient)
        self.content = content()
    }
    
    // New init with gradient
    init(linearGradient: LinearGradient, @ViewBuilder content: () -> Content) {
        self.background = .linearGradient(linearGradient)
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Switch between color and gradient based on the background type
            switch background {
            case .solid(let color):
                color.ignoresSafeArea()
            case .gradient(let gradient):
                LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            case .linearGradient(let linearGradient):
                linearGradient
                .ignoresSafeArea()
            }

            content
        }
    }
}
