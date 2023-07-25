//
//  BookTarget.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/16.
//

import Foundation
import Moya

class BookTarget: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes") else {
            fatalError("failed get BookTarget URL")
        }
        
        return url
    }
    
    var path: String = ""
    
    var method: Moya.Method
    
    var task: Moya.Task
    
    var headers: [String : String]? = ["Content-Type" : "application/json"]
    
    init(method: Moya.Method = .get, task: Moya.Task) {
        self.method = method
        self.task = task
    }
}
