//
//  URLExtention.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/17.
//

import Foundation

extension URL {
    
    func convertToHttpsIfNeeded() -> URL? {
        
        guard let currentScheme = self.scheme else { return nil }
        if currentScheme != "https" {
            
            var component = URLComponents(url: self, resolvingAgainstBaseURL: false)
            component?.scheme = "https"
            return component?.url
        }
        
        return self
    }
}
