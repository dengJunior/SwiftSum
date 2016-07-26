//
//  UIPanGestureRecognizer+YYExtension.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


extension UIPanGestureRecognizer {
    //获取方向
    public var direction: YYDirection {
        /*
         velocityInView:这个方法，这个方法是获取手势在指定视图坐标系统的移动速度，结果发现这个速度是具有方向的，
         
         CGPoint velocity = [recognizer velocityInView:recognizer.view];
         if(velocity.x > 0) {//向右滑动}
         else { //向左滑动 }
         */
        let velocity = self.velocityInView(self.view)
        let x = velocity.x, y = velocity.y
        print(x, y)
        if fabs(x) > fabs(y) {
            return x > 0 ? .right : .left
        } else if fabs(x) < fabs(y) {
            return y > 0 ? .down : .up
        } else {
            return .unknown
        }
    }
}
