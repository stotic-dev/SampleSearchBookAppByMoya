//
//  LibralySearchResultPresenter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import Combine
import os

protocol SearchLibralyUsecase {
    
    func execute(param: LibraryParameter) -> AnyPublisher<[LibralyInfoData], Error>
}

final class SearchLibralyInteractor {
    
    let logger = Logger(subsystem: "test.logger", category: "main")

    init() {}
}

extension SearchLibralyInteractor: SearchLibralyUsecase {
    
    func execute(param: LibraryParameter) -> AnyPublisher<[LibralyInfoData], Error> {
        
        return Future<[LibralyInfoData], Error> { promiss in
            
            Task { [weak self] in
                
                guard let self = self else {
                    promiss(.success([]))
                    return
                }
                
                let api = LibraryRepository()
                do{
                    guard let data = try await api.request(service: .selectLibrary(param: param)) else {
                        self.logger.error("failed get api data")
                        promiss(.success([]))
                        return
                    }
                    
                    self.logger.debug("get api data")
                    print("data: \(data)")
                    
                    let libralyInfo = await LibralyDataParser.parse(data: data)
                    print("parse to libralyInfo count: \(libralyInfo.count)")
                    promiss(.success(libralyInfo))
                }
                catch {
                    self.logger.error("failed get api data [Error: \(error.localizedDescription)]")
                    promiss(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
