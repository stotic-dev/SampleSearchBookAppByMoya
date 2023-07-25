//
//  SearchLibralyHasBooksInteractor.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/17.
//

import Foundation
import Combine

protocol SearchLibralyHasBooksUseCase {
    
    func execute(data: BookInfoData, systemId: String) -> AnyPublisher<LibraryBookEntity?, Error>?
}

final class SearchLibralyHasBooksInteractor {
    
    private let decoder = JSONDecoder()
    private var targetData: BookInfoData!
    
    init() {}
}

extension SearchLibralyHasBooksInteractor: SearchLibralyHasBooksUseCase {
    
    func execute(data: BookInfoData, systemId: String) -> AnyPublisher<LibraryBookEntity?, Error>? {
        return Future<LibraryBookEntity?, Error> { [weak self] completion in
            
            guard let self = self else { return }
            guard let isbn = BookInfoDataConverter.selectIsbn(data: data) else {
                return
            }
            self.targetData = data
            
            let param = LibraryBookParameter(isbnArray: [isbn], systemId: systemId)
            let api = LibraryRepository()
            
            Task { [weak self] in
                
                guard let self = self else {
                    completion(.success(nil))
                    return
                }
                
                do {
                    guard let data = try await api.request(service: .selectLibraryHasBook(param: param)) else {
                        completion(.success(nil))
                        return
                    }
                    
                    print("selected data: \(String(describing: String(data: data, encoding: .utf8)))")
                    
                    var convertData = try self.decoder.decode(LibraryHasBookInfoData.self, from: data)
                    
                    if let poolingData = try await self.requestPoolingIfNeeded(data: convertData, api: api) {
                        
                        // ポーリング結果を取得した場合
                        convertData = poolingData
                    }
                    
                    print("convert data: \(String(describing: convertData))")
                    let resultData = BookInfoDataConverter.convertToLibraryBookEntity(bookData: targetData, libraryData: convertData)
                    
                    completion(.success(resultData))
                }
                catch {
                    
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension SearchLibralyHasBooksInteractor {
    
    enum SearchLibraryBookError: Error {
        case failedPooling
    }
    
    func requestPooling(session: String, api: LibraryRepository) async throws -> LibraryHasBookInfoData? {
                
        guard let data = try await api.request(service: .selectLibraryHasBookPooling(param: LibraryHasBookPollingParameter(sessionId: session))) else {
            return nil
        }
        
        print("selected pooling data: \(String(describing: String(data: data, encoding: .utf8)))")
        
        return try decoder.decode(LibraryHasBookInfoData.self, from: data)
    }
    
    /// 蔵書情報が取得できておらず、ポーリングリクエストが必要であれば行う
    /// 3回までポーリングリクエストを行う
    func requestPoolingIfNeeded(data: LibraryHasBookInfoData, api: LibraryRepository) async throws -> LibraryHasBookInfoData? {
        
        var poolingCount = 0
        var isNeedPooling = checkNeedPooling(data: data)
        var resultData: LibraryHasBookInfoData?
        
        guard isNeedPooling else { return nil }
        
        
        while isNeedPooling && poolingCount < 3 {
            
            // 2秒の遅延処理
            // ポーリング処理を行う前に2秒間隔を空ける必要があるAPI仕様のため
            try await Task.sleep(for: .seconds(2))
            
            // ポーリングのリクエスト
            guard let poolingData = try await requestPooling(session: data.id, api: api) else {
                throw SearchLibraryBookError.failedPooling
            }
            
            isNeedPooling = checkNeedPooling(data: poolingData)
            if !isNeedPooling {
                resultData = poolingData
            }
            
            poolingCount += 1
        }
        
        guard let resultData = resultData else { throw SearchLibraryBookError.failedPooling }
        return resultData
    }
    
    func checkNeedPooling(data: LibraryHasBookInfoData) -> Bool {
        
        let libkey = data.books.isbn.systemIds.pref.libkey
        let status = LibraryBookRequestStatus.checkStatus(status: data.books.isbn.systemIds.pref.status)
        return data.continue == 1 || libkey == nil || status == .Running
    }
}
