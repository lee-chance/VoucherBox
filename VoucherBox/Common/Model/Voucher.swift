//
//  Voucher.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation

struct Voucher: Identifiable {
    let id: String
    let name: String
    let store: String
    let validationDate: Date
    let imageURLString: String
    
    var imageURL: URL? {
        URL(string: imageURLString)
    }
}
