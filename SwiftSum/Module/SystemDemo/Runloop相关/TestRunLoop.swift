//
//  RunLoopDemo1.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - Runloop简单实例 

class TestRunLoop: NSObject {
    
    /**
     launch()方法在主线程中，通过NSThread类的类方法detachNewThreadSelector:toTarget:withObject:创建并启动一个二级线程，
     将createAndConfigObserverInSecondaryThread()方法作为事件消息传入该二级线程，
     这个方法的主要作用就是在二级线程中创建配置Run Loop观察者并启动Run Loop，
     然后让主线程持续3秒，以便二级线程有足够的时间执行任务。
     */
    func launch() -> Void {
        
        print("First event in Main Thread.")
        
        NSThread.detachNewThreadSelector(#selector(TestRunLoop.createAndConfigObserverInSecondaryThread), toTarget: self, withObject: nil)
        
        print(NSThread.isMultiThreaded())
        
        sleep(3)
        
        print("Second event in Main Thread.")
    }
    
    func observerCallbackFunc() -> CFRunLoopObserverCallBack {
        
        return {(observer, activity, context) -> Void in
            
            switch(activity) {
                
            case CFRunLoopActivity.Entry:
                print("Run Loop已经启动")
                break
            case CFRunLoopActivity.BeforeTimers:
                print("Run Loop分配定时任务前")
                break
            case CFRunLoopActivity.BeforeSources:
                print("Run Loop分配输入事件源前")
                break
            case CFRunLoopActivity.BeforeWaiting:
                print("Run Loop休眠前")
                break
            case CFRunLoopActivity.AfterWaiting:
                print("Run Loop休眠后")
                break
            case CFRunLoopActivity.Exit:
                print("Run Loop退出后")
                break
            default:
                break
                
            }
            
        }
        
    }
    
    
    func createAndConfigObserverInSecondaryThread() {
        autoreleasepool {
            // MARK: - 配置Run Loop观察者
            /*
             在Cocoa框架中，并没有提供创建配置Run Loop观察者的相关接口，所以我们只能通过Core Foundation框架中提供的对象和方法创建并配置Run Loop观察者
             */
            
            //1. 获得当前thread的Runloop
            let currentRunLoop = NSRunLoop.currentRunLoop()
            
            //2. 申明当前对象的变量
            var _self = self;
            
            //3. 设置Run loop observer的运行环境
            /*
             version：结构体版本号，必须设置为0。
             info：上下文中retain、release、copyDescription三个回调函数以及Run Loop观察者的回调函数所有者对象的指针。
             
             在Swift中，UnsafePointer结构体代表C系语言中申明为常量的指针，
             UnsafeMutablePoinger结构体代表C系语言中申明为非常量的指针，比如说：
             
             C:
             void functionWithConstArg(const int *constIntPointer);
             
             Swift:
             func functionWithConstArg(constIntPointer: UnsafePointer<Int32>)
             
             C:
             void functionWithNotConstArg(unsigned int *unsignedIntPointer);
             
             Swift:
             func functionWithNotConstArg(unsignedIntPointer: UnsafeMutablePointer<UInt32>)
             
             C:
             void functionWithNoReturnArg(void *voidPointer);
             
             Swift:
             func functionWithNoReturnArg(voidPointer: UnsafeMutablePointer<Void>)
             */
            var context = CFRunLoopObserverContext.init(version: 0, info: &_self, retain: nil, release: nil, copyDescription: nil)
            
            
            /*
             4. 创建Run loop observer对象
             
             allocator：该参数为对象内存分配器，一般使用默认的分配器kCFAllocatorDefault。
             activities：该参数配置观察者监听Run Loop的哪种运行状态。在示例中，我们让观察者监听Run Loop的所有运行状态。
             repeats：该参数标识观察者只监听一次还是每次Run Loop运行时都监听。
             order：观察者优先级，当Run Loop中有多个观察者监听同一个运行状态时，那么就根据该优先级判断，0为最高优先级别。
             callout：观察者的回调函数，在Core Foundation框架中用CFRunLoopObserverCallBack重定义了回调函数的闭包。
             context：观察者的上下文。
             */
            let observer = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.AllActivities.rawValue, true, 0, observerCallbackFunc(), &context)
            
            /*
             在配置Run Loop之前，我们必须添加一个事件源或者Timer source给它。如果Run Loop没有任何源需要监视的话，会立刻退出。同样的我们可以给Run Loop注册Observer。
             */
            if observer != nil {
                /*
                 5. 因为NSRunLoop没有提供操作观察者的接口，所以我们需要getCFRunLoop()方法获取到CFRunLoop对象。
                 */
                let cfRunLoop = currentRunLoop.getCFRunLoop()
                
                /**
                 6. 将新建的observer加入到当前thread的runloop,
                 一个观察者只能被添加到一个Run Loop中，但是可以被添加到Run Loop中的多个模式中。
                 */
                CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode)
            }
            
            /*
             7. 通过Timer事件源向当前线程发送重复执行的定时任务，时间间隔为1秒，
             另外前文中提到过，如果Run Loop中没有任何数据源，那么Run Loop启动后会立即退出，
             所以大家可以把这行注释了运行看看会有什么效果。（runloop启动后会马上退出）
             */
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TestRunLoop.timerProcess), userInfo: nil, repeats: true)
            
            
            /*
             8. 通过NSRunLoop对象的runUntilDate(limitDate: NSDate)方法启动Run Loop，设置Run Loop的运行时长为1秒。
             这里将其放在一个循环里，最大循环次数为10次，也就是说，如果不考虑主线程的运行时间，该二级线程的Run Loop可运行10次。
             */
            var loopCount = 10
            repeat {
                /**
                 启动当前thread的loop直到所指定的时间到达，在loop运行时，runloop会处理所有来自与该run loop联系的inputsource的数据
                 
                 对于本例与当前run loop联系的inputsource只有一个Timer类型的source。
                 
                 该Timer每隔1秒发送触发事件给runloop，run loop检测到该事件时会调用相应的处理方法。
                 
                 由于在run loop添加了observer且设置observer对所有的runloop行为都感兴趣。
                 
                 当调用runUnitDate方法时，observer检测到runloop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
                 
                 observer检测到runloop的其它行为并调用回调函数的操作与上面的描述相类似。
                 */
                currentRunLoop.runUntilDate(NSDate(timeIntervalSinceNow: 1))
                print("currentRunLoop.runUntilDate")
                /**
                 当run loop的运行时间到达时，会退出当前的runloop。
                 observer同样会检测到runloop的退出行为并调用其回调函数，第二个参数所传递的行为是kCFRunLoopExit。
                 */
                loopCount -= 1
            } while(loopCount > 0)
        }
    }
    
    func timerProcess() {
        print("Enter timerProcess.")
        for index in 1...5 {
            print("timerProcess count = \(index)")
            sleep(1)
        }
        print("Exit timerProcess.")
    }
}

