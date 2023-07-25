//
//  BaseData.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation

protocol BaseData: Identifiable, Decodable {
    
    var id: String { get }
}
