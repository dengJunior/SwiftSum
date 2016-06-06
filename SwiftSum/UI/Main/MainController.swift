//
//  MainController.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class MainController: YYBaseTabBarController {

    let tabBarItemsInfo = [
        TabBarItemInfo(storyBoardName: "SystemDemo", titleTab: "SystemDemo", imageName: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "YYLibDemo", titleTab: "YYLibDemo", imageName: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "ThirdLibDemo", titleTab: "ThirdLibDemo", imageName: nil, imageNameSelected: nil),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }

    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        self.appendViewControllers(tabBarItemsInfo)
    }
}














