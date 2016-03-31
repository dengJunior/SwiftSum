//
//  YYColorManager.swift
//  Justice
//
//  Created by sihuan on 16/3/21.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

// MARK: - 十六进制的颜色值直接转为UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexValue:Int) {
        self.init(red:(hexValue >> 16) & 0xff, green:(hexValue >> 8) & 0xff, blue:hexValue & 0xff)
    }
}

struct AppColor {
    static var sytem: UIColor {
        get {
            return UIColor(hexValue: 0x007aff)
        }
    }
    static var flattingBlue: UIColor {
        return UIColor(hexValue: 0x27a7e0)
    }
    static var flattingLine: UIColor {
        return UIColor(hexValue: 0xc7c7c7)
    }
}










