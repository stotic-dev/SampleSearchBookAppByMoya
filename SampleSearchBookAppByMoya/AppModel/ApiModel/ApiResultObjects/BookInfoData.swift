//
//  BookInfoData.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/16.
//

import Foundation

struct BookInfoDataJsonStruct: Decodable {
    let items: [BookInfoData]
}

struct BookInfoData: BaseData {
    
    let id: String
    let volumeInfo: VolumeInfo
    let searchInfo: SearchInfo?
    
    struct VolumeInfo: Decodable {
        let title: String
        let authors: [String]?
        let publishedDate: String
        let industryIdentifiers: [IndustryIdentifier]?
        let imageLinks: ImageLinks?
    }
    
    struct ImageLinks: Decodable {
        let smallThumbnail: String
        let thumbnail: String
    }
    
    struct IndustryIdentifier: Decodable {
        let type: String
        let identifier: String
    }
    
    struct SearchInfo: Decodable {
        let textSnippet: String
    }
}
