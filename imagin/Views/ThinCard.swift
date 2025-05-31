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
                .fixedSize(horizontal: false, vertical: true)
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
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct InfoCard<Content: View>: View {
    let title: String
    let icon: String?
    let content: Content

    init(
        icon: String,
        title: String,
        @ViewBuilder content: () -> Content,
    ) {
        self.content = content()
        self.title = title
        self.icon = icon
    }

    init(
        title: String,
        @ViewBuilder content: () -> Content,
    ) {
        self.content = content()
        self.title = title
        self.icon = nil
    }

    var body: some View {
        ThinCard {
            VStack {
                if icon != nil {
                    Image(systemName: icon!)
                        .font(.title2)
                        .foregroundColor(.imaginBlack)
                        .padding(.bottom, 2)
                }
                Text(title)
                    .font(.title2).fontWeight(.semibold)
                    .foregroundStyle(Color.imaginBlack)
                    .padding(.bottom, 4)

                content
                    .fixedSize(horizontal: false, vertical: true)

            }.padding()
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
            UltraThinCard(
                content: {
                    VStack {
                        Image("LogoBlack")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                },
                withBorder: false
            )
            .padding()

            InfoCard(
                icon: "text.document",
                title: "Title of InfoCard",
                content: {
                    VStack {
                        Text(
                            "By Creating an account you agree to our Terms of Service."
                        )
                        .multilineTextAlignment(.center)

                        SmallPillButton(
                            image: "text.document",
                            text: "View Terms of Service"
                        ) {
                            print("Pressed!!")
                        }

                    }
                }
            ).padding()
        }
    }
}
