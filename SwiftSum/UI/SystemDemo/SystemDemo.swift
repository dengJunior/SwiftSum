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
            LibDemoInfo(title: "DesignPatternDemo", desc: "Swift中的iOS设计模式", controllerName: "DesignPatternDemo"),
            LibDemoInfo(title: "ThreadDemo", desc: "多线程相关", controllerName: "ThreadDemo"),
            LibDemoInfo(title: "RunLoopDemo", desc: "RunLoop相关", controllerName: "RunLoopDemo"),
            LibDemoInfo(title: "EventAndGestureDemo", desc: "手势和事件相关", controllerName: "EventAndGestureDemo"),
        ]
    }

}
