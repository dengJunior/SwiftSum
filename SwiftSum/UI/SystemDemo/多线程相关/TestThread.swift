//
//  TestThread.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/*需要注意
 NSThread继承了NSObject是Objective-C世界的东西，所以需要对代码进行修改，有两种方法：
 
 // 1. 让NSTread继承NSObject
 class TestThread: NSObject {
 
 // 2. 在methodInSecondaryThread()方法前添加@objc
 @objc func methodInSecondaryThread(arg: String) {

 */
class TestThread: NSObject {
    
    // MARK: - 使用NSThread创建线程
    /**
     NSThread 创建的线程都是Detach类型的线程。
     */
    func launchWithNSThread() {
        
        print("First event in Main Thread.")
        
        NSThread.detachNewThreadSelector(#selector(TestThread.methodInSecondaryThread(_:)), toTarget: self, withObject: "I am a argument")
        
        /*
         该方法的好处是可以在启动前通过NSThread对象的各个属性进行配置，
         待配置妥当后再调用start()方法启动线程。
         */
        let secondThread = NSThread(target: self, selector: #selector(TestThread.methodInSecondaryThread(_:)), object: nil)
        
        /**
         *  Cocoa框架：通过修改NSThread类的stackSize属性，改变二级线程的线程栈大小，不过这里要注意的是该属性的单位是字节，并且设置的大小必须得是4KB的倍数。
         
         POSIX API：通过pthread_attr_- setstacksize函数给线程属性pthread_attr_t结构体设置线程栈大小，然后在使用pthread_create函数创建线程时将线程属性传入即可。
         */
        secondThread.stackSize = (4000*1204) * 20;
        
        
        /**
         每一个线程，在整个生命周期里都会有一个字典
         如果使用POSIX线程，可以使用pthread_setspecific和pthread_getspecific函数设置获取线程字典。
         */
        let dict = secondThread.threadDictionary
        dict["hel"] = "dd"
        /**
         每一个新创建的二级线程都有它自己的默认优先级，内核会根据线程的各属性通过分配算法计算出线程的优先级。
         高优先级的线程会更早的运行
         可以通过NSThread的类方法setThreadPriority:设置优先级，因为线程的优先级由0.0～1.0表示
         */
        secondThread.threadPriority = 0.2;
        secondThread.start()
        
        /**可能来不及执行methodInSecondaryThread
         导致这个问题的原因和上文介绍的线程类型有关系。
         因为主线程运行很快，快到当主线程结束时我们创建的二级线程还没来得及执行methodInSecondaryThread()方法，
         而通过detachNewThreadSelector:toTarget:withObject:创建的二级线程是Detach类型的，没有与主线程结合，所以主线程也不会等待，当主线程结束，进程结束，二级线程自然也结束了。
         
         解决这个问题的办法就是让二级线程有执行任务的时间，所以我们可以让主线程停顿几秒
         */
        sleep(3)
        
        print("Second event in Main Thread.")
        
    }
    
    func methodInSecondaryThread(arg: String) {
        
        print("\(arg) of event in Secondary Thread.")
        
    }
    
    // MARK: - 使用NSObject创建线程
    /**
     该方法创建的线程也是Detach类型的。以上这几种方式都是基于Cocoa框架实现的，大家可以使用NSThread的类方法isMultiThreaded去检验
     */
    func launchWithNSObject() -> Void {
        print("First event in Main Thread.")
        
        performSelectorInBackground(#selector(TestThread.performInBackground), withObject: nil)
        sleep(3)
        
        print("Second event in Main Thread.")
    }
    
    func performInBackground() {
        autoreleasepool { 
            print("I am a event, perform in Background Thread.")
        }
    }
}


/*
 想要执行多参数的任务，可以通过创建继承NSThread的类，然后重写main()方法来实现：
 */
class CustomThread: NSThread {
    var arg1: String!
    var arg2: String!
    
    init(arg1: String, arg2: String) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
    
    override func main() {
        print("\(self.arg1), \(self.arg2), we are the arguments in Secondary Thread.")
    }
}






























