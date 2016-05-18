//
//  YYBaseTabBarController.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - UITabBarController子controller信息的模型，
struct TabBarItemInfo {
    var storyBoardName: String!
    var titleTab: String?
    var titleNav: String?
    var imageNameDeselected: String?
    var imageNameSelected: String?
}

class YYBaseTabBarController: UITabBarController {

    let tabBarTransitionDelegate = YYTabBarTransitionDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = tabBarTransitionDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
