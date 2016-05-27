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
            LibDemoInfo(title: "WKWebViewDemo", desc: "WKWebView相关", controllerName: "WKWebViewDemo"),
            LibDemoInfo(title: "CustomTransitionDemo", desc: "自定义转场动画", controllerName: "CustomTransitionDemo"),
            LibDemoInfo(title: "ViewControllerGuideDemo", desc: "ViewControllerGuideDemo", controllerName: "ViewControllerGuideDemo"),
            LibDemoInfo(title: "ViewGuideDemo", desc: "ViewGuide", controllerName: "ViewGuideDemo"),
            LibDemoInfo(title: "DesignPatternDemo", desc: "Swift中的iOS设计模式", controllerName: "DesignPatternDemo"),
            LibDemoInfo(title: "ThreadDemo", desc: "多线程相关", controllerName: "ThreadDemo"),
            LibDemoInfo(title: "RunLoopDemo", desc: "RunLoop相关", controllerName: "RunLoopDemo"),
            LibDemoInfo(title: "EventAndGestureDemo", desc: "手势和事件相关", controllerName: "EventAndGestureDemo"),
            LibDemoInfo(title: "SystemControlDemo", desc: "常用系统控件demo", controllerName: "SystemControlDemo"),
        ]
    }
    
    /**
     在其他线程中创建view，主线程中添加，结果没有crash
     */
    func testCreateViewInOtherThread() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let view = UIView()
            view.backgroundColor = UIColor.redColor()
            view.frame = self.view.bounds
            dispatch_async(dispatch_get_main_queue(), { 
                self.view.addSubview(view)
            })
        }
    }

}
