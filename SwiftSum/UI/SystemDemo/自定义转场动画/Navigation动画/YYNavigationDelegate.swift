//
//  YYNavigationDelegate.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYNavigationDelegate: NSObject, UINavigationControllerDelegate {
    
    //因此仅在确实处于交互状态时才提供交互控制器，可以使用一个变量来标记交互状态，该变量由交互手势来更新状态。
    var interactive = false
    let interactionController = UIPercentDrivenInteractiveTransition()
    
    //在<UINavigationControllerDelegate>对象里，实现该方法提供动画控制器，返回 nil 则使用系统默认的效果。
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYTransitionAnimator(transitionType: .Navigation(operation))
    }
    
    //如果在转场代理中提供了交互控制器，而转场发生时并没有方法来驱动转场进程(比如手势)，转场过程将一直处于开始阶段无法结束，应用界面也会失去响应：
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? interactionController : nil
    }
}
