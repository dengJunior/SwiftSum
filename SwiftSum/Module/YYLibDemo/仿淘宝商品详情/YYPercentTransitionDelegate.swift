//
//  YYPercentTransitionDelegate.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYPercentTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var targetEdge: UIRectEdge = .None
    init(targetEdge: UIRectEdge) {
        self.targetEdge = targetEdge
    }
    
    weak var percentTransition: YYPercentTransition? = nil
    //设置百分比
    var offset:CGFloat = 0 {
        didSet {
            guard let viewWidth = self.percentTransition?.viewWidth,
                let viewHeight = self.percentTransition?.viewHeight else {
                    return
            }
            var maxLength:CGFloat = 0
            switch targetEdge {
            case UIRectEdge.Top:
                maxLength = viewHeight
            case UIRectEdge.Left:
                maxLength = viewWidth
            case UIRectEdge.Bottom:
                maxLength = viewHeight
            case UIRectEdge.Right:
                maxLength = viewWidth
            default :
                maxLength = viewHeight
            }
            self.percentTransition?.percent = max(0, offset/maxLength)
        }
    }
    
    func finish() {
        self.percentTransition?.finish()
    }
    
    /// 前两个函数和原来demo中的实现一致
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return YYInteractivityTransitionAnimator(targetEdge: targetEdge)
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return YYInteractivityTransitionAnimator(targetEdge: targetEdge)
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let animator = YYPercentTransition()
        percentTransition = animator
        return animator
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
