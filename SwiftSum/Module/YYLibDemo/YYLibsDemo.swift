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
            LibDemoInfo(title: "DataStructureAndAlgorithmsDemo", desc: "数据结构和算法demo", controllerName: "DataStructureAndAlgorithmsDemo"),
            LibDemoInfo(title: "YYHudDemo", desc: "YYHudDemo", controllerName: "YYHudDemo"),
            LibDemoInfo(title: "GoodsViewController3", desc: "仿淘宝商品详情", controllerName: "GoodsViewController3"),
            LibDemoInfo(title: "NetworkDemo", desc: "NetworkDemo", controllerName: "NetworkDemo"),
            LibDemoInfo(title: "YYLoggerDemo", desc: "显示日志", controllerName: "YYLoggerDemo"),
            LibDemoInfo(title: "UsefulExperienceDemo", desc: "实用经验技巧", controllerName: "UsefulExperienceDemo"),
        ]
        
    }


}
