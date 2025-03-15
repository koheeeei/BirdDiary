//
//  Untitled.swift
//  BirdDiary
//
//  Created by KI on 2024/10/30.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }

            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
}

// ImagePickerを使用した場合のサンプル
struct ImagePickerExampleView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            Button("画像を選択") {
                showImagePicker.toggle()
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
            }
        }
        .navigationTitle("画像選択")
    }
}

struct ImagePickerExampleView_Previews: PreviewProvider {
    static var previews: some View {
        // 画像選択ビューのプレビュー
        ImagePickerExampleView()
    }
}
