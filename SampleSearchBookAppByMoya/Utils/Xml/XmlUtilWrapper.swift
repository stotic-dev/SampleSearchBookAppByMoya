//
//  XmlUtilWrapper.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation

class XmlUtilWrapper<T: BaseData> {
    
    typealias ParseResult = [[String:String]]
    
    init() {}
    
    private var parseCompleteHandler: ((ParseResult) -> Void)?
    
    func convertXmlToObject(with data: Data, arrayElements: String...) async throws -> ParseResult {
        
        let xmlUtil = XmlUtil(arrayElements: arrayElements)
        
        return try await withCheckedThrowingContinuation({ continuation in
            
            xmlUtil.parse(data: data) { result in
                
                switch result {
                    
                case .success(let data):
                    
                    continuation.resume(returning: data)
                case .failure(let error):
                    
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
