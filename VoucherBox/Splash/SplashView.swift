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
    
    var body: some View {
        VStack {
            Text("Let's Pocket Voucher!")
            
            if userInfo == nil, afterAnimation {
                Button(action: {}) {
                    Text("login to email")
                }
                
                Button(action: {
                    FirebaseAuthManager.signIn()
                }) {
                    Text("login to guest")
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(userInfo: .constant(nil), afterAnimation: .constant(true))
    }
}
