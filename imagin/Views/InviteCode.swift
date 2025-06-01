//
//  InviteCode.swift
//  imagin
//
//  Created by Nicholas Terrell on 1/6/2025.
//

import SwiftUI

struct InviteCodeInputView: View {
    @Binding var code: String
    let maxLength: Int
    let isFocused: FocusState<Bool>.Binding
    let error: Bool
    let onChange: (String) -> Void
    let onSubmit: (String) -> Void

    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                ForEach(0..<maxLength, id: \.self) { index in
                    let isFilled = index < code.count
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                error
                                    ? Color.red
                                    : (isFocused.wrappedValue
                                        ? Color.imaginBlack : Color.gray),
                                lineWidth: 1
                            )
                            .frame(width: 40, height: 45)
                        if isFilled {
                            let charIndex = code.index(
                                code.startIndex,
                                offsetBy: index
                            )
                            Text(String(code[charIndex]))
                                .font(.system(size: 24, weight: .medium))
                        }
                    }
                }
            }
            .contentShape(Rectangle()) // Makes the entire HStack tappable
            .onTapGesture {
                isFocused.wrappedValue = true
            }

            // Place TextField last so it's on top
            TextField(
                "",
                text: Binding(
                    get: { code },
                    set: { newValue in
                        let filtered = newValue.uppercased().filter {
                            $0.isLetter || $0.isNumber
                        }
                        code = String(filtered.prefix(maxLength))
                        onChange(code)
                    }
                )
            )
            .focused(isFocused)
            .keyboardType(.asciiCapable)
            .textContentType(.oneTimeCode)
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled(true)
            .submitLabel(.done)
            .frame(width: 280, height: 60)
            .opacity(0)
            .onSubmit { onSubmit(code) }
            .accessibilityLabel("Invite code input")
            .accessibilityHint("Enter your \(maxLength)-character invite code")
        }
        .frame(height: 60)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var code: String = ""
        @FocusState var isFocused: Bool

        var body: some View {
            InviteCodeInputView(
                code: $code,
                maxLength: 6,
                isFocused: $isFocused,
                error: false,
                onChange: { _ in },
                onSubmit: { _ in }
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
