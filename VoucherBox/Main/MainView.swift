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
    @State private var selectedVoucher: Voucher?
    @State private var isProcessing = false
    
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Vouchers")
                    .font(.largeTitle)
                
                Spacer()
                
                if viewModel.userInfo.isAnonymous {
                    Button(action: {
                        CustomAlert.signupAlert { email, password in
                            guard !email.isEmpty else {
                                CustomAlert.loginErrorAlert(description: "email")
                                return
                            }
                            
                            guard !password.isEmpty else {
                                CustomAlert.loginErrorAlert(description: "password")
                                return
                            }
                            
                            isProcessing = true
                            
                            FirebaseAuthManager.registerAccount(withEmail: email, password: password) { error in
                                isProcessing = false
                                
                                if let error {
                                    CustomAlert.signupErrorAlert(description: error)
                                } else {
                                    CustomAlert.signupSuccessAlert(email: email)
                                }
                            }
                        }
                    }) {
                        Image(systemName: "person.fill.questionmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                
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
                    VoucherAdditionalView(viewModel: VoucherAdditionalViewModel(userInfo: viewModel.userInfo))
                }
            }
            
            Toggle("??????????????? ????????? ??????", isOn: $viewModel.isValidVouchers)
            
            ScrollView {
                if let vouchers = viewModel.vouchers {
                    if vouchers.count > 0 {
                        ForEach(vouchers) { voucher in
                            voucherCard(voucher)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedVoucher = voucher
                                    }
                                }
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
        .padding([.top, .horizontal])
        .overlay(
            VoucherDetailView(selectedVoucher: $selectedVoucher, userID: viewModel.userInfo.uid, animation: animation)
        )
        .processingView(isProcessing: isProcessing)
    }
    
    private func voucherCard(_ voucher: Voucher) -> some View {
        HStack {
            VoucherImage(imageURL: voucher.imageURL)
                .scaledToFit()
                .overlay(
                    ZStack {
                        Color.black
                            .opacity(voucher.isUsed ? 0.5 : 0)
                        
                        if voucher.isUsed {
                            Text("????????????")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                )
                .matchedGeometryEffect(id: voucher.id, in: animation)
            
            VStack(alignment: .leading) {
                if voucher.expirationDays > 0 {
                    Text("D-\(voucher.expirationDays)")
                } else if voucher.expirationDays == 0 {
                    Text("D-Day")
                } else {
                    Text("??????????????? ?????????????????????.")
                }
                
                Text(voucher.redemptionStore)
                
                Text(voucher.name)
                
                Text(voucher.code)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

struct MainView_Previews: PreviewProvider {
    init() {
        FirebaseAuthManager.signIn()
    }
    
    static var previews: some View {
        if let user = FirebaseAuthManager.currentUser {
            MainView(viewModel: MockMainViewModel(userInfo: user))
        }
    }
}
