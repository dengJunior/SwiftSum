//
//  YYSystemNotification.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


// MARK: - 系统通知，一种思路。。
public class YYSystemNotification {
    // MARK: - UIApplication相关的系统通知
    public class UIApplication: YYNotificationType {
        public enum Notification: String {
            case UIApplicationDidEnterBackgroundNotification
            case UIApplicationWillEnterForegroundNotification
            case UIApplicationDidFinishLaunchingNotification
            case UIApplicationDidBecomeActiveNotification
            case UIApplicationWillResignActiveNotification
            case UIApplicationDidReceiveMemoryWarningNotification
            case UIApplicationWillTerminateNotification
            case UIApplicationSignificantTimeChangeNotification
            case UIApplicationWillChangeStatusBarOrientationNotification // userInfo contains NSNumber with new orientation
            case UIApplicationDidChangeStatusBarOrientationNotification // userInfo contains NSNumber with old orientation
            case UIApplicationStatusBarOrientationUserInfoKey // userInfo dictionary key for status bar orientation
            case UIApplicationWillChangeStatusBarFrameNotification // userInfo contains NSValue with new frame
            case UIApplicationDidChangeStatusBarFrameNotification // userInfo contains NSValue with old frame
            case UIApplicationStatusBarFrameUserInfoKey // userInfo dictionary key for status bar frame
            case UIApplicationBackgroundRefreshStatusDidChangeNotification
        }
    }
}

// MARK: - 使用demo
func demo() {
    YYSystemNotification.UIApplication.postNotification(.UIApplicationDidBecomeActiveNotification)
}
