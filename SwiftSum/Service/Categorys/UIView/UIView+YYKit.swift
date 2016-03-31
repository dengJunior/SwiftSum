//
//  UIView+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


extension UIView {
    // MARK: - 根据xib生成对象
    static func newInstanceFromNib() -> UIView? {
        let view = NSBundle.mainBundle().loadNibNamed(self.classNameString(), owner: nil, options: nil).first as? UIView
        return view
    }
}
















