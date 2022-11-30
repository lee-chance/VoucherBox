//
//  VoucherAdditionalView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/20.
//

import SwiftUI

struct VoucherAdditionalView<ViewModel: VoucherAdditionalViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    @State private var showImagePicker: Bool = false
    @State private var isLoading: Bool = false
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack {
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
                        
                        // load image
//                        isLoading = true
//                        vm.getImage {
//                            isLoading = false
//                            uiImage = $0
//                        }
                    }) {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .frame(width: 200, height: 300)
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        viewModel.uploadImage(image: uiImage, to: "UserVoucher/\(viewModel.userInfo.uid)")
                    }, content: {
                        ImagePicker(image: $uiImage)
                    })
                }
            }
            
            Text("\(String(describing: viewModel.voucher))")
        }
        .border(Color.blue)
    }
}
