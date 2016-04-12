//
//  String+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

extension String {
    func yy_base64EncodedString() -> String? {
        if let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return encodedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        return nil
    }
    
    static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    }
}

