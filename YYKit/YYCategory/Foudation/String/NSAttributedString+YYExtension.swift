//
//  NSAttributeString+YYExtension.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension NSAttributedString {
    public func toHtmlString() -> String? {
        guard let htmlData = try? self.dataFromRange(NSRange(location: 0, length: self.length), documentAttributes: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]) else {
            return nil
        }
        return String(data: htmlData, encoding: NSUTF8StringEncoding)
    }
    
}
