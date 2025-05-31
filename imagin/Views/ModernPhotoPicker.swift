//
//  ImagePicker.swift
//  imagin
//
//  Created by Nicholas Terrell on 27/5/2025.
//

import SwiftUI
import PhotosUI

struct ModernPhotoPicker: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            SmallPillButton(
                image: "person.crop.circle.badge.plus",
                text: selectedImage == nil ? "Add Avatar" : "Edit Avatar",
                action: {}
            )
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                    }
                }
            }
        }
    }
}
