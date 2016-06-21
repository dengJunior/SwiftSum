//
//  TestTimer.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class timerThread: NSThread {
    var myTimer: NSTimer!
    
    init(timer: NSTimer) {
        self.myTimer = timer
    }
    
    override func main() {
        autoreleasepool { 
            let runloop = NSRunLoop.currentRunLoop()
            /**
             *  想将Timer事件源添加至其他线程Run Loop的其他模式下，
             需要创建NSTimer对象，并使用NSRunLoop的addTimer:forMode:方法添加创建好的NSTimer对象：
             */
            runloop.addTimer(myTimer, forMode: NSRunLoopCommonModes)
            print(NSThread.isMultiThreaded())
            runloop.runUntilDate(NSDate(timeIntervalSinceNow: 5))
        }
    }
}

class TestTimer: NSObject {
    func testTimerSource() {
        
        let fireTimer = NSDate(timeIntervalSinceNow: 1)
        
        let myTimer = NSTimer(fireDate: fireTimer, interval: 0.5, target: self, selector: #selector(timerTask), userInfo: nil, repeats: true)
        
        let customThread = timerThread(timer: myTimer)
        
        customThread.start()
        
        sleep(5)
        
    }
    
    func timerTask() {
        
        print("Fire timer...")
        
    }
    
    
    //在Core Foundation框架中，也为我们提供了一系列相关的类和方法为Run Loop添加Timer事件源
    func testCFTimerSource() {
        let cfRunloop = CFRunLoopGetCurrent()
        var cfRunloopTimerContext = CFRunLoopTimerContext(version: 0, info: unsafeBitCast(self, UnsafeMutablePointer<Void>.self), retain: nil, release: nil, copyDescription: nil)
        let cfRunloopTiemr = CFRunLoopTimerCreate(kCFAllocatorDefault, 1, 0.5, 0, 0, cfRunloopTimerCallback(), &cfRunloopTimerContext)
        CFRunLoopAddTimer(cfRunloop, cfRunloopTiemr, kCFRunLoopDefaultMode)
        CFRunLoopRun()
    }
    func cfRunloopTimerCallback() -> CFRunLoopTimerCallBack {
        return { (cfRunloopTimer, info) -> Void in
            print("cfRunloopTimerCallback Fire timer...")
        }
    }

}


















