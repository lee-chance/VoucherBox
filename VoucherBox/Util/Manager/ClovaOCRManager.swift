//
//  ClovaOCRManager.swift
//  VoucherBox
//
//  Created by 이창수 on 2022/11/30.
//

import Foundation

final class ClovaOCRManager {
    private static let baseURLString: String = Bundle.main.clovaBaseURLString
    private static let domainID: String = Bundle.main.clovaDomainID
    private static let signature: String = Bundle.main.clovaSignature
    private static let path: String = Bundle.main.clovaPath
    private static let ocrSecret: String = Bundle.main.clovaOCRSecret
    
    static func scan(imageURLString: String) async throws -> ClovaOCRResponse? {
        guard let url = URL(string: "\(baseURLString)/\(domainID)/\(signature)/\(path)") else { return nil }
        
        let json: [String : Any?] = [
            "images" : [
                [
                    "format" : "png",
                    "name" : "medium",
                    "data" : nil,
                    "url" : imageURLString,
                ]
            ],
            "lang" : "ko",
            "requestId" : "string",
            "resultType" : "string",
            "timestamp" : Date().timeIntervalSinceNow,
            "version" : "V1",
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ocrSecret, forHTTPHeaderField: "X-OCR-SECRET")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ClovaOCRResponse.self, from: data)
        
        return result
    }
}

struct ClovaOCRResponse: Codable {
    let images: [ClovaOCRImage]
}

struct ClovaOCRImage: Codable {
    let uid: String
    let inferResult: InferResult
    let matchedTemplate: ClovaOCRMatchedTemplate?
    let fields: [ClovaOCRField]?
    let title: ClovaOCRField?
    
    enum InferResult: String, Codable {
        case success = "SUCCESS"
        case failure = "FAILURE"
    }
}

struct ClovaOCRMatchedTemplate: Codable {
    let id: Int
    let name: String
}

struct ClovaOCRField: Codable {
    let name: String
    let bounding: ClovaOCRFieldBound
    let valueType: String?
    let inferText: String
    let inferConfidence: Double
}

struct ClovaOCRFieldBound: Codable {
    let top, left, width, height: Double
}
