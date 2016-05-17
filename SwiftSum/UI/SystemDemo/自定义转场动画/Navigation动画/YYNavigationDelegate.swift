//
//  YYNavigationDelegate.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYNavigationDelegate: NSObject, UINavigationControllerDelegate {
    var interactive = false
    //在<UINavigationControllerDelegate>对象里，实现该方法提供动画控制器，返回 nil 则使用系统默认的效果。
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYTransitionAnimator(transitionType: .Navigation(operation))
    }
}
