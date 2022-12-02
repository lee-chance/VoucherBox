//
//  VoucherAdditionalView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/20.
//

import SwiftUI

struct VoucherAdditionalView<ViewModel: VoucherAdditionalViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showImagePicker: Bool = false
    @State private var isLoading: Bool = false
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack {
            imageSection
            
            voucherInformationSection
            
            additionalButton
        }
    }
    
    private var imageSection: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 300)
            } else {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 200, height: 300)
                } else {
                    Button(action: {
                        // send image
                        showImagePicker = true
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .frame(width: 200, height: 300)
                            .border(Color.blue)
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        viewModel.uploadImage(image: uiImage, to: "UserVoucher/\(viewModel.userInfo.uid)")
                    }, content: {
                        ImagePicker(image: $uiImage)
                    })
                }
            }
        }
    }
    
    private var voucherInformationSection: some View {
        VStack {
            TextField("교환처", text: $viewModel.voucher.redemptionStore)
            
            TextField("쿠폰명", text: $viewModel.voucher.name)
            
            TextField("쿠폰코드번호", text: $viewModel.voucher.code)
            
            DatePicker("유효기간", selection: $viewModel.voucher.validationDate, displayedComponents: .date)
                .datePickerStyle(.compact)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    private var additionalButton: some View {
        Button(action: {
            viewModel.insertNewVoucherToFirestore(voucher: viewModel.voucher)
            dismiss()
        }) {
            Text("추가하기")
        }
        .disabled(!viewModel.canSubmit)
    }
}
