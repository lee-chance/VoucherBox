//
//  MainView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/20.
//

import SwiftUI

struct MainView<ViewModel: MainViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @State private var openAdditionalView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Vouchers")
                    .font(.largeTitle)
                
                Spacer()
                
                Button(action: {
                    FirebaseAuthManager.signOut()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Button(action: {
                    openAdditionalView = true
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .sheet(isPresented: $openAdditionalView) {
                    VoucherAdditionalView()
                }
            }
            
            ScrollView {
                if let vouchers = viewModel.vouchers {
                    if vouchers.count > 0 {
                        ForEach(vouchers) { voucher in
                            voucherCard(voucher)
                        }
                    } else {
                        Text("Need to add new voucher")
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .padding()
    }
    
    private func voucherCard(_ voucher: Voucher) -> some View {
        HStack {
            Image(systemName: "flame.fill")
            
            VStack(alignment: .leading) {
                Text(voucher.name)
                
                Text(voucher.validationDate.description)
                
                Text(voucher.store)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .border(Color.red)
    }
}
