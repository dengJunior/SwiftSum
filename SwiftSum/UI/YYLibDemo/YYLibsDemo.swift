//
//  YYLibsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/1/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYLibsDemo: YYBaseDemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataArray = [
            LibDemoInfo(title: "GoodsViewController", desc: "仿淘宝商品详情", controllerName: "GoodsViewController"),
            LibDemoInfo(title: "NetworkDemo", desc: "NetworkDemo", controllerName: "NetworkDemo"),
            LibDemoInfo(title: "YYLoggerDemo", desc: "显示日志", controllerName: "YYLoggerDemo"),
        ]
    }


}
