//
//  ProcessingView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/12/10.
//

import SwiftUI

private struct ProcessingView: ViewModifier {
    let isProcessing: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isProcessing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .scaleEffect(1.5)
                    )
            }
        }
    }
}

extension View {
    func processingView(isProcessing: Bool) -> some View {
        modifier(ProcessingView(isProcessing: isProcessing))
    }
}
