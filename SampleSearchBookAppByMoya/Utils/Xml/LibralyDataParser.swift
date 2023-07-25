//
//  LibralyDataParser.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/09.
//

import Foundation


final class LibralyDataParser {
    
    private static let xmlWrapper = XmlUtilWrapper<LibralyInfoData>()
    
    static func parse(data: Data) async -> [LibralyInfoData] {
        
        var dics: [[String:String]]
        
        do {
            dics = try await xmlWrapper.convertXmlToObject(with: data, arrayElements: "Library")
        }
        catch {
            print(error.localizedDescription)
            return []
        }
        
        var resultArray: [LibralyInfoData] = []
        
        dics.forEach { dic in
            
            let systemid = dic["systemid"] ?? ""
            let systemname = dic["systemname"] ?? ""
            let libkey = dic["libkey"] ?? ""
            let libid = dic["libid"] ?? ""
            let short = dic["short"] ?? ""
            let formal = dic["formal"] ?? ""
            let url_pc = dic["url_pc"] ?? ""
            let address = dic["address"] ?? ""
            let pref = dic["pref"] ?? ""
            let city = dic["city"] ?? ""
            let post = dic["post"] ?? ""
            let tel = dic["tel"] ?? ""
            let geocode = dic["geocode"] ?? ""
            let category = dic["category"] ?? ""
            
            let infoData = LibralyInfoData(systemid: systemid, systemname: systemname, libkey: libkey, libid: libid, short: short, formal: formal, url_pc: url_pc, address: address, pref: pref, city: city, post: post, tel: tel, geocode: geocode, category: category)
            resultArray.append(infoData)
        }
        
        return resultArray.filter({ $0.id != "" })
    }
    
}
