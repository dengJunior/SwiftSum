//
//  YYXibView.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYXibView: UIView {
    public weak var xibContentView: UIView?
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview != nil && xibContentView == nil {
            loadXibView()
        }
        super.willMoveToSuperview(newSuperview)
    }
    
    func loadXibView() {
        guard let xibView = NSBundle.mainBundle().loadNibNamed(self.classNameString, owner: self, options: nil).first as? UIView else {
            return
        }
        xibView.backgroundColor = UIColor.clearColor()
        xibView.translatesAutoresizingMaskIntoConstraints = true
        xibView.autoresizingMask = [
            .FlexibleHeight,
            .FlexibleWidth,
            .FlexibleTopMargin,
            .FlexibleLeftMargin,
            .FlexibleBottomMargin,
            .FlexibleRightMargin
        ]
        xibView.frame = self.bounds
        addSubview(xibView)
        xibContentView = xibView
    }
    
}
