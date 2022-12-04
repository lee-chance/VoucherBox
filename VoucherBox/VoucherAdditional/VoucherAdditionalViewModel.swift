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
    var canSubmit: Bool { get }
    
    init(userInfo: PVUser)
    
    func getImage(path: String, completion: @escaping (UIImage?) -> Void)
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
                    .set(name: fields.scannedText(of: .productName))
                    .set(redemptionStore: fields.scannedText(of: .redemptionStore))
                    .set(code: fields.scannedText(of: .voucherCode))
                    .set(validationDate: fields.scannedText(of: .validationDateString).toDate(format: "yyyy년 MM월 dd일"))
                    .set(type: template.type.toVoucherType)
            }
        }
    }
    @Published var voucher: Voucher = Voucher(id: UUID().uuidString)
    
    var canSubmit: Bool {
        voucher.expirationDays > 0
    }
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
    }
    
    // MARK: - Method(s)
    
    func getImage(path: String, completion: @escaping (UIImage?) -> Void) {
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
