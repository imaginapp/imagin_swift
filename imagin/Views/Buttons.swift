//
//  ThinCard.swift
//  imagin
//
//  Created by Nicholas Terrell on 25/5/2025.
//

import SwiftUI

struct CloseXButton: View {
    let color: Color
    let action: () -> Void
    let background: Material

    init(
        color: Color = .imaginBlack,
        background: Material = .thinMaterial,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.action = action
        self.background = background
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "xmark")
                    .font(.system(size: 20).bold())
                    .foregroundColor(color)
            }
            .padding()
            .background(background)
            .cornerRadius(45)
        }
    }
}

struct FullWidthPillButton: View {
    let image: String?
    let text: String
    let color: Color
    let action: () -> Void
    let background: Material

    init(
        image: String? = nil,
        text: String,
        color: Color = .imaginBlack,
        background: Material = .thinMaterial,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.text = text
        self.color = color
        self.action = action
        self.background = background
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if image != nil {
                    Image(systemName: image!)
                        .font(.system(size: 20).bold())
                        .foregroundColor(color)
                }
                Text(text)
                    .font(.system(size: 20).bold())
                    .foregroundColor(color)
                Spacer()
            }
            .padding()
            .background(background)
            .cornerRadius(45)
        }
    }
}

struct PillButton: View {
    let image: String?
    let text: String
    let color: Color
    let action: () -> Void
    let background: Material

    init(
        image: String? = nil,
        text: String,
        color: Color = .imaginBlack,
        background: Material = .thinMaterial,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.text = text
        self.color = color
        self.action = action
        self.background = background
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if image != nil {
                    Image(systemName: image!)
                        .font(.system(size: 20).bold())
                        .foregroundColor(color)
                }
                Text(text)
                    .font(.system(size: 20).bold())
                    .foregroundColor(color)
            }
            .padding()
            .background(background)
            .cornerRadius(45)
        }
    }
}

#Preview {
    BackgroundView(linearGradient: Gradient.threeColorAngled) {
        VStack {
            CloseXButton(
                action: { print("X pressed") }
            ).padding()
            FullWidthPillButton(
                text: "Press Me!",
                action: { print("full width pressed") }
            )
            .padding()
            FullWidthPillButton(
                image: "star",
                text: "Press Me!",
                action: { print("full width icon pressed") }
            ).padding()
            PillButton(
                text: "Press Me!",
                action: { print("pill pressed") }
            ).padding()
            PillButton(
                image: "star",
                text: "Press Me!",
                action: { print("image pill pressed") }
            ).padding()
        }
    }
}
