//
//  LibralyInfoData.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation

struct LibralyInfoData: BaseData {
    var id: String = UUID().uuidString
    let systemid: String
    let systemname: String
    let libkey: String
    let libid: String
    let short: String
    let formal: String
    let url_pc: String
    let address: String
    let pref: String
    let city: String
    let post: String
    let tel: String
    let geocode: String
    let category: String
}
