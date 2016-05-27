//
//  YYGCDGroup.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYGCDGroup: NSObject {
    let dispatchGroup = dispatch_group_create()
    
    func enter() {
        dispatch_group_enter(dispatchGroup)
    }
    
    func leave() {
        dispatch_group_leave(dispatchGroup)
    }
    
    func waitForever() {
        wait(DISPATCH_TIME_FOREVER)
    }
    
    //返回ture 表示未超时
    func wait(millisecond: UInt64) -> Bool {
        //dispatch_group_wait返回非零表示超时了
        return dispatch_group_wait(dispatchGroup,  dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * Int64(millisecond))) == 0
    }
    
    func notifyInMainQueue(task: () -> Void) {
        dispatch_group_notify(dispatchGroup, YYGCD.mainQueue, task)
    }
}



















