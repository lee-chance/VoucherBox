//
//  VoucherDetailView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/12/03.
//

import SwiftUI

struct VoucherDetailView: View {
    @State private var showDetailInformation: Bool = false
    @State private var offset: CGFloat = .zero
    @State private var isUsed: Bool = false
    
    @Binding var selectedVoucher: Voucher?
    let userID: String
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            background
            
            content
        }
        .onChange(of: selectedVoucher) { newValue in
            isUsed = selectedVoucher?.isUsed ?? false
        }
    }
    
    private var background: some View {
        Group {
            if showDetailInformation {
                Color.white
            } else {
                Color.black
                    .opacity(selectedVoucher != nil ? backgroundOpacity : 0)
            }
        }
        .ignoresSafeArea()
    }
    
    private var backgroundOpacity: Double {
        1 - Double(offset / 200)
    }
    
    @ViewBuilder
    private var content: some View {
        if let voucher = selectedVoucher {
            Group {
                if showDetailInformation {
                    informationEditView(voucher: voucher)
                } else {
                    fullscreenImageView(voucher: voucher)
                }
            }
            .onChange(of: isUsed) { newValue in
                selectedVoucher = voucher.set(isUsed: newValue)
                
                FirestoreManager
                    .reference(path: .users)
                    .reference(path: userID)
                    .reference(path: .vouchers)
                    .reference(path: voucher.id)
                    .updateData(["isUsed" : newValue])
            }
        }
    }
    
    private func fullscreenImageView(voucher: Voucher) -> some View {
        VoucherImage(imageURL: voucher.imageURL)
            .scaledToFit()
            .matchedGeometryEffect(id: voucher.id, in: animation)
            .offset(y: offset)
            .gesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let offsetHeight = value.translation.height
                if  offsetHeight > 0 {
                    offset = offsetHeight
                }
            }
            .onEnded { value in
                let velocityHeight = value.predictedEndLocation.y - value.location.y
                
                if velocityHeight < -300 {
                    showDetailInformation = true
                }
                
                withAnimation(.easeInOut) {
                    if offset > 200 {
                        self.selectedVoucher = nil
                    }
                    
                    self.offset = 0
                }
            }
    }
    
    private func informationEditView(voucher: Voucher) -> some View {
        ScrollView {
            VStack {
                VoucherImage(imageURL: voucher.imageURL)
                    .scaledToFill()
                    .frame(maxHeight: 250)
                    .clipped()
                    .overlay(
                        ZStack {
                            Color.black
                                .opacity(isUsed ? 0.5 : 0)
                            
                            if isUsed {
                                Text("사용완료")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    showDetailInformation = false
                                    selectedVoucher = nil
                                }
                            }
                    )
                    .matchedGeometryEffect(id: voucher.id, in: animation)
                
                VStack(alignment: .leading) {
                    Text("상품명: \(voucher.name)")
                    
                    Text("사용처: \(voucher.redemptionStore)")
                    
                    Text("유효기간: \(voucher.validationDate)")
                    
                    Text("남은기간: \(voucher.expirationDays)")
                    
                    Toggle("사용완료", isOn: $isUsed)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct VoucherDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        VoucherDetailView(selectedVoucher: .constant(Voucher.chickenDummy()), userID: "", animation: namespace)
    }
}
