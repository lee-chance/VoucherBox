//
//  MainViewModel.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation

protocol MainViewModelProtocol: ObservableObject {
    var userInfo: PVUser { get }
    var isValidVouchers: Bool { get set }
    var vouchers: [Voucher]? { get set }
    
    init(userInfo: PVUser)
}

final class MockMainViewModel: MainViewModelProtocol {
    let userInfo: PVUser
    private var fetchedVouchers: [Voucher]? {
        didSet { reloadVouchers() }
    }
    @Published var isValidVouchers: Bool = true {
        didSet { reloadVouchers() }
    }
    @Published var vouchers: [Voucher]?
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
        fetchVouchers()
    }
    
    private func reloadVouchers() {
        var tempVouchers = fetchedVouchers
        
        // 필터링
        if isValidVouchers {
            tempVouchers = tempVouchers?
                .filter { !$0.isUsed }
                .filter { $0.expirationDays >= 0 }
        }
        
        // 정렬
        tempVouchers?.sort { $0.expirationDays < $1.expirationDays }
        
        vouchers = tempVouchers
    }
    
    private func fetchVouchers() {
        fetchedVouchers = Voucher.dummies
    }
}

final class MainViewModel: MainViewModelProtocol {
    let userInfo: PVUser
    private var fetchedVouchers: [Voucher]? {
        didSet { reloadVouchers() }
    }
    @Published var isValidVouchers: Bool = true {
        didSet { reloadVouchers() }
    }
    @Published var vouchers: [Voucher]?
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
        InitUserDataFromFirestore(userInfo: userInfo)
        fetchVouchersFromFirestore(userID: userInfo.uid)
    }
    
    deinit {
        FirestoreManager.listenerByLabel["MAIN_VOUCHERS"]?.remove()
    }
    
    private func reloadVouchers() {
        var tempVouchers = fetchedVouchers
        
        // 필터링
        if isValidVouchers {
            tempVouchers = tempVouchers?
                .filter { !$0.isUsed }
                .filter { $0.expirationDays >= 0 }
        }
        
        vouchers = tempVouchers
    }
    
    private func fetchVouchersFromFirestore(userID: String) {
        FirestoreManager.listenerByLabel["MAIN_VOUCHERS"] = FirestoreManager
            .reference(path: .users)
            .reference(path: userID)
            .reference(path: .vouchers)
            .order(by: "validationDate")
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let querySnapshot else {
                    print("Error: Query snapshot is nil")
                    return
                }
                
                let vouchers = querySnapshot.documents.map { $0.toVoucher(id: $0.documentID) }
                self?.fetchedVouchers = vouchers
            }
    }
    
    private func InitUserDataFromFirestore(userInfo: PVUser) {
        FirestoreManager
            .reference(path: .users)
            .whereField("id", isEqualTo: userInfo.uid)
            .getDocuments { [weak self] querySnapshot, error in
                if let error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                self?.upsertUserDataToFirestore(userInfo: userInfo)
            }
    }
    
    private func upsertUserDataToFirestore(userInfo: PVUser) {
        FirestoreManager
            .reference(path: .users)
            .reference(path: userInfo.uid)
            .setData(userInfo.data)
    }
}
