//
//  ThreadDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ThreadDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonCount = 2;
        
        self.addButtonToView("测试NSThread", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            let testThread = TestThread()
            testThread.launchWithNSThread()
        }
        buttonCount += 1

        self.addButtonToView("TestBlockOperation", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let testBlockOperation = TestBlockOperation()
            testBlockOperation.start()
        }
        buttonCount += 1

        self.addButtonToView("测试自定义非并发Operation对象", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let testOperation = MyNonConcurrentOperation.init(withUrl: "http://www.baidu.com/s?wd=ios")
            testOperation.start()
        }
        buttonCount += 1

        self.addButtonToView("测试自定义并发Operation对象", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let testOperation = TestMyConcurrentOperation()
            testOperation.launch()
        }
        buttonCount += 1
        
        self.addButtonToView("测试Operation对象之间的依赖", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let testOperation = TestOperationDependency()
            testOperation.launch()
        }
        buttonCount += 1
        
        self.addButtonToView("测试OperationQueue", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let testOperation = TestOperationQueue()
            testOperation.launch()
        }
        buttonCount += 1
        
        self.addButtonToView("测试队列的收尾工作", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let testOperation = TestDispatchQueueCleanUp()
            testOperation.launch()
        }
        buttonCount += 1
        
    }


}
