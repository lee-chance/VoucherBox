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
        let store = data["store"] as? String ?? "store error"
        let validationDate = data["validationDate"] as? Date ?? Date()
        let imageURLString = data["imageURLString"] as? String ?? "imageURLString error"
        
        return Voucher(id: id, name: name, store: store, validationDate: validationDate, imageURLString: imageURLString)
    }
}
