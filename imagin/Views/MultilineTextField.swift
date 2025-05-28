//
//  MultilineTextField.swift
//  imagin
//
//  Created by Nicholas Terrell on 27/5/2025.
//

import SwiftUI
import UIKit

struct MultilineTextField: View {
    var placeholder: String
    @Binding var text: String
    @State private var isFocused: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty && !isFocused {
                // Center the placeholder text as well
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }
            
            MultilineTextViewWrapper(text: $text,   isFocused: $isFocused)
        }
    }
}

struct MultilineTextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        // Remove the background
        textView.backgroundColor = .clear
        
        // Remove padding
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        // Match default TextField font and style
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        
        // Center the text alignment
        textView.textAlignment = .center
        
        // Remove auto-correction if desired
        // textView.autocorrectionType = .no
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Only update the text if it's different to avoid cursor position reset
        if uiView.text != text {
            uiView.text = text
        }
        
        // Ensure text alignment stays centered even after updates
        uiView.textAlignment = .center
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextViewWrapper
        
        init(_ parent: MultilineTextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        // Update focus state when text view begins editing
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
        }
        
        // Update focus state when text view ends editing
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
        }
    }
}
