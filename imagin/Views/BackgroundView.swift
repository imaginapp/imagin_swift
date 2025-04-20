//
//  background.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    var backgroundColor: Color
    let content: Content

    init(backgroundColor: Color = Color.imaginBlack, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            content
        }
    }
}
