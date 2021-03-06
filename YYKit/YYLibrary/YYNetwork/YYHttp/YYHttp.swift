//
//  YYHttp.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public enum YYHttpMethod: String {
    case DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT
}

public struct YYHttpFile {
    public let name: String!
    public let url: NSURL!
    public init(name: String, url: NSURL) {
        self.name = name
        self.url = url
    }
}

public class YYHttp {
    /// if set to true, YYHttp will log all information in a NSURLSession lifecycle
    public static var YYDebug = false
    var httpManager: YYHttpManager!
    
    // MARK: - 创建请求方式
    public static func build(httpMethod method: YYHttpMethod = .GET, urlString: String) -> YYHttp {
        let h = YYHttp()
        h.httpManager = YYHttpManager(httpMethod: method, urlString: urlString)
        return h
    }
    
    public static func fetch(urlString: String, httpMethod method: YYHttpMethod = .GET) -> YYHttp {
        let h = YYHttp()
        h.httpManager = YYHttpManager(httpMethod: method, urlString: urlString)
        return h
    }
    
    public func fetch(urlString: String, httpMethod method: YYHttpMethod = .GET) -> YYHttp {
        httpManager = YYHttpManager(httpMethod: method, urlString: urlString)
        return self
    }
    
    public func cancel(callback: (() -> Void)?) {
        httpManager.cancelCallback = callback
        httpManager.task.cancel()
    }
}

// MARK: - 向请求中添加额外信息
public extension YYHttp {
    public func addParams(params: [String: String]) -> Self {
        httpManager.addParams(params)
        return self
    }
    
    public func addHeaders(headers: [String: String]) -> Self  {
        httpManager.addHeaders(headers)
        return self
    }
    
    //add files to self, POST only
    public func addFiles(files: [YYHttpFile]) -> Self {
        httpManager.addFiles(files)
        return self
    }
}

// MARK: - 发起请求并通过闭包获取数据
public extension YYHttp {
    public func responseData(completion: (data: NSData?, response: NSHTTPURLResponse?, error: NSError?) -> Void) -> YYHttp {
        httpManager.fire(completion)
        return self
    }
    
    public func responseString(completion: (string: String?, response: NSHTTPURLResponse?, error: NSError?) -> Void) -> YYHttp {
        return responseData { (data, response, error) in
            var s: String?
            if let d = data {
                s = String(data: d, encoding: NSUTF8StringEncoding)
            }
            completion(string: s, response: response, error: error)
        }
    }
    
    public func responseJSON(completion: (dictOrArray: AnyObject?, response: NSHTTPURLResponse?, error: NSError?) -> Void) -> YYHttp {
        return responseData { (data, response, error) in
            var obj: AnyObject?
            var finalError = error
            if let d = data {
                do {
                    obj = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments)
                } catch let err as NSError {
                    finalError = err
                }
            }
            completion(dictOrArray: obj, response: response, error: finalError)
        }
    }
}










