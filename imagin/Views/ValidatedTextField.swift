//
//  ValidatedTextField.swift
//  imagin
//
//  Created by Nicholas Terrell on 1/6/2025.
//

import SwiftUI

struct ValidatedTextField: View {
    let title: String
    @Binding var text: String
    @Binding var errorMessage: String
    let validation: (String) -> String?
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(title, text: $text)
                .textFieldStyle(.roundedBorder)
                .onChange(of: text) { newValue in
                    if let error = validation(newValue) {
                        errorMessage = error
                    } else {
                        errorMessage = ""
                    }
                }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }
}
