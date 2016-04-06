//
//  RunLoopDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - Runloop的优点

/*
 一般情况下，当我们使用NSRunLoop的时候，代码如下所示：
 
 do {
 
 [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopModebeforeDate:[NSDate distantFuture]];
 
 } while (!done);
 
 在上面的代码中，参数done为NO的时候，当前runloop会一直接收处理其他输入源，处理输入源之后会再回到runloop中等待其他的输入源；
 除非done为YES，否则当前流程一直再runloop中。
 */
class RunLoopDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var buttonCount = 2;
        
        self.addButtonToView("测试自定义runloop", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            let testThread = RunLoopDemo1()
            testThread.launch()
        }
        buttonCount += 1
        
        //启动一个线程，在while循环中等待线程执行完再接着往下运行。
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
        
        //启动一个线程，使用runloop，等待线程执行完再接着往下运行。
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
        
        //仅仅打印两条日志，用来测试UI是否能立即响应的。
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











