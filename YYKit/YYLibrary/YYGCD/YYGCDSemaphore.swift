//
//  YYGCDSemaphore.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYGCDSemaphore: NSObject {
    private let dispatchSemaphore: dispatch_semaphore_t
    public init(value: Int = 0) {
        dispatchSemaphore = dispatch_semaphore_create(value)
    }
    
    /** 
     发送信号增加一个信号量.
     - returns: true表示线程被唤醒了
     */
    public func signal() -> Bool {
        //返回非0表示线程被唤醒
        return dispatch_semaphore_signal(dispatchSemaphore) != 0
    }
    
    public func waitForever() {
        wait(DISPATCH_TIME_FOREVER)
    }
    
    //返回ture 表示未超时
    public func wait(millisecond: UInt64) -> Bool {
        //dispatch_semaphore_wait返回非零表示超时了
        return dispatch_semaphore_wait(dispatchSemaphore,  dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * Int64(millisecond))) == 0
    }
}

/**
 一个发送信号,一个接受信号
 
 -dispatch_semaphore_signal-
 
 Signals (increments) a semaphore.
 Increment the counting semaphore. If the previous value was less than zero, this function wakes a thread currently waiting in dispatch_semaphore_wait.
 
 This function returns non-zero if a thread is woken. Otherwise, zero is returned.
 
 发送信号增加一个信号量.
 
 增加一个信号量,如果当前值小于或者等于0,这个方法会唤醒某个使用了dispatch_semaphore_wait的线程.
 
 如果这个线程已经唤醒了,将会返回非0值,否则返回0
 */















