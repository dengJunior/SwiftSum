//
//  YYAnimation.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

enum YYAnimationType {
    case None
    case FadeIn, FadeOut
    case ZoomIn, ZoomOut
}

class YYAnimation: UIView {

    static let Duration = 0.3
    static let ZoomScaleOffset = CGFloat(0.2)
    
    static func animatedWithView(view: UIView, duration: NSTimeInterval = Duration, delay: NSTimeInterval = 0, type: YYAnimationType = .None, completion: ((Bool) -> Void)? = nil) {
        var options: UIViewAnimationOptions = []
        var animations: () -> Void = {}
        switch type {
        case .None:
            break
        case .FadeIn:
            options = [.CurveEaseIn]
            view.alpha = 0
            animations = { view.alpha = 1 }
        case .FadeOut:
            options = [.CurveEaseOut]
            view.alpha = 1
            animations = { view.alpha = 0 }
        case .ZoomIn:
            options = [.CurveEaseIn]
            view.transform = CGAffineTransformScale(view.transform, 1.0 - ZoomScaleOffset, 1.0 - ZoomScaleOffset)
            animations = { view.transform = CGAffineTransformIdentity }
        case .ZoomOut: 
            options = [.CurveEaseOut]
            view.transform = CGAffineTransformScale(view.transform, 1.0 + ZoomScaleOffset, 1.0 + ZoomScaleOffset)
            animations = { view.transform = CGAffineTransformIdentity }
        }
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}
