//
//  YYAnimationContrller.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYTransitionAnimator(transitionType: .Modal(.Present))
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYTransitionAnimator(transitionType: .Modal(.Dismiss))
    }
}

