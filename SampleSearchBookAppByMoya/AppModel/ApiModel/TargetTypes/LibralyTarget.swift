//
//  LibralyTarget.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation
import Moya

class LibralyTarget: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.calil.jp/") else {
            fatalError("failed read base url: \(NSStringFromClass(type(of: self)))")
        }
        
        return url
    }
    
    var path: String = ""
    
    var method: Moya.Method
    
    var task: Moya.Task
    
    var headers: [String : String]? = ["Content-Type" : "application/json"]
    
    init(path: String, method: Moya.Method = .get, task: Moya.Task) {
        self.path = path
        self.method = method
        self.task = task
    }
}
