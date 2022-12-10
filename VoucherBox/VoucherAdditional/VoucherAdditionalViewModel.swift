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
    var step: Step { get set }
    var isImageUploading: Bool { get set }
    
    init(userInfo: PVUser)
    
    func uploadImage(image: UIImage?, to path: String)
    func insertNewVoucherToFirestore(voucher: Voucher)
}

extension VoucherAdditionalViewModelProtocol {
    var canSubmit: Bool {
        !voucher.redemptionStore.isEmpty
        && !voucher.name.isEmpty
        && !voucher.code.isEmpty
        && voucher.expirationDays > 0
    }
    
    func nextStep() {
        withAnimation {
            step = Step(rawValue: step.rawValue + 1) ?? .image
        }
    }
}

enum Step: Int {
    case image = 0
    case redemptionStore = 1
    case name
    case code
    case validationDate
}

final class MockVoucherAdditionalViewModel: VoucherAdditionalViewModelProtocol {
    let userInfo: PVUser
    @Published var voucher: Voucher = Voucher(id: UUID().uuidString)
    @Published var step: Step = .image
    @Published var isImageUploading: Bool = false
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
    }
    
    // MARK: - Method(s)
    
    func uploadImage(image: UIImage?, to path: String) {
        guard let image else { return }
        
        isImageUploading = true
        
        scanImage(path: path)
        voucher = voucher
            .set(imageURLString: path)
    }
    
    private func scanImage(path: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            voucherImage = ocrResponse.images[0]
            self.isImageUploading = false
            self.nextStep()
        }
    }
    
    func insertNewVoucherToFirestore(voucher: Voucher) {
        print("save to firestore: \(voucher)")
    }
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
    @Published var step: Step = .image
    @Published var isImageUploading: Bool = false
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
    }
    
    // MARK: - Method(s)
    
//    func getImage(path: String, completion: @escaping (UIImage?) -> Void) {
//        FirebaseStorageManager.downloadImage(urlString: path) { uiimage in
//            completion(uiimage)
//        }
//    }
    
    func uploadImage(image: UIImage?, to path: String) {
        guard let image else { return }
        
        DispatchQueue.main.async {
            self.isImageUploading = true
        }
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
                
                DispatchQueue.main.async {
                    self.isImageUploading = false
                    self.nextStep()
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
