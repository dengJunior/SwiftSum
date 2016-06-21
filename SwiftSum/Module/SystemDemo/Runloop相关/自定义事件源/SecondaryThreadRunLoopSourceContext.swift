//
//  SecondaryThreadRunLoopSourceContext.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 二级线程自定义事件源上下文，可获取到对应的事件源及添加了该事件源的Run Loop。
class SecondaryThreadRunLoopSourceContext: NSObject {
    var runloop: CFRunLoopRef?
    var runloopSource: SecondaryThreadRunLoopSource?
    
    init(runloop: CFRunLoopRef, runloopSource: SecondaryThreadRunLoopSource) {
        
        self.runloop = runloop
        self.runloopSource = runloopSource
        
    }
}
