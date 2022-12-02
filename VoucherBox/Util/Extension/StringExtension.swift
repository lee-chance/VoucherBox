//
//  StringExtension.swift
//  VoucherBox
//
//  Created by 이창수 on 2022/12/02.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy년 MM월 dd일") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}
