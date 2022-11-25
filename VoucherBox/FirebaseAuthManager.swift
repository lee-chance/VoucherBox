//
//  FirebaseAuthManager.swift
//  VoucherBox
//
//  Created by 이창수 on 2022/11/25.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthManager {
    private static let auth = Auth.auth()
    
    static var currentUser: User? {
        auth.currentUser
    }
    
    static func addStateDidChangeListener(_ listener: @escaping (Auth, User?) -> Void) {
        Auth.auth().addStateDidChangeListener(listener)
    }
    
    static func signUp(withEmail email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("failed signing up")
                print(error.localizedDescription)
            } else {
                print("success signing up")
            }
        }
    }
    
    static func signIn() {
        auth.signInAnonymously { authResult, error in
            if let error {
                print("failed signing in")
                print(error.localizedDescription)
            } else {
                print("success signing in")
            }
        }
    }
    
    static func signIn(withEmail email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                print("failed signing in")
                print(error.localizedDescription)
            } else {
                print("success signing in")
            }
        }
    }
    
    static func signOut() {
        do {
            try auth.signOut()
            print("success signing out")
        } catch let signOutError as NSError {
            print("failed signing out: %@", signOutError)
        }
    }
}
