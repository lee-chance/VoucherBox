//
//  RootView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/27.
//

import SwiftUI

struct RootView: View {
    @State private var userInfo: PVUser?
    @State private var didSplash = false
    
    var body: some View {
        Group {
            if let userInfo, didSplash {
                MainView(viewModel: MainViewModel(userInfo: userInfo))
            } else {
                SplashView(userInfo: $userInfo, afterAnimation: $didSplash)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            didSplash = true
                        }
                    }
            }
        }
        .onAppear {
            FirebaseAuthManager.addStateDidChangeListener { _, user in
                userInfo = user
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
