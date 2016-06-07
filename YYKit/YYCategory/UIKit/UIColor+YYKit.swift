//
//  UIColor+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UIColor {
    public static func randomColor() -> UIColor {
        return UIColor(colorLiteralRed: Float(arc4random_uniform(256))/255.0, green: Float(arc4random_uniform(256))/255.0, blue: Float(arc4random_uniform(256))/255.0, alpha: 1)
    }
}
