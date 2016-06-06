//
//  UITabBarController+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit



extension UITabBarController {
    // MARK: - 根据TabBarItemInfo往UITabBarController中添加viewControllers
    public func appendViewControllers(tabBarItemsInfo: [TabBarItemInfo]) {
        //这样相当于添加新的controller
        var viewControllers = self.viewControllers ?? [UIViewController]()
        for itemInfo in tabBarItemsInfo {
            if let initialVc = UIViewController.newInstanceFromStoryboard(itemInfo.storyBoardName, isInitial: true) {
                
                let tabBarItem = UITabBarItem()
                tabBarItem.title = itemInfo.titleTab
                if let image = itemInfo.imageName {
                    tabBarItem.image = UIImage(named: image)
                }
                if let image = itemInfo.imageNameSelected {
                    tabBarItem.selectedImage = UIImage(named: image)
                }
                
                initialVc.tabBarItem = tabBarItem
                viewControllers.append(initialVc)
            }
        }
        self.viewControllers = viewControllers
    }
}