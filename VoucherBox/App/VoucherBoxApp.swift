//
//  VoucherBoxApp.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/20.
//

import SwiftUI

@main
struct VoucherBoxApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
