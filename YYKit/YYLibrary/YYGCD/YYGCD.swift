//
//  YYDispatchQueuePool.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - GCD的 便捷使用
public class YYGCD: NSObject {
    //一个串行队列
    public static let serialQueue: dispatch_queue_t = dispatch_queue_create("com.yy.YYGCD", DISPATCH_QUEUE_SERIAL);
    
    //全局系统队列
    public static let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
    public static let globalQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    public static let highPriorityGlobalQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
    public static let lowPriorityGlobalQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    public static let backgroundPriorityGlobalQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
}

// MARK: - 常规的便捷用法
extension YYGCD {
    public static func dispatchInSerialQueue(delay millisecond: Int64 = 0, async: Bool = true, task: () -> Void) {
        dispatchInQueue(serialQueue, async: async, delay: millisecond, task: task)
    }
    
    public static func dispatchInMainQueue(delay millisecond: Int64 = 0, async: Bool = true, task: () -> Void) {
        dispatchInQueue(mainQueue, async: async, delay: millisecond, task: task)
    }
    public static func dispatchInGlobalQueue(delay millisecond: Int64 = 0, async: Bool = true, task: () -> Void) {
        dispatchInQueue(mainQueue, async: async, delay: millisecond, task: task)
    }
    public static func dispatchInHighPriorityGlobalQueue(delay millisecond: Int64 = 0, async: Bool = true, task: () -> Void) {
        dispatchInQueue(mainQueue, async: async, delay: millisecond, task: task)
    }
    public static func dispatchInLowPriorityGlobalQueue(delay millisecond: Int64 = 0, async: Bool = true, task: () -> Void) {
        dispatchInQueue(mainQueue, async: async, delay: millisecond, task: task)
    }
    public static func dispatchInBackgroundPriorityGlobalQueue(delay millisecond: Int64 = 0, async: Bool = true, task: () -> Void) {
        dispatchInQueue(mainQueue, async: async, delay: millisecond, task: task)
    }
}

// MARK: - 与GCDGroup相关的用法
extension YYGCD {
    public static func dispatchInGroup(group: YYGCDGroup, task: () -> Void)  {
        dispatch_group_async(group.dispatchGroup, globalQueue, task)
    }
    public static func notifyInGroup(group: YYGCDGroup, task: () -> Void)  {
        dispatch_group_notify(group.dispatchGroup, globalQueue, task)
    }
    
    public static func suspend() {
        dispatch_suspend(serialQueue)
    }
    public static func resume() {
        dispatch_resume(serialQueue)
    }
}

private extension YYGCD {
    static func dispatchInQueue(queue: dispatch_queue_t, async: Bool, delay millisecond: Int64, task: () -> Void) {
        if millisecond > 0 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * millisecond), queue, task)
        } else {
            async ? dispatch_async(queue, task) : dispatch_sync(queue, task)
        }
    }
}



