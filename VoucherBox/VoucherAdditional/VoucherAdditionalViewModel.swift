//
//  VoucherAdditionalViewModel.swift
//  VoucherBox
//
//  Created by 이창수 on 2022/11/30.
//

import SwiftUI
import FirebaseStorage

protocol VoucherAdditionalViewModelProtocol: ObservableObject {
    var userInfo: PVUser { get }
    
    init(userInfo: PVUser)
    
    func getImage(completion: @escaping (UIImage?) -> Void)
    func uploadImage(image: UIImage?, to path: String)
}

final class VoucherAdditionalViewModel: VoucherAdditionalViewModelProtocol {
    let userInfo: PVUser
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("sample.jpg")
        let path = "\(Bundle.main.firebaseStorageURLPrefix)\(spaceRef.fullPath)"
        FirebaseStorageManager.downloadImage(urlString: path) { uiimage in
            completion(uiimage)
        }
    }
    
    func uploadImage(image: UIImage?, to path: String) {
        guard let image else { return }
        FirebaseStorageManager.uploadImage(image: image, to: path) { url in
            print("ur: \(url)")
        }
    }
}
