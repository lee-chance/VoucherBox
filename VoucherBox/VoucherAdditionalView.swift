//
//  VoucherAdditionalView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/20.
//

import SwiftUI
import FirebaseStorage

struct VoucherAdditionalView: View {
    @StateObject private var vm = ViewModel()
    
    @State private var showImagePicker: Bool = false
    @State private var isLoading: Bool = false
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 300)
            } else {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 200, height: 300)
                } else {
                    Button(action: {
                        // send image
//                        showImagePicker = true
                        
                        // load image
                        isLoading = true
                        vm.getImage {
                            isLoading = false
                            uiImage = $0
                        }
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .frame(width: 200, height: 300)
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        vm.uploadImage(image: uiImage)
                    }, content: {
                        ImagePicker(image: $uiImage)
                    })
                }
            }
        }
        .border(Color.blue)
    }
}

struct VoucherAdditionalView_Previews: PreviewProvider {
    static var previews: some View {
        VoucherAdditionalView()
    }
}

final class ViewModel: ObservableObject {
    func getImage(completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("sample.jpg")
        let path = "\(Bundle.main.firebaseStorageURLPrefix)\(spaceRef.fullPath)"
        FirebaseStorageManager.downloadImage(urlString: path) { uiimage in
            completion(uiimage)
        }
    }
    
    func uploadImage(image: UIImage?) {
        guard let image else { return }
        FirebaseStorageManager.uploadImage(image: image, pathRoot: "") { url in
            print("ur: \(url)")
        }
    }
}
