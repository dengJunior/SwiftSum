//
//  String+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

// MARK: - 编码，加密相关
extension String {
    func urlEncoded() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    func urlDecoded() -> String? {
        return self.stringByRemovingPercentEncoding
    }
    
    func base64Encoded() -> String? {
        if let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return encodedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        return nil
    }
}

// MARK: - convert 相关
extension String {
    func toNSURL() -> NSURL? {
        if let urlString = self.urlEncoded() {
            return NSURL(string: urlString)
        }
        return nil
    }
    
    func toNSData(encoding: NSStringEncoding = NSUTF8StringEncoding) -> NSData? {
        return self.dataUsingEncoding(encoding)
    }
}

// MARK: - path相关
extension String {
    func pathForResource() -> String? {
        return NSBundle.mainBundle().pathForResource(self, ofType: nil)
    }
    
    func contentsOfRescource(encoding encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if let filePath = self.pathForResource() {
            return try? String(contentsOfFile: filePath, encoding: encoding)
        }
        return nil
    }
    static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    }
}










