//
//  YYTabBarTransitionDelegate.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYTabBarTransitionDelegate: NSObject, UITabBarControllerDelegate {
    
    var interactive = false
    let interactionController = UIPercentDrivenInteractiveTransition()
    
    //在<UITabBarControllerDelegate>对象里，实现该方法提供动画控制器，返回 nil 则没有动画效果。
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromIndex = tabBarController.viewControllers?.indexOf(fromVC)
        let toIndex = tabBarController.viewControllers?.indexOf(toVC)
        
        let tabChangeDirection: TabDirection = toIndex < fromIndex ? .Left : .Right
        let animator = YYTransitionAnimator(transitionType: YYTransitionType.Tab(tabChangeDirection))
        return animator
    }
    
    // MARK: - 交互式
    func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? interactionController : nil
    }
}


























