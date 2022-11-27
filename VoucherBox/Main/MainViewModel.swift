//
//  MainViewModel.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation

protocol MainViewModelProtocol: ObservableObject {
    var userInfo: PVUser { get }
    var vouchers: [Voucher] { get set }
    
    init(userInfo: PVUser)
}

final class MainViewModel: MainViewModelProtocol {
    let userInfo: PVUser
    @Published var vouchers: [Voucher] = []
    
    init(userInfo: PVUser) {
        self.userInfo = userInfo
    }
}
