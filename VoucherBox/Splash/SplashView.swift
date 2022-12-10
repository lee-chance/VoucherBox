//
//  SplashView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import SwiftUI

struct SplashView: View {
    @Binding var userInfo: PVUser?
    @Binding var afterAnimation: Bool
    @State private var isProcessing = false
    
    var body: some View {
        VStack {
            Text("Let's Pocket Voucher!")
            
            if userInfo == nil, afterAnimation {
                loginToEmail
                
                loginToGuest
            }
        }
        .processingView(isProcessing: isProcessing)
    }
    
    private var loginToEmail: some View {
        Button(action: {
            CustomAlert.loginAlert { email, password in
                guard !email.isEmpty else {
                    CustomAlert.loginErrorAlert(description: "email")
                    return
                }
                
                guard !password.isEmpty else {
                    CustomAlert.loginErrorAlert(description: "password")
                    return
                }
                
                isProcessing = true
                
                FirebaseAuthManager.signIn(withEmail: email, password: password) { error in
                    isProcessing = false
                    
                    if let error {
                        CustomAlert.loginErrorAlert(description: error)
                    }
                }
            }
        }) {
            Text("login to email")
        }
    }
    
    private var loginToGuest: some View {
        Button(action: {
            isProcessing = true
            
            FirebaseAuthManager.signIn { error in
                isProcessing = false
                
                if let error {
                    CustomAlert.loginErrorAlert(description: error)
                }
            }
        }) {
            Text("login to guest")
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(userInfo: .constant(nil), afterAnimation: .constant(true))
    }
}
