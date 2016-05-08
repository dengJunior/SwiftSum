//
//  YYInteractivityTransitionAnimator.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/*
 和非交互式动画中的animator类似。因为交互式的动画只是一种锦上添花，它必须支持非交互式的动画
 */
class YYInteractivityTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let targetEdge: UIRectEdge
    init(targetEdge: UIRectEdge) {
        self.targetEdge = targetEdge
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        print(#function)
        if let isAnimated = transitionContext?.isAnimated() {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                return
        }
        
        guard
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }
        print(#function)
        /// isPresenting用于判断当前是present还是dismiss
        let isPresenting = (toViewController.presentingViewController == fromViewController)
        let fromFrame = transitionContext.initialFrameForViewController(fromViewController)
        let toFrame = transitionContext.finalFrameForViewController(toViewController)
        
        /// offset结构体将用于计算toView的位置
        let offset: CGVector
        switch targetEdge {
        case UIRectEdge.Top:
            offset = CGVector(dx: 0, dy: 1)
        case UIRectEdge.Left:
            offset = CGVector(dx: 1, dy: 0)
        case UIRectEdge.Bottom:
            offset = CGVector(dx: 0, dy: -1)
        case UIRectEdge.Right:
            offset = CGVector(dx: -1, dy: 0)
        default :
            fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        containerView.addSubview(toView)
        /// 根据当前是dismiss还是present，横屏还是竖屏，计算好toView的初始位置以及结束位置
        if isPresenting {
            fromView.frame = fromFrame
            toView.frame = CGRectOffset(toFrame, CGRectGetWidth(toFrame) * offset.dx * -1, CGRectGetHeight(toFrame) * offset.dy * -1)
        } else {
            fromView.frame = fromFrame
            toView.frame = toFrame
            containerView.sendSubviewToBack(toView)
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            if isPresenting {
                toView.frame = toFrame
            } else {
                fromView.frame = CGRectOffset(fromFrame, CGRectGetWidth(fromFrame) * offset.dx, CGRectGetHeight(fromFrame) * offset.dy)
            }
            }) { (_) in
                let wasCanceled = transitionContext.transitionWasCancelled()
                if wasCanceled {toView.removeFromSuperview()}
                transitionContext.completeTransition(!wasCanceled)
        }
    }
}





























