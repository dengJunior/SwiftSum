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
        let view = NSBundle.mainBundle().loadNibNamed(self.classNameString, owner: nil, options: nil).first as? UIView
        return view
    }
    
    // MARK: - 设为圆形
    func setToRounded(radius: CGFloat? = nil) {
        let r = radius ?? min(self.frame.size.width, self.frame.size.height)/2;
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
}
















