//
//  YYCycleGestureRecognizer.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

// MARK: - 画圆手势

class YYCycleGestureRecognizer: UIGestureRecognizer, UIGestureRecognizerDelegate {
    
    // MARK: - Const
    
    var points: Array<CGPoint>!
    var firstTouchDate: NSDate!
    
    // MARK: - Property
    
    var dataArray = []
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        
    }
    
    // MARK: - Override
    
    /**
     如果你的手势识别器过渡到Recognized/Ended, Canceled, 或者Failed状态，
     UIGestureRecognizer 类会在在手势识别器过渡回Possible状态前调用reset 方法。
     */
    override func reset() {
        super.reset()
        print(#function)
        state = UIGestureRecognizerState.Possible
        points = nil
        firstTouchDate = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        print(#function)
        
        if touches.count > 1 {
            state = .Failed
            return
        }
        points = []
        firstTouchDate = NSDate()
        if let touch = touches.first {
            points.append(touch.locationInView(view))
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        print(#function)
        if state == .Failed {
            return
        }
        
        /*
         大多是应用程序都有多个视图。
         一般来说，你应该把触摸位置转换为屏幕的坐标系，这样你就可以正确的识别出跨越(span)多个视图的手势。
         */
        if let touch = touches.first {
            points.append(touch.locationInView(view))
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        print(#function)
        let detectionSuccess = true
        
        state = detectionSuccess ? UIGestureRecognizerState.Recognized : .Failed
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesCancelled(touches, withEvent: event)
        print(#function)
    }
    
    // MARK: - Private
    
    func _private() -> Void {
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
    
}
