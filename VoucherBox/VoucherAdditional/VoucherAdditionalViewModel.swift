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
    func insertNewVoucherToFirestore(voucher: Voucher)
}

final class VoucherAdditionalViewModel: VoucherAdditionalViewModelProtocol {
    let userInfo: PVUser
    var voucherImage: ClovaOCRImage? {
        didSet {
            guard
                let voucherImage,
                let fields = voucherImage.fields,
                let template = voucherImage.matchedTemplate
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.voucher = self.voucher
                    .set(name: fields.first { $0.type == .productName }?.inferText ?? "")
                    .set(redemptionStore: fields.first { $0.type == .redemptionStore }?.inferText ?? "")
                    .set(code: fields.first { $0.type == .voucherCode }?.inferText ?? "")
                    .set(validationDateString: fields.first { $0.type == .validationDateString }?.inferText ?? "")
                    .set(type: template.type.toVoucherType)
            }
        }
    }
    @Published var voucher: Voucher = Voucher.dummy.set(id: UUID().uuidString)
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
    }
    
    
    // MARK: - Method(s)
    
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
        
        let tempVoucher = voucher
        
        FirebaseStorageManager.uploadImage(image: image, to: path) { [weak self] url in
            guard let url else { return }
            let path = url.absoluteString
            
            self?.scanImage(path: path)
            self?.voucher = tempVoucher
                .set(imageURLString: path)
        }
    }
    
    private func scanImage(path: String) {
        Task {
            do {
                guard let ocrResponse = try await ClovaOCRManager.scan(imageURLString: path) else { return }
                
                let image = ocrResponse.images[0]
                
                switch image.inferResult {
                case .success:
                    voucherImage = ocrResponse.images[0]
                case .failure:
                    break
                }
            }
        }
    }
    
    func insertNewVoucherToFirestore(voucher: Voucher) {
        FirestoreManager
            .reference(path: .users)
            .reference(path: userInfo.uid)
            .reference(path: .vouchers)
            .reference(path: voucher.id)
            .setData(voucher.data)
    }
}
