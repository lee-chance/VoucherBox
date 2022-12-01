//
//  MainViewModel.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation

protocol MainViewModelProtocol: ObservableObject {
    var userInfo: PVUser { get }
    var vouchers: [Voucher]? { get set }
    
    init(userInfo: PVUser)
}

final class MainViewModel: MainViewModelProtocol {
    let userInfo: PVUser
    @Published var vouchers: [Voucher]?
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
        InitUserDataFromFirestore(userInfo: userInfo)
        fetchVouchersFromFirestore(userID: userInfo.uid)
    }
    
    deinit {
        FirestoreManager.listenerByLabel["MAIN_VOUCHERS"]?.remove()
    }
    
    private func fetchVouchersFromFirestore(userID: String) {
        FirestoreManager.listenerByLabel["MAIN_VOUCHERS"] = FirestoreManager
            .reference(path: .users)
            .reference(path: userID)
            .reference(path: .vouchers)
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
                self?.vouchers = vouchers
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
