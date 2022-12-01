//
//  FirestoreManager.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    private static let db = Firestore.firestore()
    
    static let timestamp = Timestamp()
    
    static var listenerByLabel: [String : ListenerRegistration] = [:]
    
    static func reference(path collection: FirestoreManager.Collection) -> CollectionReference {
        db.collection(collection.name)
    }
}

extension CollectionReference {
    func reference(path: String) -> DocumentReference {
        document(path)
    }
}

extension DocumentReference {
    func reference(path collection: FirestoreManager.Collection) -> CollectionReference {
        self.collection(collection.name)
    }
}



// MARK: FirestoreManager + VoucherBox
extension FirestoreManager {
    enum Collection {
        case users, vouchers
        
        var name: String {
            switch self {
            case .users:
                return "users"
            case .vouchers:
                return "vouchers"
            }
        }
    }
}

extension QueryDocumentSnapshot {
    func toVoucher(id: String) -> Voucher {
        let data = data()
        let name = data["name"] as? String ?? "name error"
        let redemptionStore = data["redemptionStore"] as? String ?? "redemptionStore error"
        let code = data["code"] as? String ?? "code error"
        let validationDate = data["validationDate"] as? Date ?? Date()
        let typeRawValue = data["type"] as? String ?? "type error"
        let imageURLString = data["imageURLString"] as? String ?? "imageURLString error"
        let isUsed = data["isUsed"] as? Bool ?? false
        
        return Voucher(id: id, name: name, redemptionStore: redemptionStore, code: code, validationDateString: "\(validationDate)", type: Voucher.VoucherType(rawValue: typeRawValue), imageURLString: imageURLString, isUsed: isUsed)
    }
}
