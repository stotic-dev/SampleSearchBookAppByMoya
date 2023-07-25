//
//  LibralySearchViewModel.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation

enum LibralyApiRequestStatus {
    case requesting
    case receiveResponse
    case receiveError
    case none
}

enum ValidationTarget {
    case pref
    case city
    case limit
}

class LibralySearchViewModel: ObservableObject {
    
    @Published var requestStatus: LibralyApiRequestStatus = .none
    @Published var isShowIndicator = false
    @Published var isShowAlert = false
    @Published var isOpenOptionViwe = false
    @Published var isValidationSuccessed = false
    @Published var pref = ""
    @Published var city = ""
    @Published var limit = 0
    @Published var searchLibralies: [LibralyInfoData] = []
    @Published var validationFailedList: [ValidationTarget] = []
}
