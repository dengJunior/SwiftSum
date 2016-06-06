//
//  YYGCDGroup.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYGCDGroup: NSObject {
    public let dispatchGroup = dispatch_group_create()
    
    public func enter() {
        dispatch_group_enter(dispatchGroup)
    }
    
    public func leave() {
        dispatch_group_leave(dispatchGroup)
    }
    
    public func waitForever() {
        wait(DISPATCH_TIME_FOREVER)
    }
    
    //返回ture 表示未超时
    public func wait(millisecond: UInt64) -> Bool {
        //dispatch_group_wait返回非零表示超时了
        return dispatch_group_wait(dispatchGroup,  dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * Int64(millisecond))) == 0
    }
    
    public func notifyInMainQueue(task: () -> Void) {
        dispatch_group_notify(dispatchGroup, YYGCD.mainQueue, task)
    }
}



















