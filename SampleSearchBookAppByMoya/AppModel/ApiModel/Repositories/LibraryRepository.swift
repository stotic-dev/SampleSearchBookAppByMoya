//
//  LibralyRepository.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/09.
//

import Foundation
import Moya

class LibraryRepository {
    
    private let provider = MoyaProvider<LibralyTarget>(callbackQueue: DispatchQueue.global(),session: SessionManager.sharedManager, plugins: [NetworkLoggerPlugin()])
    
    func request(service: Services) async throws -> Data? {
        
        return try await withCheckedThrowingContinuation({ [weak self] continuation in
            guard let self = self else {
                continuation.resume(returning: nil)
                return
            }
            
            guard let target = service.getTarget() as? LibralyTarget else {
                continuation.resume(returning: nil)
                return
            }
            
            provider.request(target) { result in
                
                switch result {
                    
                case .success(let response):
                    
                    continuation.resume(returning: response.data)
                    return
                case .failure(let error):
                    
                    continuation.resume(throwing: error)
                    return
                }
            }
        })
    }
}
