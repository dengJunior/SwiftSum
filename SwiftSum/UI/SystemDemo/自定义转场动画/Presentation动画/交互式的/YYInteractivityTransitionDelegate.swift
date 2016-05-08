//
//  YYInteractivityTransitionDelegate.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


class YYInteractivityTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer? = nil
    var targetEdge: UIRectEdge = .None
    
    /// 前两个函数和原来demo中的实现一致
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return YYInteractivityTransitionAnimator(targetEdge: targetEdge)
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
        return YYInteractivityTransitionAnimator(targetEdge: targetEdge)
    }
    
    /*
     设置了toViewController的transitioningDelegate属性并且present时，UIKit会从代理处获取animator，
     
     其实这里还有一个细节：UIKit还会调用代理的interactionControllerForPresentation:方法来获取交互式控制器，如果得到了nil则执行非交互式动画。
     
     如果获取到了不是nil的对象，那么UIKit不会调用animator的animateTransition方法，而是调用交互式控制器(还记得前面介绍动画代理的示意图么，交互式动画控制器和animator是平级关系)的startInteractiveTransition:方法。
     */
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print(#function)
        if let gestureRecognizer = self.gestureRecognizer {
            return YYInteractivityTransition(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
        }
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print(#function)
        if let gestureRecognizer = self.gestureRecognizer {
            return YYInteractivityTransition(gestureRecognizer: gestureRecognizer, edgeForDragging: targetEdge)
        }
        return nil
    }
}


























