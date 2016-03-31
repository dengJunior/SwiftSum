//
//  NSObject+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension NSObject {
    
    // MARK: - 返回类名的String
    static func classNameString() -> String {
        /**
         默认是这样的 "SwiftSum.SimpleGestureRecognizers"
         
         其实这里的真正的类型名字还带有 module 前缀，也就是 Swift.String。
         直接 print 只是调用了 CustomStringConvertible 中的相关方法而已，
         你可以使用 debugPrint 来进行确认。
         关于更多地关于 print 和 debugPrint 的细节，
         可以参考 http://swifter.tips/print/
         */
//        return self.description()
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    func classNameString() -> String {
        /**
         使用dynamicType获取对象类型，http://swifter.tips/instance-type/
         */
        return self.dynamicType.classNameString()
    }
}
