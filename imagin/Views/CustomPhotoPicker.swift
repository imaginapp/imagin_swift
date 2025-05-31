//
//  ImagePicker.swift
//  imagin
//
//  Created by Nicholas Terrell on 27/5/2025.
//

import SwiftUI
import PhotosUI

struct CustomPhotoPicker: View {
    @Binding var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            HStack {
                Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.imaginBlack)
                Text(selectedImage == nil ? "Add Avatar" : "Edit Avatar").foregroundColor(.imaginBlack)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.thinMaterial)
            .cornerRadius(20)
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
