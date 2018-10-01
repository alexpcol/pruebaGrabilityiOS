//
//  DataTypeChanger.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class DataTypeChanger: NSObject {

    static func JSONDataToDiccionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func DictionaryToJSONData(jsonObject: AnyObject) throws -> String?
    {
        let data: NSData? = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        var jsonStr: String?
        if data != nil {
            jsonStr = String(data: data! as Data, encoding: String.Encoding.utf8)
        }
        
        return jsonStr
    }
}
