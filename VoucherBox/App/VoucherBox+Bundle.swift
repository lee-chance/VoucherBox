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
}

private enum SecretKey: String {
    case firebaseStorageURLPrefix = "FIREBASE_STORAGE_URL_PREFIX"
    
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
