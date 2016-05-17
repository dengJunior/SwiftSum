//
//  YYOverlayAnimator.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYOverlayAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if let isAnimated = transitionContext?.isAnimated() {
            return isAnimated ? 0.35 : 0
        }
        return 0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            containerView = transitionContext.containerView(),
            fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else{
                return
        }
        
        let fromView = fromVC.view
        let toView = toVC.view
        let duration = self.transitionDuration(transitionContext)
        
        //不像容器 VC 转场里需要额外的变量来标记操作类型，UIViewController 自身就有方法跟踪 Modal 状态。
        //处理 Presentation 转场：
        if toVC.isBeingPresented() {
            containerView.addSubview(toView)
            let toViewWidth = containerView.frame.width*2 / 3,
            toViewHeight = containerView.frame.height*2 / 3
            toView.center = containerView.center
            toView.bounds = CGRect(x: 0, y: 0, width: 1, height: toViewHeight)
            
            //iOS8以上，dimmingView交给YYOverlayPresentationController控制了
            if #available(iOS 8, *){
                UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                    toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                    }, completion: {_ in
                        let isCancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(!isCancelled)
                })
            } else {
                let dimmingView = UIView()
                containerView.insertSubview(dimmingView, belowSubview: toView)
                dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                dimmingView.center = containerView.center
                dimmingView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: {
                    dimmingView.bounds = containerView.bounds
                    toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                    }, completion: { _ in
                        let isCancelled = transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(!isCancelled)
                })
                
            }
        }
        
        //Dismissal 转场中不要将 toView 添加到 containerView
        if fromVC.isBeingDismissed() {
            
            //在一般通用型的动画控制器里可以这样处理
            if !(transitionContext.presentationStyle() == .Custom && fromVC.isBeingDismissed()){
                containerView.addSubview(toView)
            }
            
            let fromViewHeight = fromView.frame.height
            
            UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
                fromView.bounds = CGRect(x: 0, y: 0, width: 1, height: fromViewHeight)
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
    }
    
}






















