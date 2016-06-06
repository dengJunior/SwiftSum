//
//  AppNotification.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

// MARK: - 所有用到的通知
class AppNotification {
    //通知分类
    class DownLoad: YYNotificationType {
        enum Notification: String {
            case begin, finish
        }
    }
}

// MARK: - 使用demo
func demo() {
    AppNotification.DownLoad.postNotification(.begin)
}
