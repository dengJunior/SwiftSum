//
//  BaseNavigationController.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit


extension UIViewController {
    var yy_interactivePopDisabled: Bool {
        return true
    }
    var yy_prefersNavigationBarHidden: Bool {
        return true
    }
    var yy_interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat {
        return 44
    }
}

class YYFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    weak var navigationController: UINavigationController!
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            // Ignore when no view controller is pushed into the navigation stack.
            if navigationController.viewControllers.count <= 1 {
                return false
            }
            
            // Ignore when the active view controller doesn't allow interactive pop.
            let topViewController = navigationController.viewControllers.last!
            if topViewController.yy_interactivePopDisabled {
                return false
            }
            
            // Ignore when the beginning location is beyond max allowed initial distance to left edge.
            let beginningLocation = gestureRecognizer.locationInView(gestureRecognizer.view)
            let maxAllowedInitialDistance = topViewController.yy_interactivePopMaxAllowedInitialDistanceToLeftEdge
            if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance {
                return false
            }
            
            // Ignore pan gesture when the navigation controller is currently in transition.
            if let isTransitioning = navigationController.valueForKey("_isTransitioning")?.boolValue {
                if isTransitioning {
                    return false
                }
            }
            
            // Prevent calling the handler when the gesture begins in an opposite direction.
            let translation = gestureRecognizer.translationInView(gestureRecognizer.view)
            if translation.x <= 0 {
                return false
            }
            return true
        }
        return false
    }
}

class YYBaseNavigationController: UINavigationController {

    /// The gesture recognizer that actually handles interactive pop.
    let yy_fullscreenPopGestureRecognizer: UIPanGestureRecognizer = {
       let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    /// A view controller is able to control navigation bar's appearance by itself,
    /// rather than a global way, checking "fd_prefersNavigationBarHidden" property.
    /// Default to YES, disable it if you don't want so.
    var yy_viewControllerBasedNavigationBarAppearanceEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.translucent = false;
    }

    // MARK: - Override
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true;
        }
        
        if let pop = interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(yy_fullscreenPopGestureRecognizer) {
            // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
            interactivePopGestureRecognizer?.view?.addGestureRecognizer(yy_fullscreenPopGestureRecognizer)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func shouldAutorotate() -> Bool {
        return (self.topViewController?.shouldAutorotate())!;
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (self.topViewController?.supportedInterfaceOrientations())!
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.topViewController;
    }
}
