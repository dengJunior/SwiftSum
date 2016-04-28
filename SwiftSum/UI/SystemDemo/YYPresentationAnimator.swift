//
//  YYPresentationAnimator.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

//动画的关键在于animator如何实现，实现了UIViewControllerAnimatedTransitioning协议
class YYPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    /// 设置动画的持续时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if let isAnimated = transitionContext?.isAnimated() {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    /// 设置动画的进行方式
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. 我们首先需要得到参与切换的两个ViewController的信息，使用context的方法拿到它们的参照；
        guard
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else {
                return
        }
        
        /*
         iOS8引入了viewForKey方法，尽可能使用这个方法而不是直接访问controller的view属性
         比如在form sheet样式中，我们为presentedViewController的view添加阴影或其他decoration，animator会对整个decoration view
         添加动画效果，而此时presentedViewController的view只是decoration view的一个子视图
         */
        guard
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
                return
        }
        
        /*
         prsenting时，fromViewController是要弹的那个
         dismiss时，fromViewController是被弹出的那个
         */
        let isPresenting = toViewController.presentingViewController == fromViewController
        
        /*
         prsenting时:
         fromViewInitialFrame = 0 0, 375 603
         fromViewFinalFrame = 0 0, 0 0
         toViewInitialFrame = 0 0, 0 0
         toViewFinalFrame= 0 0, 375 603
         
         dismiss时:
         fromViewInitialFrame = 0 0, 375 603
         fromViewFinalFrame = 0 0, 375 603
         toViewInitialFrame = 0 0, 0 0
         toViewFinalFrame= 0 0, 375 603
         */
        let fromViewInitialFrame = transitionContext.initialFrameForViewController(fromViewController)
        var fromViewFinalFrame = transitionContext.finalFrameForViewController(fromViewController)
        
        var toViewInitialFrame = transitionContext.initialFrameForViewController(toViewController)
        let toViewFinalFrame = transitionContext.finalFrameForViewController(toViewController)
        
        // 2. 将toView添加到containerView中；
        containerView.addSubview(toView)
        
        if isPresenting {
            // 3. 对于要呈现的VC，我们希望它从屏幕下方出现，因此将初始位置设置到屏幕下边缘；
            toViewInitialFrame = CGRectOffset(toViewFinalFrame, 0, CGRectGetHeight(toViewFinalFrame))
            toView.frame = toViewInitialFrame
        } else {
            //dismiss时，必须将toView放到后面，否则动画不会执行
            containerView.sendSubviewToBack(toView)
            fromViewFinalFrame = CGRectOffset(fromViewInitialFrame, 0, CGRectGetHeight(fromViewInitialFrame))
        }
        
        let transitionDuration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(transitionDuration, animations: {
            if isPresenting {
                toView.frame = toViewFinalFrame
            } else {
                fromView.frame = fromViewFinalFrame
            }
            
            }) { (_) in
                let wasCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!wasCancelled)
        }
    }
}



























