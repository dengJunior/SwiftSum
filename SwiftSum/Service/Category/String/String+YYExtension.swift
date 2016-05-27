//
//  String+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

// MARK: - URL相关
extension String {
    func stringByURLEncode() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    func stringByURLDecode() -> String? {
        return self.stringByRemovingPercentEncoding
    }
    
    func toNSURL() -> NSURL? {
        if let urlString = self.stringByURLEncode() {
            return NSURL(string: urlString)
        }
        return nil
    }
    
    func pathForResource() -> String? {
        return NSBundle.mainBundle().pathForResource(self, ofType: nil)
    }
    
    func contentsOfRescource(encoding encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if let filePath = self.pathForResource() {
            return try? String(contentsOfFile: filePath, encoding: encoding)
        }
        return nil
    }
}

extension String {
    
    func base64EncodedString() -> String? {
        if let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return encodedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        return nil
    }
    
    static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    }
}











