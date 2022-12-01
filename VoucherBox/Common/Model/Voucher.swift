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
    var validationDateString: String
    let type: VoucherType?
    let imageURLString: String
    let isUsed: Bool
    
    var imageURL: URL? {
        URL(string: imageURLString)
    }
    
//    var validationDate: Date {
//
//    }
    
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
            validationDateString: "",
            type: nil,
            imageURLString: "",
            isUsed: false
        )
    }
}

extension Voucher {
    func set(id: String? = nil, name: String? = nil, redemptionStore: String? = nil, code: String? = nil, validationDateString: String? = nil, imageURLString: String? = nil, isUsed: Bool? = nil) -> Voucher {
        var tempVoucher = self
        
        if let id {
            tempVoucher = Voucher(id: id, name: self.name, redemptionStore: self.redemptionStore, code: self.code, validationDateString: self.validationDateString, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let name {
            tempVoucher = Voucher(id: tempVoucher.id, name: name, redemptionStore: self.redemptionStore, code: self.code, validationDateString: self.validationDateString, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let redemptionStore {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: redemptionStore, code: self.code, validationDateString: self.validationDateString, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let code {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: code, validationDateString: self.validationDateString, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let validationDateString {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: tempVoucher.code, validationDateString: validationDateString, type: self.type, imageURLString: self.imageURLString, isUsed: self.isUsed)
        }
        
        if let imageURLString {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: tempVoucher.code, validationDateString: tempVoucher.validationDateString, type: self.type, imageURLString: imageURLString, isUsed: self.isUsed)
        }
        
        if let isUsed {
            tempVoucher = Voucher(id: tempVoucher.id, name: tempVoucher.name, redemptionStore: tempVoucher.redemptionStore, code: tempVoucher.code, validationDateString: tempVoucher.validationDateString, type: self.type, imageURLString: tempVoucher.imageURLString, isUsed: isUsed)
        }
        
        return tempVoucher
    }
    
    func set(type: VoucherType?) -> Voucher {
        Voucher(id: self.id, name: self.name, redemptionStore: self.redemptionStore, code: self.code, validationDateString: self.validationDateString, type: type, imageURLString: self.imageURLString, isUsed: self.isUsed)
    }
}

extension Voucher {
    var data: [String : Any] {
        [
            "id" : id,
            "name" : name,
            "redemptionStore" : redemptionStore,
            "code" : code,
            "validationDateString" : validationDateString,
            "type" : type?.rawValue ?? NSNull(),
            "imageURLString" : imageURLString,
            "timestamp" : FirestoreManager.timestamp,
            "isUsed" : false
        ]
    }
}
