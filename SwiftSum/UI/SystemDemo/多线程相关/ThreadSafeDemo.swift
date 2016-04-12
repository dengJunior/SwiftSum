//
//  ThreadSafeDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit



class ThreadSafeDemo: NSObject {
    // MARK: - 使用原子操作
    /**
     有些时候我们只希望一些数学运算或者简单的逻辑能够保证线程安全，如果使用锁机制或者条件机制虽然可以实现，但是会耗费较大的资源开销，并且锁机制还会使线程阻塞，造成性能损失，非常不划算，所以当遇到这种情况时，我们可以尝试使用原子操作来达到目的。
     
     我们一般使用原子操作对32位和64位的值执行一些数学运算或简单的逻辑运算，主要依靠底层的硬件指令或者使用内存屏障确保正在执行的操作是线程安全的，下面我们来看看Apple给我们提供了哪些原子操作的方法：
     */
    func automicDemo() {
        //Add操作是将两个整数相加，并将结果存储在其中一个变量中：
        var num: Int64 = 10
        OSAtomicAdd64(20, &num)
        OSAtomicAdd64Barrier(20, &num)
        print("\(num)")//50
        
        //Increment操作将指定值加1：
        num = 10
        OSAtomicIncrement64(&num)
        OSAtomicIncrement64Barrier(&num)
        print("\(num)")//12
        
        //Decrement操作将指定值减1:
        num = 10
        OSAtomicDecrement64(&num)
        OSAtomicDecrement64Barrier(&num)
        print("\(num)")//8
        
        //CAS操作是比较与交换（Compare and Swap）操作，有三个参数分别是旧值、新值、想要比较的值的内存地址，
        num = 10
        let result = OSAtomicCompareAndSwap64(10, 20, &num)
        print("\(num)") // 20
        print(result) // true
        
        let result1 = OSAtomicCompareAndSwap64(11, 20, &num)
        print("\(num)") // 10
        print(result1) // false
        
        //OR逻辑运算、AND逻辑运算、XOR逻辑运算
        //对两个32位数值中的位置相同的位执行按位比较：
//        OSAtomicOr32(<#T##__theMask: UInt32##UInt32#>, <#T##__theValue: UnsafeMutablePointer<UInt32>##UnsafeMutablePointer<UInt32>#>)

        
        //将给定比特位的值设置位1或者0:
        OSAtomicTestAndSet(1, &num)
    }
}


class TestLock: NSObject {
    let mutex: UnsafeMutablePointer<pthread_mutex_t>
    let nslock: NSLock
    let nsRecursiveLock: NSRecursiveLock
    
    let conditionLock: NSConditionLock
    var messageQueue = [AnyObject]()
    let HasMessage = 1
    let NoMessage = 0
    
    let nsCondition: NSCondition
    var products = [String]()
    
    override init() {
        mutex = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
        pthread_mutex_init(mutex, nil)
        
        nslock = NSLock()
        nsRecursiveLock = NSRecursiveLock()
        conditionLock = NSConditionLock(condition: NoMessage)
        
        nsCondition = NSCondition()
    }
    
    // MARK: - POSIX互斥锁
    /**
     POSIX是可移植操作系统接口（Portable Operating System Interface of UNIX），它定义了操作系统应该为应用程序提供的接口标准，在类Unix系统中都可以使用。
     使用POSIX互斥锁很简单，先申明互斥锁指针，类型为UnsafeMutablePointer<pthread_mutex_t>，然后通过pthread_mutex_init函数初始化互斥锁，最后通过pthread_mutex_lock函数和pthread_mutex_unlock函数上锁和释放锁：
     */
    func posixMutexLock() {
        pthread_mutex_lock(mutex)
        print("posixMutexLock")
        pthread_mutex_unlock(mutex)
    }
    
