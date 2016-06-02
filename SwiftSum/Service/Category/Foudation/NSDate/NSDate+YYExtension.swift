//
//  NSDate+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

struct TimeValues {
    static let defaultFormatter = NSDateFormatter()
    static let defaultFormat = "yyyy-MM-dd HH:mm:ss"
    static let defaultTimeZone = NSTimeZone.systemTimeZone()
    static let defaultLocale = NSLocale.autoupdatingCurrentLocale()
}

// MARK: - to String
extension NSDate {
    func stringFromFormatDefault() -> String {
        return self.stringFromFormat(nil, timeZone: nil, locale: nil)
    }
    
    func stringFromFormat(format: String?) -> String {
        return self.stringFromFormat(format, timeZone: nil, locale: nil)
    }
    
    func stringFromFormat(format: String?, timeZone: NSTimeZone?) -> String {
        return self.stringFromFormat(format, timeZone: timeZone, locale: nil)
    }
    
    func stringFromFormat(format: String?, timeZone: NSTimeZone?, locale: NSLocale?) -> String {
        let formatter = TimeValues.defaultFormatter
        formatter.dateFormat = format ?? TimeValues.defaultFormat
        formatter.timeZone = timeZone ?? TimeValues.defaultTimeZone
        formatter.locale = locale ?? TimeValues.defaultLocale
        
        return formatter.stringFromDate(self)
    }
}














