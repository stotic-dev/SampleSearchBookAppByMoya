//
//  LibraryBookEntity.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/22.
//

import Foundation

enum LibraryStatus: String, CaseIterable {
    case borrowable = "貸出可"
    case collection = "蔵書あり"
    case buildingOnly = "館内のみ"
    case borrowing = "貸出中"
    case reserveing = "予約中"
    case preparation = "準備中"
    case closed = "休館中"
    case noCollection = "蔵書なし"
    case other = "不明"
    
    static func checkStatus(status: String) -> Self {
        
        guard let selectStatus = LibraryStatus.allCases.first(where: {$0.rawValue == status }) else {
            return .other
        }
        
        return selectStatus
    }
}

enum LibraryBookRequestStatus: String, CaseIterable {
    case OK
    case Cache
    case Running
    case Error
    case Other
    
    static func checkStatus(status: String) -> LibraryBookRequestStatus {
        
        guard let selectStatus = LibraryBookRequestStatus.allCases.first(where: { $0.rawValue == status }) else {
            return .Other
        }
        
        return selectStatus
    }
}

struct LibraryBookEntity: Identifiable {
    
    let id: String
    let title: String
    let author: String
    let description: String
    let libraryStatus: [LibraryBookStatusInfo]
    let requestStatus: LibraryBookRequestStatus
}

struct LibraryBookStatusInfo: Identifiable {
    let id: String
    let place: String
    let status: LibraryStatus
}
