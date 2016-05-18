//
//  BaseNavigationController.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class YYBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.translucent = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Override
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true;
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
