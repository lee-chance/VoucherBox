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
    var voucher: Voucher { get set }
    
    init(userInfo: PVUser)
    
    func getImage(completion: @escaping (UIImage?) -> Void)
    func uploadImage(image: UIImage?, to path: String)
}

final class VoucherAdditionalViewModel: VoucherAdditionalViewModelProtocol {
    let userInfo: PVUser
    var voucherImage: ClovaOCRImage? {
        didSet {
            if let voucherImage {
                DispatchQueue.main.async {
                    let voucher = Voucher(
                        id: "",
                        name: voucherImage.fields?.first(where: { $0.name == "쿠폰 이름" })?.inferText ?? "error",
                        store: voucherImage.fields?.first(where: { $0.name == "쿠폰 발행사" })?.inferText ?? "error",
                        code: voucherImage.fields?.first(where: { $0.name == "쿠폰 코드" })?.inferText ?? "error",
//                        validationDate: voucherImage.fields?.first(where: { $0.name == "유효기간" })?.inferText,
                        validationDate: .now,
                        imageURLString: ""
                    )
                    self.voucher = voucher
                }
            }
        }
    }
    @Published var voucher: Voucher = Voucher(id: "", name: "", store: "", code: "", validationDate: .now, imageURLString: "")
    
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
        
        FirebaseStorageManager.uploadImage(image: image, to: path) { [weak self] url in
            guard let url else { return }
            self?.scanImage(path: url.absoluteString)
        }
    }
    
    func scanImage(path: String) {
        Task {
            do {
                guard let ocrResponse = try await ClovaOCRManager.scan(imageURLString: path) else { return }
                voucherImage = ocrResponse.images[0]
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("catch error: ", error)
            }
        }
    }
}
