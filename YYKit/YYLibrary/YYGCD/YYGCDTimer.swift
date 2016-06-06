//
//  YYGCDTimer.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYGCDTimer: NSObject {
    private let dispatchSource: dispatch_source_t
    init(queue: dispatch_queue_t = YYGCD.globalQueue) {
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
    }
    
    public func setEventWithTimeInterval(ti: NSTimeInterval, repeats yesOrNo: Bool, task: () -> Void) {
        dispatch_source_set_timer(dispatchSource, DISPATCH_TIME_NOW, 0, 0)
        dispatch_source_set_event_handler(dispatchSource, task)
    }
    
    public func start() {
        dispatch_resume(dispatchSource)
    }
    public func destory() {
        dispatch_source_cancel(dispatchSource)
    }
}
