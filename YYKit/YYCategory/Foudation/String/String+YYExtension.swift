//
//  String+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 编码，加密相关
extension String {
    public func urlEncoded() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    public func urlDecoded() -> String? {
        return self.stringByRemovingPercentEncoding
    }
    
    public func base64Encoded() -> String? {
        if let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return encodedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        return nil
    }
}

// MARK: - convert 相关
extension String {
    public func toNSURL() -> NSURL? {
        if let urlString = self.urlEncoded() {
            return NSURL(string: urlString)
        }
        return nil
    }
    
    public func toNSData(encoding: NSStringEncoding = NSUTF8StringEncoding) -> NSData? {
        return self.dataUsingEncoding(encoding)
    }
    
    public func toArray() -> [String] {
        var arr = [String]()
        for char in self.unicodeScalars {
            arr.append(String(char))
        }
        return arr
    }
    
    public func toHtmlAttributedString() -> NSAttributedString? {
        guard let data = self.toNSData() else {
            return nil
        }
        let options = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
    
    public func toBase64EncodedData() -> NSData? {
        return NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
    }
}

// MARK: - path相关
extension String {
    public func pathForResource() -> String? {
        return NSBundle.mainBundle().pathForResource(self, ofType: nil)
    }
    
    public func contentsOfRescource(encoding encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if let filePath = self.pathForResource() {
            return try? String(contentsOfFile: filePath, encoding: encoding)
        }
        return nil
    }
    public static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    }
}










