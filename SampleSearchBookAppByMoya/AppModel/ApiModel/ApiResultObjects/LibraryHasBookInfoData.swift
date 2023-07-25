//
//  LibraryHasBookInfoData.swift
//  SampleSearchBookAppByMoya
//
//  Created by 佐藤汰一 on 2023/07/17.
//

import Foundation

enum JsonParseError: Error {
    case JsonParseDecodeError
    case JsonparsePrefError
}

struct LibraryHasBookInfoData: BaseData {
    
    let id: String
    let `continue`: Int
    let books: Book
    
    enum CodingKeys: String, CodingKey {
        case id = "session"
        case `continue`
        case books
    }
    
    struct Book: Decodable {
        let id: String
        let isbn: ISBN
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: BookCustomCodingKey.self)
            guard let bookId = container.allKeys.first?.stringValue else { throw JsonParseError.JsonParseDecodeError }
            self.id = bookId
            self.isbn = try ISBN(from: decoder)
        }
        
        struct BookCustomCodingKey: CodingKey {
            var stringValue: String
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            var intValue: Int?
            
            init?(intValue: Int) {
                return nil
            }
        }
    }
    
    struct ISBN: Decodable {
        let systemIds: SystemIdObject
        
        init(from decoder: Decoder) throws {
            let dynamicContainer = try decoder.container(keyedBy: ISBNCustomCodingKey.self)
            let prefKey = dynamicContainer.allKeys.first!
            systemIds = try dynamicContainer.decode(SystemIdObject.self, forKey: ISBNCustomCodingKey.getDynamicKey(key: prefKey.stringValue))
        }
        
        struct ISBNCustomCodingKey: CodingKey {
            var stringValue: String
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            var intValue: Int?
            
            init?(intValue: Int) {
                return nil
            }
            
            static func getDynamicKey(key: String) -> ISBNCustomCodingKey {
                return ISBNCustomCodingKey(stringValue: key)!
            }
        }
    }
    
    struct SystemIdObject: Decodable {
        let pref: Pref
        
        enum CodingKeys: CodingKey {
            case prefs
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PrefsCustomCodingkey.self)
            let prefskey = container.allKeys.first!
            pref = try container.decode(Pref.self, forKey: prefskey)
        }
        
        struct PrefsCustomCodingkey: CodingKey {
            var stringValue: String
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            var intValue: Int?
            
            init?(intValue: Int) {
                return nil
            }
        }
    }
    
    struct Pref: Decodable {
        let status: String
        let reserveurl: String?
        let libkey: [String: String]?
    }
}
