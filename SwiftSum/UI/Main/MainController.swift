//
//  MainController.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class MainController: YYBaseTabBarController {

    let tabBarItemInfos = [
        TabBarItemInfo(storyBoardName: "SystemDemo", titleTab: "SystemDemo", titleNav: nil, imageNameDeselected: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "YYLibDemo", titleTab: "YYLibDemo", titleNav: nil, imageNameDeselected: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "ThirdLibDemo", titleTab: "ThirdLibDemo", titleNav: nil, imageNameDeselected: nil, imageNameSelected: nil),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }

    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        //这样相当于添加新的controller
        var viewControllers = self.viewControllers ?? [UIViewController]()
        for itemInfo in tabBarItemInfos {
            if let initialVc = UIViewController.newInstanceFromStoryboard(itemInfo.storyBoardName, isInitial: true) {
                
                let tabBarItem = UITabBarItem()
                tabBarItem.title = itemInfo.titleTab
                if let image = itemInfo.imageNameDeselected {
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














