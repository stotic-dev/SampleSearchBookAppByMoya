//
//  SessionManager.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/23.
//

import Foundation
import Alamofire

class SessionManager: Alamofire.Session {
    
    static let sharedManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        return Session(configuration: configuration)
    }()
}
