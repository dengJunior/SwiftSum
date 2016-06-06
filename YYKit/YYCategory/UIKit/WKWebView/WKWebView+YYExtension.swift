//
//  WKWebView+YYExtension.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import WebKit

// MARK: - Load
extension WKWebView {
    public func loadUrlString(urlString: String) -> Bool {
        if let url = urlString.toNSURL() {
            loadRequest(NSURLRequest(URL: url))
            return true
        }
        return false
    }
    
    public func loadLocalHTMLNamed(htmlName: String) -> Bool {
        if let htmlPath = NSBundle.mainBundle().pathForResource(htmlName, ofType: nil) {
            if let appHtml = try? String(contentsOfFile: htmlPath, encoding: NSUTF8StringEncoding) {
                let baseUrl = htmlPath.toNSURL()
                loadHTMLString(appHtml, baseURL: baseUrl)
                return true
            }
        }
        return false
    }
}
