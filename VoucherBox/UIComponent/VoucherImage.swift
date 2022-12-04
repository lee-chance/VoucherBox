//
//  VoucherImage.swift
//  VoucherBox
//
//  Created by Changsu Lee on 2022/12/03.
//

import SwiftUI
import SDWebImageSwiftUI

struct VoucherImage: View {
    let imageURL: URL?
    
    var body: some View {
        WebImage(url: imageURL)
            .resizable()
    }
}

struct VoucherImage_Previews: PreviewProvider {
    static var previews: some View {
        VoucherImage(imageURL: nil)
    }
}
