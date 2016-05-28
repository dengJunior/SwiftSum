//
//  AppConfig.swift
//  Justice
//
//  Created by sihuan on 16/3/21.
//  Copyright © 2016年 huan. All rights reserved.
//


// MARK: - http

import UIKit

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

struct AppInfo {
    // MARK: - 尺寸相关
    
    //状态栏高度
    static let statusBarHeight = CGFloat(20)
    //NavBar高度
    static let navigationBarHeight = CGFloat(44)
    //状态栏 ＋ 导航栏 高度
    static let statusAndNavigationHeight = statusBarHeight + navigationBarHeight
    
    //屏幕 rect
    static let screenBounds = UIScreen.mainScreen().bounds
    //屏幕宽度
    static let screenWidth = UIScreen.mainScreen().bounds.size.width
    //屏幕高度
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
    static let contentHeight = screenHeight - statusAndNavigationHeight
    static let screenScale = UIScreen.mainScreen().scale
    //屏幕分辨率
    static let screenResolution = screenWidth * screenHeight * screenScale
    
    //广告栏高度
    static let bannerHeighrt = 215
    
    // MARK: - 系统相关
    static let systemVersion = Float(UIDevice.currentDevice().systemVersion)
    static let systemVersionString = UIDevice.currentDevice().systemVersion
    
    //获取当前语言
    static let currentLanguage = NSLocale.preferredLanguages().first!
}















