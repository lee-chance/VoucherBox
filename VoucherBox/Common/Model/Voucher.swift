//
//  Voucher.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation

struct Voucher: Identifiable, Equatable {
    let id: String
    var name: String
    var redemptionStore: String
    var code: String
    var validationDate: Date
    let type: VoucherType?
    let imageURLString: String
    let isUsed: Bool
    
    init(id: String = "", name: String = "", redemptionStore: String = "", code: String = "", validationDate: Date = Date(), type: VoucherType? = nil, imageURLString: String = "", isUsed: Bool = false) {
        self.id = id
        self.name = name
        self.redemptionStore = redemptionStore
        self.code = code
        self.validationDate = validationDate
        self.type = type
        self.imageURLString = imageURLString
        self.isUsed = isUsed
    }
    
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
}

extension Voucher {
    static func chickenDummy(validationDate: Date = .now) -> Voucher {
        Voucher(id: UUID().uuidString, name: "치킨 기프티콘", redemptionStore: "치킨집", code: "123123123", validationDate: validationDate, type: nil, imageURLString: "https://mblogthumb-phinf.pstatic.net/MjAxODA5MjhfMjI3/MDAxNTM4MTQwNjMzNzI5.c7ZF7CxdxBkwou-yz5d4JnsF1mUGeNyBKd6cM28I4Ikg.sxZ2LGLrc9sC3NBGqpAE4XqHRyFVAZJks-MRwUOShP8g.JPEG.zoqgns7549/KakaoTalk_20180928_220601336.jpg?type=w800", isUsed: false)
    }
    
    static func coffeeDummy(validationDate: Date = .now) -> Voucher {
        Voucher(id: UUID().uuidString, name: "커피", redemptionStore: "스벅", code: "123123123", validationDate: validationDate, type: nil, imageURLString: "https://mblogthumb-phinf.pstatic.net/MjAyMjA3MjBfMTA3/MDAxNjU4MjkzNjEzMTgy.MPtABQRrHCZebUsL2MH2fY-WeQ8UsbH-F506fIm3Rdsg.qCKSbWONwGwxSvdcbsLWXX5st6eiAkDvJ7-BwTQxEvQg.JPEG.superpig518/1658293585993.jpg?type=w800", isUsed: false)
    }
    
    static func iceCreamDummy(validationDate: Date = .now) -> Voucher {
        Voucher(id: UUID().uuidString, name: "ice cream", redemptionStore: "br", code: "123123123", validationDate: validationDate, type: nil, imageURLString: "https://mblogthumb-phinf.pstatic.net/MjAyMjA0MTZfMTQz/MDAxNjUwMTEyMTg1OTYx.PtTNk5aTU6mQndgeNtC8m7GxTz0x6JUA1m7ISCBuUPkg.6XeUwq_XUXGZI6ujyQHuA4NymHnypmXYl_E1oedl5pQg.JPEG.superpig518/1650112172976.jpg?type=w800", isUsed: false)
    }
    
    static var dummies: [Voucher] {
        var tempDummies = [Voucher]()
        var validationDate: Date = .now
        for i in 0..<3 {
            if i == 1 {
                validationDate = .distantPast
            } else if i == 2 {
                validationDate = .distantFuture
            }
            tempDummies.append(chickenDummy(validationDate: validationDate))
            tempDummies.append(coffeeDummy(validationDate: validationDate))
            tempDummies.append(iceCreamDummy(validationDate: validationDate))
        }
        return tempDummies.shuffled()
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
