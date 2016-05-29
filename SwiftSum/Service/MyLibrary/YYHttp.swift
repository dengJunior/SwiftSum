//
//  YYHttp.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYHttp: NSObject {
    /// if set to true, Pitaya will log all information in a NSURLSession lifecycle
    public static var YYDebug = false
    
    var httpManager: YYHttpManager!
    
    /**
     创建请求方式
     */
    public static func build(httpMethod method: YYHttpMethod = .GET, urlString: String) -> YYHttp {
        let h = YYHttp()
        h.httpManager = YYHttpManager(httpMethod: method, urlString: urlString)
        return h
    }
    
    public func addParams(params: [String: String]) -> YYHttp {
        httpManager.addParams(params)
        return self
    }
    
    
    // MARK: - 获取数据3种方式
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












