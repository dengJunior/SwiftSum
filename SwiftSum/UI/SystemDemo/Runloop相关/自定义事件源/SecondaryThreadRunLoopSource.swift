//
//  SecondaryThreadRunLoopSource.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 二级线程自定义事件源管理对象，负责初始化事件源，将事件源添加至指定线程，标记事件源并唤醒指定Run Loop以及包含上文中说过的事件源最主要的三个回调方法。
class SecondaryThreadRunLoopSource: NSObject {
    var runloopSource: CFRunLoopSourceRef?
    var commandBuffer: Array<MainThreadRunLoopSourceContext>?
    
    override init() {
        
        super.init()
        
        var runloopSourceContext = CFRunLoopSourceContext(version: 0, info: unsafeBitCast(self, UnsafeMutablePointer<Void>.self), retain: nil, release: nil, copyDescription: nil, equal: nil, hash: nil, schedule: runloopSourceScheduleRoutine(), cancel: runloopSourceCancelRoutine(), perform: runloopSourcePerformRoutine())
        
        runloopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &runloopSourceContext)
        
        commandBuffer = Array<MainThreadRunLoopSourceContext>()
        
    }
    
    
    func addToCurrentRunLoop() {
        
        let cfrunloop = CFRunLoopGetCurrent()
        
        if let rls = runloopSource {
            CFRunLoopAddSource(cfrunloop, rls, kCFRunLoopDefaultMode)
        }
        
    }
    
    func signalSourceAndWakeUpRunloop(runloop: CFRunLoopRef) {
        CFRunLoopSourceSignal(runloopSource)
        CFRunLoopWakeUp(runloop)
    }
    
    /**
     当二级线程事件源被标记并且二级线程Run Loop被唤醒后，就会触发事件源的perform回调函数：
     */
    func runloopSourcePerformRoutine() -> @convention(c) (UnsafeMutablePointer<Void>) -> Void {
        
        return { info -> Void in
            /**
             *  二级线程事件源的perform回调函数会在当前线程，也就是二级线程中执行RunLoopSourceManager中的对应方法：
             */
            RunLoopSourceManager.sharedInstance.performSelector(#selector(RunLoopSourceManager.performSecondaryThreadRunLoopSourceTask))
            
        }
        
    }
    
    func runloopSourceScheduleRoutine() -> @convention(c) (UnsafeMutablePointer<Void>, CFRunLoop!, CFString!) -> Void {
        
        return { (info, runloop, runloopMode) -> Void in
            
            let secondaryThreadRunloopSource = unsafeBitCast(info, SecondaryThreadRunLoopSource.self)
            
            let secondaryThreadRunloopSourceContext = SecondaryThreadRunLoopSourceContext(runloop: runloop, runloopSource: secondaryThreadRunloopSource)
            
            /**
             在该方法中同样是将二级线程事件源上下文对象传给了RunLoopSourceManager的对应方法，
             但是这里用了performSelectorOnMainThread方法，让其在主线程中执行，
             目的在于注册完上下文对象后就接着从主线程给二级线程发送事件消息了，其实我将这里作为了主线程触发二级线程执行任务的触发点：
             */
            RunLoopSourceManager.sharedInstance.performSelectorOnMainThread(#selector(RunLoopSourceManager.registerSecondaryThreadRunLoopSource(_:)), withObject: secondaryThreadRunloopSourceContext, waitUntilDone: true)
            
        }
        
    }
    
    
    func runloopSourceCancelRoutine() -> @convention(c) (UnsafeMutablePointer<Void>, CFRunLoop!, CFString!) -> Void {
        
        return { (info, runloop, runloopMode) -> Void in
            
            let secondaryThreadRunloopSource = unsafeBitCast(info, SecondaryThreadRunLoopSource.self)
            
            CFRunLoopSourceInvalidate(secondaryThreadRunloopSource.runloopSource)
            
            RunLoopSourceManager.sharedInstance.performSelector(#selector(RunLoopSourceManager.removeSecondaryThreadRunloopSourceContext))
            
        }
        
    }
}
