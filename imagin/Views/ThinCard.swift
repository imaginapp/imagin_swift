//
//  ThinCard.swift
//  imagin
//
//  Created by Nicholas Terrell on 25/5/2025.
//

import SwiftUI

let cardRadius: CGFloat = 25
let cardStroke: CGFloat = 2

struct ThinCard<Content: View>: View {
    let content: Content
    let withBorder: Bool
    init(
        @ViewBuilder content: () -> Content,
        withBorder: Bool = true,
    ) {
        self.content = content()
        self.withBorder = withBorder
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardRadius)
                .fill(.thinMaterial)
            if withBorder {
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(.thinMaterial, lineWidth: cardStroke)
            }
            content
        }
    }
}

struct UltraThinCard<Content: View>: View {
    let content: Content
    let withBorder: Bool
    init(
        @ViewBuilder content: () -> Content,
        withBorder: Bool = true,
    ) {
        self.content = content()
        self.withBorder = withBorder
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardRadius)
                .fill(.ultraThinMaterial)
            if withBorder {
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(.ultraThinMaterial, lineWidth: cardStroke)
            }
            content
        }
    }
}

#Preview {
    BackgroundView(linearGradient: Gradient.threeColorAngled) {
        VStack {
            ThinCard {
                VStack {
                    Image("LogoBlack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            }.padding()
            UltraThinCard {
                VStack {
                    Image("LogoBlack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            }.padding()
            UltraThinCard(content:  {
                VStack {
                    Image("LogoBlack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            }, withBorder: false).padding()
        }
    }
}
