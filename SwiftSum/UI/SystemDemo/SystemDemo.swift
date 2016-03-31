//
//  SystemDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class SystemDemo: YYBaseDemoController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataArray = [
            LibDemoInfo(title: "EventAndGestureDemo", desc: "手势和事件相关", controllerName: "EventAndGestureDemo"),
        ]
    }

}
