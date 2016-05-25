//
//  GCDDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 善用队列上下文

class TestDispatchQueue {
    func launch() {
        let serialQueue = dispatch_queue_create("com.example", DISPATCH_QUEUE_SERIAL)
        //用dispatch_set_context函数向serialQueue队列的上下文环境中设置了一个Int类型的变量，初始值为0。
        dispatch_set_context(serialQueue, unsafeBitCast(0, UnsafeMutablePointer<Int>.self))
        
        dispatch_async(serialQueue) {
            //用dispatch_get_context函数获取上下文数据进行进一步的处理。
            var taskCount = unsafeBitCast(dispatch_get_context(serialQueue), Int.self)
            taskCount += 1
            print("TaskA in the dispatch queue...The number is \(taskCount)")
            dispatch_set_context(serialQueue, unsafeBitCast(taskCount, UnsafeMutablePointer<Int>.self))
            sleep(1)
        }
        dispatch_async(serialQueue) { 
            var taskCount = unsafeBitCast(dispatch_get_context(serialQueue), Int.self)
            taskCount += 1
            print("TaskB in the dispatch queue...The number is \(taskCount)")
            dispatch_set_context(serialQueue, unsafeBitCast(taskCount, UnsafeMutablePointer<Int>.self))
        }
        sleep(3)
    }
}


class Contact: NSObject {
    let name = "Davi"
    let mobile = "1000"
    var age = 20
}
// MARK: - 测试队列的收尾工作
class TestDispatchQueueCleanUp {
    let contact = Contact()
    
    //当队列被释放时，或者说引用计数为0时会调用该函数
    func myFinalizerFunc() -> dispatch_function_t {
        return { context in
            /*
             需要注意这里的context的生命周期
             可能会crash
             */
            let contact = unsafeBitCast(context, Contact.self)
            print("myFinalizerFunc The name is \(contact.name) and the mobile is \(contact.mobile)")
        }
    }
    
    func test() {
        let serialQueue = dispatch_queue_create("com.example.MySerialQueue", DISPATCH_QUEUE_SERIAL)
        dispatch_set_context(serialQueue, unsafeBitCast(contact, UnsafeMutablePointer<Void>.self))
        
        //使用dispatch_set_finalizer_f函数给队列设置清理函
        dispatch_set_finalizer_f(serialQueue, myFinalizerFunc())
        
        dispatch_async(serialQueue) {
            let contact = unsafeBitCast(dispatch_get_context(serialQueue), Contact.self)
            print("A The name is \(contact.name)")
            sleep(1)
        }
        dispatch_async(serialQueue) {
            let contact = unsafeBitCast(dispatch_get_context(serialQueue), Contact.self)
            print("B The name is \(contact.name)")
        }
        sleep(4)
    }
    
    func launch() {
        test()
        /**
         *  如果这里没有sleep操作，会crash在myFinalizerFunc中
         因为contact被释放了
         */
        sleep(1)
    }
}






















