//
//  ContentView.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/11/20.
//

import SwiftUI

struct ContentView: View {
    @State private var openAdditionalView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Vouchers")
                    .font(.largeTitle)
                
                Spacer()
                
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
                ForEach(0..<3, id: \.self) { i in
                    voucher(i)
                }
            }
        }
        .padding()
    }
    
    private func voucher(_ index: Int) -> some View {
        HStack {
            Image(systemName: "flame.fill")
            
            VStack(alignment: .leading) {
                Text("Name")
                
                Text("Validate Date")
                
                Text("Where")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .border(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
