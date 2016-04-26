//
//  AutoresizingMaskDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class AutoresizingMaskDemo: UIView {
    
    override init(frame: CGRect) {
        let rect = CGRect(x: 0, y: 0, width: 180, height: 200)
        super.init(frame: rect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContext() {
        self.backgroundColor = UIColor.lightGrayColor()
        
        let rect = CGRect(x: 50, y: 50, width: 100, height: 80)
        let view = UIView(frame: rect)
        view.backgroundColor = UIColor.yellowColor()
        self.addSubview(view)
    }
    
    func changeSubViewMask() {
        if let view = self.subviews.first {
            view.autoresizingMask = [
                .FlexibleHeight,//改变自己高度来适应superView高度增量变化
                .FlexibleWidth,
                
                //2个同时设置，view水平居中
//                .FlexibleLeftMargin,//改变左边距，保证和superView右边距离不变
//                .FlexibleRightMargin,//改变右边距，保证和superView左边距离不变
                
//                .FlexibleTopMargin,//同。。
//                .FlexibleBottomMargin//同。。
            ];
        }
    }
    
    /**layoutSubviews中适合做下面事
     1. 调整任何临近子视图的尺寸和位置。
     2. 添加或删除子视图或内核动画层。
     3. 通过调用 setNeedsDisplay 或 setNeedsDisplayInRect: 方法来强制子视图重新绘制。
     */
    override func layoutSubviews() {
        print(#function)
    }
    
    /**
     通过重载一个或多个以下方法：监听任何跟视图层次结构相关的状态信息
     如果在init中添加subView打印如下：
     
     didAddSubview
     willMoveToSuperview
     didMoveToSuperview()
     willMoveToWindow
     didMoveToWindow()
     */
    override func willMoveToSuperview(newSuperview: UIView?) {
        print(#function)
        /**
         *  在view即将被加入到一个view时，再添加subView
         */
        if (newSuperview != nil) {
            setContext()
        }
    }
    override func didMoveToSuperview() {
        print(#function)
    }
    
    override func didAddSubview(subview: UIView) {
        print(#function)
    }
    override func willRemoveSubview(subview: UIView) {
        print(#function)
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        print(#function)
    }
    override func didMoveToWindow() {
        print(#function)
    }
    
}