    // MARK: - NSLock
    /**
     在NSLock中有两个加锁的方法：
     
     tryLock：该方法使当前线程试图去获取锁，并返回布尔值表示是否成功，但是当获取锁失败后并不会使当前线程阻塞。
     lockBeforeDate：该方法与上面的方法类似，但是只有在设置的时间内获取锁失败线程才不会被阻塞，如果获取锁失败时已超出了设置的时间，那么当前线程会被阻塞。
     */
    func nslockTest() {
        nslock.tryLock()
        nslock.lockBeforeDate(NSDate(timeIntervalSinceNow: 5))
        print("")
        nslock.unlock()
    }
    
    // MARK: - NSRecursiveLock, 递归锁
    func nsRecursiveLockTest(inout value: Int) {
        nsRecursiveLock.lock()
        if value != 0 {
            value -= 1
            print("\(value)")
            nsRecursiveLockTest(&value)
        }
        nsRecursiveLock.unlock()
    }
    
    // MARK: - NSConditionLock
    /**
     *  条件锁也是互斥锁的一种变种，在Cocoa框架中对应的类是NSConditionLock，条件锁顾名思义可以设置加锁和释放锁的条件。假设我们有一个消息队列，并且有消息生产者和消息消费者，那么一般情况是当消息生产者产生消息，放入消息队列，然后消息消费者从消息队列中获取消息，并将其从消息队列移除进行后续操作。那么消费者在获取消息和移除消息时要确保两点先决条件，第一就是获取消息时队列中确实已有消息，第二就是此时生产者不能向队列中添加消息，否则会影响消息队列中消息的顺序或者影响获取到消息的结果，所以在这种情况下我们就可以使用条件锁来保证他们的线程安全：
     */
    func produceMessage() {
        NSThread.detachNewThreadSelector(#selector(consumeMessage), toTarget: self, withObject: nil)
        while true {
            conditionLock.lock()
            // 生产消息并添加到消息队列中
            messageQueue.append("sss")
            conditionLock.unlockWithCondition(HasMessage)
        }
    }
    
    func consumeMessage() {
        while true {
            conditionLock.lockWhenCondition(HasMessage)
            // 从消息队列中获取消息并从队列中移除消息
            messageQueue.popLast()
            conditionLock.unlockWithCondition(messageQueue.isEmpty ? NoMessage : HasMessage)
        }
    }
    
    // MARK: - 使用@synchronized关键字
    /**
     在Objective-C中，我们会经常使用@synchronized关键字来修饰变量，确保变量的线程安全，它能自动为修饰的变量创建互斥锁或解锁：
     在Swift中，这个关键字已经不存在了
     
     @synchronized关键字其实是调用了objc_sync_enter和objc_sync_exit这两个方法，所以在Swift中使用时可以这样给变量加锁：
     */
    func syncTest(obj: AnyObject) {
        objc_sync_enter(obj)
        // anObj参数在这两个方法之间具有线程安全特性，不会被其他线程改变
        objc_sync_exit(obj)
    }
    
    // MARK: - 使用NSCondition类
    /**
     *  这里举个生产者和消费者的例子，消费者从队列中获取产品进行消费，当队列中没有产品时消费者等待生产者生产，当生产者生产出产品放入队列后再通知消费者继续进行消费：
     
     
     NSCondition类同样是用lock和unlock方法进行上锁和释放锁，然后通过wait方法阻塞线程，通过signal方法唤醒阻塞的线程，该方法唤醒的时最近一次使用wait方法等待的线程。
     如果想一次性唤醒所有在等待的线程，可以使用broadcast方法。
     NSCondition还有另外一个阻塞线程的方法waitUntilDate(_ limit: NSDate)，该方法设置一个线程阻塞时间并返回一个布尔值，
     如果在指定的时间内没有信号量的通知，那么就唤醒线程继续进行，此时该方法返回false，
     如果在指定时间内接收到信号量的通知，此时该方法返回true。
     */
    func consumeProduct() {
        nsCondition.lock()
        if products.count == 0 {
            nsCondition.wait()
        }
        let product = products.removeFirst()
        print("消费产品 \(product)")
        nsCondition.unlock()
    }
    
    func generateProduct() {
        nsCondition.lock()
        let product = "ppp"
        products.append(product)
        print("生产产品")
        nsCondition.signal()
        nsCondition.unlock()
    }
}


























