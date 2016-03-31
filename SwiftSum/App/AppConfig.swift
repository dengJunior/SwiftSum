//
//  AppConfig.swift
//  Justice
//
//  Created by sihuan on 16/3/21.
//  Copyright © 2016年 huan. All rights reserved.
//


// MARK: - http


struct HttpConfig {
    static let useTestUrl = true
    static let rootUrlTest = "http://kuaikou.jios.org:7777/justice/mobile"
    static let rootUrlProduction = "http://kuaikou.jios.org:7777/justice/mobile"
    static var rootUrl: String {
        return useTestUrl ? rootUrlTest : rootUrlProduction
    }
    
    static let kDeviceId = "kkou-device-id"
    static let kAppVersion = "app-version"
    static let kSessionId = "justice-session-id"
    static let kPixelWidth = "pixel-width"
    static let kGeTuiCid = "getui-cid"
}










