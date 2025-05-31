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
            .clipShape(Circle())
        }
    }
}

struct FullWidthPillButton: View {
    let image: String?
    let text: String
    let color: Color
    let action: () -> Void
    let background: Material
    let disabled: Bool

    init(
        image: String? = nil,
        text: String,
        color: Color = .imaginBlack,
        background: Material = .thinMaterial,
        disabled: Bool = false,
        action: @escaping () -> Void,
    ) {
        self.image = image
        self.text = text
        self.color = color
        self.action = action
        self.background = background
        self.disabled = disabled
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
            .padding(.vertical, 16)
            .background(background)
            .clipShape(Capsule())
        }
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1)
    }
}

struct PillButton: View {
    let image: String?
    let text: String
    let color: Color
    let action: () -> Void
    let background: Material
    let disabled: Bool

    init(
        image: String? = nil,
        text: String,
        color: Color = .imaginBlack,
        background: Material = .thinMaterial,
        disabled: Bool = false,
        action: @escaping () -> Void,
    ) {
        self.image = image
        self.text = text
        self.color = color
        self.action = action
        self.background = background
        self.disabled = disabled
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
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(background)
            .clipShape(Capsule())
        }
        .disabled(disabled)
        .opacity(disabled ? 0.5 : 1)
    }
}

struct SmallPillButton: View {
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
                        .foregroundColor(color)
                }
                Text(text)
                    .foregroundColor(.imaginBlack)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(background)
            .clipShape(Capsule())
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
            SmallPillButton(
                text: "Press Me!",
                action: { print("pill pressed") }
            ).padding()
            SmallPillButton(
                image: "star",
                text: "Press Me!",
                action: { print("image pill pressed") }
            ).padding()
        }
    }
}
