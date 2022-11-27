//
//  PVUser.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import Foundation
import FirebaseAuth

typealias PVUser = User

extension PVUser {
    var data: [String : Any] {
        isAnonymous ? anonymousData : emailData
    }
    
    private var anonymousData: [String : Any] {
        [
            "id" : uid,
            "providerID" : providerID,
            "displayName" : displayName ?? NSNull(),
            "isAnonymous" : isAnonymous
        ]
    }
    
    private var emailData: [String : Any] {
        [
            "id" : uid,
            "providerID" : providerID,
            "displayName" : displayName ?? NSNull(),
            "email" : email ?? NSNull(),
            "isEmailVerified" : isEmailVerified
        ]
    }
}
