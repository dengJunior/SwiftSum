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
            LibDemoInfo(title: "彻底解耦合的iOS架构", desc: "架构叫做EventMVVM。使用少量的MVVM架构", controllerName: "TodoStream"),
        ]
    }


}
