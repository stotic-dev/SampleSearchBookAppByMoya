//
//  Services.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//


import ArkanaKeys
import Moya

struct LibraryParameter {
    
    let prefecturer: String
    let city: String
    let limit: Int
    
    init(prefecturer: String, city: String, limit: Int = 10) {
        self.prefecturer = prefecturer
        self.city = city
        self.limit = limit
    }
}

struct LibraryHasBookParameter {
    let isbn: [String]
    let systemId: String
}

struct LibraryHasBookPollingParameter {
    let sessionId: String
}

struct BookParameter {
    
    let keyword: String
    let limit: Int
    let startIndex: Int
    
    init(keyword: String, limit: Int, startIndex: Int = 0) {
        self.keyword = keyword
        self.limit = limit
        self.startIndex = startIndex
    }
}

struct LibraryBookParameter {
    
    let isbnArray: [String]
    let systemId: String
}

enum Services {
    case selectLibrary(param: LibraryParameter)
    case selectLibraryHasBook(param: LibraryBookParameter)
    case selectLibraryHasBookPooling(param: LibraryHasBookPollingParameter)
    case selectBooks(param: BookParameter)
}

extension Services {
    
    func getTarget() -> TargetType {
        
        switch self {
            
        case .selectLibrary(param: _), .selectLibraryHasBook(param: _), .selectLibraryHasBookPooling(param: _):
            return LibralyTarget(path: self.path(), task: self.task())
            
        case .selectBooks(param: _):
            return BookTarget(task: self.task())
        }
    }
}

private extension Services {
    
    var appkey: String {
        return ArkanaKeys.Keys.Global().mySecretAPIKey
    }
    
    func task() -> Moya.Task {
        var paramDic: [String: Any] = ["appkey": appkey]
        
        switch self {
            
        case .selectLibrary(param: let param):
            paramDic.updateValue(param.prefecturer, forKey: "pref")
            paramDic.updateValue(param.city, forKey: "city")
            paramDic.updateValue(param.limit, forKey: "limit")
            return .requestParameters(parameters: paramDic, encoding: URLEncoding.queryString)
            
        case .selectLibraryHasBook(param: let param):
            paramDic.updateValue(param.isbnArray.joined(separator: ","), forKey: "isbn")
            paramDic.updateValue(param.systemId, forKey: "systemid")
            paramDic.updateValue("no", forKey: "callback")
            return .requestParameters(parameters: paramDic, encoding: URLEncoding.queryString)
            
        case .selectLibraryHasBookPooling(param: let param):
            paramDic.updateValue(param.sessionId, forKey: "session")
            paramDic.updateValue("no", forKey: "callback")
            return .requestParameters(parameters: paramDic, encoding: URLEncoding.queryString)
        
        case .selectBooks(param: let param):
            let keyword = param.keyword.replacingOccurrences(of: " ", with: "+")
            paramDic = ["q": "\(keyword)"]
            paramDic.updateValue("maxResults", forKey: String(param.limit))
            paramDic.updateValue("startIndex", forKey: String(param.startIndex))
            return .requestParameters(parameters: paramDic, encoding: URLEncoding.queryString)
        }
    }
    
    func method() -> Moya.Method {
        switch self {
            
        case .selectLibrary(param: _), .selectLibraryHasBook(param: _), .selectLibraryHasBookPooling(param: _), .selectBooks(param: _):
            return .get
        }
    }
    
    func path() -> String {
        switch self {
            
        case .selectLibrary(param: _):
            return "library"
        
        case .selectLibraryHasBook(param: _), .selectLibraryHasBookPooling(param: _):
            return "check"
            
        case .selectBooks(param: _):
            return ""
        }
    }
}
