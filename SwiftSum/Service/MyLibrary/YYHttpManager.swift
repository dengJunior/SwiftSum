//
//  YYHttpManager.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYHttpManager: NSObject {
    let boundary = "PitayaUGl0YXlh"
    let errorDomain = "com.yy.http"
    
    let method: YYHttpMethod!
    var params: [String: String]?
    var files: [YYHttpFile]?
    var cancelCallback: (() -> Void)?
    var completionCallback: ((data: NSData?, response: NSHTTPURLResponse?, error: NSError?) -> Void)?
    
    var session: NSURLSession!
    let urlString: String!
    var mutableRequest: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    var httpHeaders = YYHttpManager.defaultHttpHeaders
    
    static let defaultHttpHeaders: [String: String] = {
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = NSLocale.preferredLanguages().prefix(6).enumerate().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
            }.joinWithSeparator(", ")
        
        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
                let os = NSProcessInfo.processInfo().operatingSystemVersionString
                
                var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
                let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
                
                if CFStringTransform(mutableUserAgent, UnsafeMutablePointer<CFRange>(nil), transform, false) {
                    return mutableUserAgent as String
                }
            }
            
            return "Alamofire"
        }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }()

    init(httpMethod: YYHttpMethod, urlString: String) {
        self.method = httpMethod
        self.urlString = urlString
        super.init()
    }
    
    init(urlRequest: NSMutableURLRequest) {
        method = YYHttpMethod(rawValue: urlRequest.HTTPMethod)
        urlString = urlRequest.URL?.absoluteString
        mutableRequest = urlRequest
        super.init()
    }
    
    func fire(completion: ((data: NSData?, response: NSHTTPURLResponse?, error: NSError?) -> Void)? = nil) {
        completionCallback = completion
        
        buildRequest()
        buildHeader()
        buildBody()
        fireTask()
    }
    
    private func buildRequest() {
        if method == .GET && params?.count > 0 {
            
        }
        mutableRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30)
        mutableRequest.HTTPMethod = method.rawValue
    }
    private func buildHeader() {
        // multipart Content-Type; see http://www.rfc-editor.org/rfc/rfc2046.txt
        if params?.count > 0 {
            httpHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        }
        if files?.count > 0 && method != .GET {
            httpHeaders["Content-Type"] = "multipart/form-data; boundary=" + boundary
        }
        
        for (key, value) in httpHeaders {
            mutableRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
    private func buildBody() {
        
    }
    private func fireTask() {
        if YYHttp.YYDebug { print(mutableRequest.allHTTPHeaderFields) }
        task = session.dataTaskWithRequest(mutableRequest) { (data, response, error) in
            if YYHttp.YYDebug { print(response) }
            
            self.completionCallback?(data: data, response: response as? NSHTTPURLResponse, error: error)
            self.session.invalidateAndCancel()
        }
        task.resume()
    }
}
























