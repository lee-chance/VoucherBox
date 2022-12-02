//
//  Voucher.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation

struct Voucher: Identifiable {
    let id: String
    var name: String
    var redemptionStore: String
    var code: String
    var validationDate: Date
    let type: VoucherType?
    let imageURLString: String
    let isUsed: Bool
    
    var imageURL: URL? {
        URL(string: imageURLString)
    }
    
    var expirationDays: Int {
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let today = Calendar.current.date(from: todayComponents) ?? Date()
        let day = Calendar.current.dateComponents([.day], from: today, to: validationDate).day ?? 0
        if today > validationDate {
            return day - 1
        } else {
            return day
        }
    }
    
    enum VoucherType: String {
        case kakaotalk
        case inumber
        case giftishow
    }
    
    static var dummy: Voucher {
        Voucher(
            id: "",
            name: "",
            redemptionStore: "",
            code: "",
            validationDate: Date(),
            type: nil,
            imageURLString: "",
            isUsed: false
        )
    }
}

extension Voucher {
    func set(id: String? = nil, name: String? = nil, redemptionStore: String? = nil, code: String? = nil, validationDate: Date? = nil, imageURLString: String? = nil, isUsed: Bool? = nil) -> Voucher {
        var tempVoucher = self
        
        if let id {
            tempVoucher = Voucher(id: id, name: self.name, redemptionStore: self.redemptionStore, code: self.code, validationDate: self.validationDate, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let name {
            tempVoucher = Voucher(id: tempVoucher.id, name: name, redemptionStore: self.redemptionStore, code: self.code, validationDate: self.validationDate, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let redemptionStore {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: redemptionStore, code: self.code, validationDate: self.validationDate, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let code {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: code, validationDate: self.validationDate, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let validationDate {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: tempVoucher.code, validationDate: validationDate, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let imageURLString {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: tempVoucher.code, validationDate: tempVoucher.validationDate, type: self.type, imageURLString: imageURLString, isUsed: self.isUsed)
        }
        
        if let isUsed {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: tempVoucher.code, validationDate: tempVoucher.validationDate, type: self.type, imageURLString: tempVoucher.imageURLString, isUsed: isUsed)
        }
        
        return tempVoucher
    }
    
    func set(type: VoucherType?) -> Voucher {
        Voucher(id: self.id, name: self.name, redemptionStore: self.redemptionStore, code: self.code, validationDate: self.validationDate, type: type, imageURLString: self.imageURLString, isUsed: self.isUsed)
    }
}

extension Voucher {
    var data: [String : Any] {
        [
            "id" : id,
            "name" : name,
            "redemptionStore" : redemptionStore,
            "code" : code,
            "validationDate" : validationDate,
            "type" : type?.rawValue ?? NSNull(),
            "imageURLString" : imageURLString,
            "timestamp" : FirestoreManager.timestamp,
            "isUsed" : false
        ]
    }
}
