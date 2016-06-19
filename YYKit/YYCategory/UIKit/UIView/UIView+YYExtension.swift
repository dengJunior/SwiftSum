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
    public static func newInstanceFromNib() -> UIView? {
        let view = NSBundle(forClass: self).loadNibNamed(self.classNameString, owner: nil, options: nil).first as? UIView
        return view
    }
    
    // MARK: - 设为圆形
    public func setToRounded(radius: CGFloat? = nil) {
        let r = radius ?? min(self.frame.size.width, self.frame.size.height)/2;
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
}

extension UIView {
    /**
     添加填满父view的约束
     */
    public func addConstraintFillSuperView() {
        if let superview = superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            let top = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant: 0)
            let left = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: superview, attribute: .Leading, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant: 0)
            let right = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: superview, attribute: .Trailing, multiplier: 1, constant: 0)
            superview.addConstraints([top, left, bottom, right])
        }
    }
}














