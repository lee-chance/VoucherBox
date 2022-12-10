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
    @State private var uiImage: UIImage?
    
    var body: some View {
        ZStack {
            VStack {
                imageSection
                
                if viewModel.step != .image {
                    voucherInformationSection
                    
                    buttons
                }
            }
            
            if viewModel.isImageUploading {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView("Image Uploading...")
                            .progressViewStyle(.circular)
                            .foregroundColor(.white)
                            .tint(.white)
                            .scaleEffect(1.5)
                    )
                    .animation(nil, value: viewModel.step)
            }
        }
    }
    
    private var imageSection: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(32)
            } else {
                Button(action: {
                    // send image
                    showImagePicker = true
                }) {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(9/16, contentMode: .fit)
                        .border(Color.blue)
                        .padding(32)
                }
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    viewModel.uploadImage(image: uiImage, to: "UserVoucher/\(viewModel.userInfo.uid)")
                }, content: {
                    ImagePicker(image: $uiImage)
                })
            }
        }
    }
    
    private var voucherInformationSection: some View {
        VStack {
            if viewModel.step.rawValue >= Step.redemptionStore.rawValue {
                TextField("교환처", text: $viewModel.voucher.redemptionStore)
                    .transition(.move(edge: .bottom))
            }
            
            if viewModel.step.rawValue >= Step.name.rawValue {
                TextField("쿠폰명", text: $viewModel.voucher.name)
                    .transition(.move(edge: .bottom))
            }
            
            if viewModel.step.rawValue >= Step.code.rawValue {
                TextField("쿠폰코드번호", text: $viewModel.voucher.code)
                    .transition(.move(edge: .bottom))
            }
            
            if viewModel.step.rawValue >= Step.validationDate.rawValue {
                DatePicker("유효기간", selection: $viewModel.voucher.validationDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .transition(.move(edge: .bottom))
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    private var buttons: some View {
        Group {
            if viewModel.step == .validationDate {
                Button(action: {
                    viewModel.insertNewVoucherToFirestore(voucher: viewModel.voucher)
                    dismiss()
                }) {
                    Text("추가하기")
                }
                .disabled(!viewModel.canSubmit)
            } else {
                Button(action: {
                    viewModel.nextStep()
                }) {
                    Text("다음")
                }
            }
        }
        .padding()
    }
}

struct VoucherAdditionalView_Previews: PreviewProvider {
    init() {
        FirebaseAuthManager.signIn()
    }
    
    static var previews: some View {
        if let user = FirebaseAuthManager.currentUser {
            VoucherAdditionalView(viewModel: MockVoucherAdditionalViewModel(userInfo: user))
        }
    }
}
