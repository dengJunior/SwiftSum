//
//  YYNetwork.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public protocol YYCacheable {
    var useCache: Bool { get set }
    var cacheJSON: Bool { get set }
    var cacheTimeInSecond: Int { get set }
    
    var cacheExpireDate: NSData? { get }
    var cacheVersion: Int { get }
    
    var cacheData: NSData? { get }
    var cacheDataJSON: AnyObject? { get }
    
    func cleanCache()
}


class YYNetwork: NSObject {

}
