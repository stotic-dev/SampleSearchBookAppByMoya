//
//  BookInfoDataConverter.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/17.
//

import Foundation

enum IsbnType: String {
    case ISBN_10 = "ISBN_10"
    case ISBN_13 = "ISBN_13"
}

struct BookInfoDataConverter {
    
    static func selectIsbn(data: BookInfoData, type: IsbnType = .ISBN_10) -> String? {
        
        guard let isbn = data.volumeInfo.industryIdentifiers?.first(where: {$0.type == type.rawValue})?.identifier else {
            return ""
        }
        
        return isbn
    }
    
    static func convertToLibraryBookEntity(bookData: BookInfoData, libraryData: LibraryHasBookInfoData) -> LibraryBookEntity {
        let isbn = selectIsbn(data: bookData) ?? ""
        let author = bookData.volumeInfo.authors?.joined(separator: ", ") ?? "No Author"
        let description = bookData.searchInfo?.textSnippet ?? "No Descrption"
        
        let targetBook = libraryData.books
        
        var bookStatusInfos: [LibraryBookStatusInfo]
        bookStatusInfos = targetBook.isbn.systemIds.pref.libkey?.compactMap({ LibraryBookStatusInfo(id: UUID().uuidString, place: $0, status: LibraryStatus.checkStatus(status: $1)) }) ?? []
        
        let requestStatus = LibraryBookRequestStatus.checkStatus(status: targetBook.isbn.systemIds.pref.status)
        
        return LibraryBookEntity(id: isbn, title: bookData.volumeInfo.title, author: author, description: description, libraryStatus: bookStatusInfos, requestStatus: requestStatus)
    }
}
