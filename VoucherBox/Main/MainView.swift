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
    
    @Namespace var animation
    
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
                    VoucherAdditionalView(viewModel: VoucherAdditionalViewModel(userInfo: viewModel.userInfo))
                }
            }
            
            Toggle("사용가능한 쿠폰만 보기", isOn: $viewModel.isValidVouchers)
            
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
                            Text("사용완료")
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
                    Text("유효기간이 만료되었습니다.")
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
