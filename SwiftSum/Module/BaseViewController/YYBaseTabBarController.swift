//
//  YYBaseTabBarController.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYBaseTabBarController: UITabBarController {
    //自定义转场动画
    let tabBarTransitionDelegate = YYTabBarTransitionDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = tabBarTransitionDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
