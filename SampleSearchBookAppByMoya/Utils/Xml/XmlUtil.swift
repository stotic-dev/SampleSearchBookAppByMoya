//
//  XmlUtil.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/08.
//

import Foundation

class XmlUtil: NSObject {
    
    typealias Output = Result<[[String:String]], Error>
    
    // MARK: - private property
    private var parser: XMLParser!
    private var parseResultHandler: ((Output) -> Void)?
    private var targetElement = ""
    private var readingLine = 0
    private var editingItem: [String:String] = [:]
    private var result: [[String:String]] = [[:]]
    private var arrayElements: [String]?
    private var readingParentElementColomun = 0
    
    override init() {
        super.init()
        
        parser = XMLParser()
        parser.delegate = self
    }
    
    convenience init(arrayElements: [String]) {
        self.init()
        
        parser = XMLParser()
        self.arrayElements = arrayElements
    }
    
    // MARK: - parse methods
    func parse(data: Data, completion: @escaping (Output) -> Void) {
        
        parser = XMLParser(data: data)
        parser.delegate = self
        parseResultHandler = completion
        let resultParse = parser.parse()
        
        if !resultParse,
           let error = parser.parserError?.localizedDescription {
            print("parse error: \(error)")
        }
    }
}

// MARK: - XMLParserDelegate methods
extension XmlUtil: XMLParserDelegate {

    // 開始タグを読み込んだ時の処理
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        readingLine = parser.lineNumber
        targetElement = elementName
    }
    
    // データを読み込んだ時の処理
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if parser.lineNumber != readingLine { return }
        editingItem.updateValue(string, forKey: targetElement)
    }
    
    // 終了タグを読み込んだ時の処理
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard let _ = arrayElements?.filter({ $0 == elementName }).first else { return }
        result.append(editingItem)
        editingItem = [:]
    }
    
    // ドキュメントの読み込みが終了した時の処理
    func parserDidEndDocument(_ parser: XMLParser) {
        
        guard let completion = parseResultHandler else { return }
        if let error = parser.parserError {
            completion(.failure(error))
            return
        }
        
        result = result.filter({ !$0.isEmpty })
       
        completion(.success(result))
    }
}
