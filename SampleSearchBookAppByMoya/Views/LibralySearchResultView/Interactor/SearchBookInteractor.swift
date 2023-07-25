//
//  BookSearchInteractor.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import Combine
import os

protocol SearchBookUsecase {
    
    func execute(param: BookParameter) -> AnyPublisher<[BookInfoData], Error>
}

final class SearchBookInteractor {
    
    var apiObserver = PassthroughSubject<[BookInfoData], Error>()
    let logger = Logger(subsystem: "", category: "main")
    let decoder = JSONDecoder()
    
    init() {}
}

extension SearchBookInteractor: SearchBookUsecase {
    
    func execute(param: BookParameter) -> AnyPublisher<[BookInfoData], Error> {
        
        Future<[BookInfoData], Error> { [weak self] completion in
            
            guard let self = self else {
                
                completion(.success([]))
                return
            }
            
            let api = BookRepository()
            
            Task {
                do {
                    guard let data = try await api.request(service: .selectBooks(param: param)) else {
                        completion(.success([]))
                        return
                    }
                    
                    print("selected data: \(data)")
                    
                    let convertData = try self.decoder.decode(BookInfoDataJsonStruct.self, from: data)
                    completion(.success(convertData.items))
                }
                catch {
                    
                    self.logger.error("get api response error: \(error.localizedDescription)")
                    print("get api response error: \(error)")
                    
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
