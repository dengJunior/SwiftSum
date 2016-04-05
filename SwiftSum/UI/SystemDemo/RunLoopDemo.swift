//
//  RunLoopDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class RunLoopDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonCount = 2;
        
        self.addButtonToView("buttonNormalThreadTestPressed", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { [unowned self] (button) in
            print("Enter buttonNormalThreadTestPressed")
            self.threadProcess1Finished = false
            print("Start a new thread.")
            
            NSThread.detachNewThreadSelector(#selector(RunLoopDemo.threadProce1), toTarget: self, withObject: nil)
            
            /**
             *  通常等待线程处理完后再继续操作的代码如下面的形式。
             在等待线程threadProce1结束之前，调用buttonTestPressed，界面没有响应，
             直到threadProce1运行完，才打印buttonTestPressed里面的日志。
             */
            while (!self.threadProcess1Finished) {
                NSThread.sleepForTimeInterval(0.5)
            }
            print("Exit buttonNormalThreadTestPressed")
        }
        buttonCount += 1
        
        self.addButtonToView("buttonRunloopPressed", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { [unowned self] (button) in
            print("Enter buttonRunloopPressed")
            self.threadProcess2Finished = false
            print("Start a new thread.")
            
            NSThread.detachNewThreadSelector(#selector(RunLoopDemo.threadProce2), toTarget: self, withObject: nil)
            
            /**
             *  使用runloop，情况就不一样了。
             在等待线程threadProce2结束之前，调用buttonTestPressed，
             界面立马响应，并打印buttonTestPressed里面的日志。
             */
            while (!self.threadProcess2Finished) {
                print("Begin runloop")
                NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
                print("End runloop")
            }
            print("Exit buttonRunloopPressed")
        }
        buttonCount += 1
        
        self.addButtonToView("buttonTestPressed", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            print("Enter buttonTestPressed")
            print("Exit buttonTestPressed")
        }
    }


    var threadProcess1Finished = false
    
    func threadProce1() {
        print("Enter threadProce1.")
        for index in 1...5 {
            print("InthreadProce1 count = \(index)")
            sleep(1)
        }
        threadProcess1Finished = true
        print("Exit threadProce1.")
    }
    
    
    var threadProcess2Finished = false
    
    func threadProce2() {
        print("Enter threadProce2.")
        for index in 1...5 {
            print("InthreadProce2 count = \(index)")
            sleep(1)
        }
        threadProcess2Finished = true
        print("Exit threadProce2.")
    }
    
    
    
}











