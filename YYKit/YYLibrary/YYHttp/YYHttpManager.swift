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
    var params: [String: AnyObject]?
    var files: [YYHttpFile]?
    var cancelCallback: (() -> Void)?
    var completionCallback: ((data: NSData?, response: NSHTTPURLResponse?, error: NSError?) -> Void)?
    
    var session: NSURLSession!
    var urlString: String!
    var mutableRequest: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    var headers = YYHttpManager.defaultHttpHeaders
    
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

    // MARK: - Init
    init(httpMethod: YYHttpMethod, urlString: String) {
        self.method = httpMethod
        self.urlString = urlString
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        super.init()
    }
    
    init(urlRequest: NSMutableURLRequest) {
        method = YYHttpMethod(rawValue: urlRequest.HTTPMethod)
        urlString = urlRequest.URL?.absoluteString
        mutableRequest = urlRequest
        super.init()
    }
}

// MARK: - Public
extension YYHttpManager {
    func addParams(params: [String: AnyObject]) {
        self.params = params
    }
    
    func addHeaders(headers: [String: String]) {
        self.headers.updateFromDictionary(headers)
    }
    
    func addFiles(files: [YYHttpFile]) {
        self.files = files
    }
    
    func fire(completion: ((data: NSData?, response: NSHTTPURLResponse?, error: NSError?) -> Void)? = nil) {
        completionCallback = completion
        
        buildRequest()
        buildHeader()
        buildBody()
        fireTask()
    }
}

// MARK: - Private
private extension YYHttpManager {
    
    private func buildRequest() {
        if method == .GET && params?.count > 0 {
            urlString = urlString + "?" + buildParams(params!)
        }
        mutableRequest = NSMutableURLRequest(URL: urlString.toNSURL()!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30)
        mutableRequest.HTTPMethod = method.rawValue
    }
    private func buildHeader() {
        // multipart Content-Type; see http://www.rfc-editor.org/rfc/rfc2046.txt
        if params?.count > 0 {
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        if files?.count > 0 && method != .GET {
            headers["Content-Type"] = "multipart/form-data; boundary=" + boundary
        }
        
        for (key, value) in headers {
            mutableRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
    private func buildBody() {
        let data = NSMutableData()
        
        if files?.count > 0 {
            if method == .GET {
                print("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\nBut it looks like iOS 9 SDK has prevented sending http body in GET method.\n------------------------\n\n")
            } else {
                if let p = params {
                    for (key, value) in p {
                        data.appendData("--\(boundary)\r\n".toNSData()!)
                        data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".toNSData()!)
                        data.appendData("\(value.description)\r\n".toNSData()!)
                    }
                }
                if let f = files {
                    for file in f {
                        data.appendData("--\(boundary)\r\n".toNSData()!)
                        data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\(file.url.lastPathComponent!)\r\n\r\n".toNSData()!)
                        if let fileData = NSData(contentsOfURL: file.url) {
                            data.appendData(fileData)
                            data.appendData("\r\n".toNSData()!)
                        }
                    }
                    data.appendData("--\(boundary)\r\n".toNSData()!)
                }
            }
        }else if method != .GET && params?.count > 0 {
            if let encodedParams = buildParams(params!).toNSData() {
                data.appendData(encodedParams)
            }
        }
    }
    private func fireTask() {
        if YYHttp.YYDebug { print(mutableRequest.allHTTPHeaderFields) }
        task = session.dataTaskWithRequest(mutableRequest) {[unowned self] (data, response, error) in
            if YYHttp.YYDebug { print(response) }
            
            if error?.code == -999 {
                self.cancelCallback?()
            } else {
                self.completionCallback?(data: data, response: response as? NSHTTPURLResponse, error: error)
                self.session.finishTasksAndInvalidate()
            }
        }
        task.resume()
    }
    
    func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for (key, value) in parameters {
            components += queryComponents(key, value)
        }
        
        return components.map{ "\($0)=\($1)" }.joinWithSeparator("&")
    }
    
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        return [(escape(key), escape("\(value)"))]
    }
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}






















