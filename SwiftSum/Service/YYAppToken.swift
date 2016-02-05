//
//  YYAppToken.swift
//  SwiftSum
//
//  Created by yangyuan on 16/2/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

private extension NSDate {
    var isExpired: Bool {
        let now = NSDate()
        return self.compare(now) == NSComparisonResult.OrderedAscending
    }
}

struct YYAppToken {
    enum DefaultKeys: String {
        case TokenKey = "TokenKey"
        case TokenExpiry = "TokenExpiry"
    }
    
    // MARK: - Initializers
    
    let userDefaults: NSUserDefaults
    init(userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
        self.userDefaults = userDefaults
    }
    
    
    // MARK: - Properties
    
    var token: String? {
        get {
            return userDefaults.stringForKey(DefaultKeys.TokenKey.rawValue)
        }
        set(newToken) {
            userDefaults.setObject(newToken, forKey: DefaultKeys.TokenKey.rawValue)
        }
    }
    
    var expiry: NSDate? {
        get {
            return userDefaults.objectForKey(DefaultKeys.TokenExpiry.rawValue) as? NSDate
        }
        set(newExpiry) {
            userDefaults.setObject(newExpiry, forKey: DefaultKeys.TokenExpiry.rawValue)
        }
    }
    
    var expired: Bool {
        if let expiry = expiry {
            return expiry.isExpired
        }
        return true
    }
    
    var isValid: Bool {
        if let token = token {
            return token.lengthOfBytesUsingEncoding(NSUTF16StringEncoding) > 0 && !expired
        }
        return false
    }
}

