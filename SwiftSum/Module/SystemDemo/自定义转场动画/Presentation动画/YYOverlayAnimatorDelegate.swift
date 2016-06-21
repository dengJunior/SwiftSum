//
//  YYOverlayAnimator.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYOverlayAnimatorDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYOverlayAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYOverlayAnimator()
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return YYOverlayPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}