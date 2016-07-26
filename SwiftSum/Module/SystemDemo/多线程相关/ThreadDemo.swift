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
            let testOperation = MyNonConcurrentOperation(url: "http://www.baidu.com/s?wd=ios")
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
        /**
         1. @synchronized 关键字加锁
         2. NSLock 对象锁
         3. NSCondition
         4. NSConditionLock 条件锁
         5. NSRecursiveLock 递归锁
         6. pthread_mutex 互斥锁（C语言）
         7. dispatch_semaphore 信号量实现加锁（GCD）
         8. OSSpinLock （暂不建议使用，原因参见这里）
         */
        self.addButtonToView("iOS的各种加锁方式及比较", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { (button) in
            let count = 1000_0000 //执行一千万次
            var cost: CFTimeInterval = 0
            
            cost = self.test(action: {
                let nsLock = NSLock()
                for _ in 0 ..< count {
                    nsLock.lock()
                    nsLock.unlock()
                }
            })
            print("NSLock used : \(cost)");
            
            cost = self.test(action: {
                let nsCondition = NSCondition()
                for _ in 0 ..< count {
                    nsCondition.lock()
                    nsCondition.unlock()
                }
            })
            print("NSCondition used : \(cost)");
            
            cost = self.test(action: {
                let nsConditionLock = NSConditionLock()
                for _ in 0 ..< count {
                    nsConditionLock.lock()
                    nsConditionLock.unlock()
                }
            })
            print("NSConditionLock used : \(cost)");
            
            cost = self.test(action: {
                let lock = NSRecursiveLock()
                for _ in 0 ..< count {
                    lock.lock()
                    lock.unlock()
                }
            })
            print("NSRecursiveLock used : \(cost)");
            
            cost = self.test(action: {
                let mutex: UnsafeMutablePointer<pthread_mutex_t> = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
                pthread_mutex_init(mutex, nil)
                for _ in 0 ..< count {
                    pthread_mutex_lock(mutex)
                    pthread_mutex_unlock(mutex)
                }
            })
            print("pthread_mutex used : \(cost)");
            
            cost = self.test(action: {
                let semaphore = dispatch_semaphore_create(1)
                for _ in 0 ..< count {
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                    dispatch_semaphore_signal(semaphore)
                }
            })
            print("dispatch_semaphore used : \(cost)");
            
            cost = self.test(action: {
                var splock = OS_SPINLOCK_INIT
                for _ in 0 ..< count {
                    OSSpinLockLock(&splock)
                    OSSpinLockUnlock(&splock)
                }
            })
            print("OSSpinLock used : \(cost)");
        }
    }

    func test(count: Int = 1, action: ()->Void) -> CFTimeInterval  {
        let beginTime = CFAbsoluteTimeGetCurrent()
        for _ in 0 ..< count {
            action()
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - beginTime
    }

}



















