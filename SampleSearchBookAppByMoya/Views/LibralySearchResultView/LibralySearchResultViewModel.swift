//
//  LibralySearchViewModel.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation

class LibralySearchResultViewModel: ObservableObject {
    
    @Published var isShowIndicator = false
//    @Published var searchBooks: [BookInfoData] = [BookInfoData(id: "UMV0tAEACAAJ", volumeInfo: .init(title: "鬼滅の刃 8", authors: ["吾峠呼世晴"], publishedDate: "2017-10", description: "In Taisho-era Japan, Tanjiro Kamado is a kindhearted boy who makes a living selling charcoal until his peaceful life is shattered when a demon slaughters his family and turns his sister into another demon, forcing Tanjiro on a dangerous journey to destroy the demon and save his sister.", industryIdentifiers: [.init(type: "ISBN_10", identifier: "4088812123")]), imageLinks: .init(smallThumbnail: "http://books.google.com/books/content?id=UMV0tAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api", thumbnail: "http://books.google.com/books/content?id=UMV0tAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"))]
    @Published var searchBooks: [BookInfoData] = []
    @Published var isShowBookStatusView = false
    @Published var isShowAlertView = false
    var searchLibraly: LibralyInfoData? = nil
    var bookSearchLimit = 10
    var libraryBookEntity: LibraryBookEntity? = nil
    var alertMessage = "aaaaaaaaaa"
}
