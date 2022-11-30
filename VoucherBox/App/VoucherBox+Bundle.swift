//
//  VoucherBox+Bundle.swift
//  VoucherBox
//
//  Created by 이창수 on 2022/11/21.
//

import Foundation

extension Bundle {
    var firebaseStorageURLPrefix: String {
        SecretKey.firebaseStorageURLPrefix.value
    }
    
    var clovaBaseURLString: String {
        SecretKey.clovaBaseURLString.value
    }
    
    var clovaDomainID: String {
        SecretKey.clovaDomainID.value
    }
    
    var clovaSignature: String {
        SecretKey.clovaSignature.value
    }
    
    var clovaPath: String {
        SecretKey.clovaPath.value
    }
    
    var clovaOCRSecret: String {
        SecretKey.clovaOCRSecret.value
    }
}

private enum SecretKey: String {
    case firebaseStorageURLPrefix = "FIREBASE_STORAGE_URL_PREFIX"
    case clovaBaseURLString = "CLOVA_BASE_URL"
    case clovaDomainID = "CLOVA_DOMAIN_ID"
    case clovaSignature = "CLOVA_SIGNATURE"
    case clovaPath = "CLOVA_PATH"
    case clovaOCRSecret = "CLOVA_OCR_SECRET"
    
    var value: String {
        let fileName = "Secret"
        let fileType = "plist"
        
        guard let file = Bundle.main.path(forResource: fileName, ofType: fileType) else { return "" }
        guard let rawData = try? Data(contentsOf: URL(filePath: file)) else { return "" }
        guard let realData = try? PropertyListSerialization.propertyList(from: rawData, format: nil) as? [String : Any] else { return "" }
        guard let value = realData[self.rawValue] as? String else { fatalError("\(fileName).\(fileType)에 \(self.rawValue)가 없습니다.") }
        return value
    }
}
