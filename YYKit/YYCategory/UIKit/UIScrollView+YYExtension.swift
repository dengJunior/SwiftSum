//
//  YYExtension.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UIScrollView {
    /*
     1. 下拉到超出顶部的时候为负数
     2. 上拉到超出底部的时候为正数
     3. 其他时候为0
     */
    public var overflowingY: CGFloat {
        var overflowing: CGFloat = 0
        if contentOffset.y < 0 {
            overflowing = contentOffset.y
        } else {
            overflowing = contentOffset.y - (contentSize.height - bounds.size.height)
            overflowing = overflowing > 0 ? overflowing : 0
        }
        return overflowing
    }
    public var overflowingX: CGFloat {
        var overflowing: CGFloat = 0
        if contentOffset.x < 0 {
            overflowing = contentOffset.x
        } else {
            overflowing = contentOffset.x - (contentSize.width - bounds.size.width)
            overflowing = overflowing > 0 ? overflowing : 0
        }
        return overflowing
    }
}
