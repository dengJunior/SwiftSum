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
    
    /**
     transitionContext 过渡动画开始前，UIKit创建过渡环境对象，并添加如何执行动画的信息。
     过渡环境对象是代码中的重要部分。它实现了UIViewControllerContextTransitioning协议并存储与过渡相关的视图控制器和视图的引用。
     它还存储如何执行过渡的信息，包括该动画是否为交互式。动画对象需要这些信息来建立和执行实际动画。
     
     注意：总是使用过渡环境对象中的对象和数据，而不是你自己管理的任何缓存信息。
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. 我们首先需要得到参与切换的两个ViewController的信息，使用context的方法拿到它们的参照；
        guard
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            
            /*
             你创建的动画应该发生在提供的容器视图中。
             例如，当present一个视图控制器，将其视图添加到容器视图中作为子视图。
             容器视图可能是窗口或一个普通视图，但是配置容器视图是为了运行动画。
             */
            let containerView = transitionContext.containerView() else {
                return
        }
        
        /*
         iOS8引入了viewForKey方法，尽可能使用这个方法而不是直接访问controller的view属性
         比如在form sheet样式中，我们为presentedViewController的view添加阴影或其他decoration，animator会对整个decoration view
         添加动画效果，而此时presentedViewController的view只是decoration view的一个子视图
         */
        guard
            /*出现这个问题。。
             Printing description of toView:
             expression produced error: Execution was interrupted, reason: EXC_BAD_ACCESS (code=EXC_I386_GPFLT).
             The process has been returned to the state before expression evaluation.
             */
            //            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            //            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            let fromView = fromViewController.view,
            let toView = toViewController.view
            else {
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



























