//
//  MainThreadRunLoopSource.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 主线程自定义事件源管理对象，负责初始化事件源，将事件源添加至指定线程，标记事件源并唤醒指定Run Loop以及包含上文中说过的事件源最主要的三个回调方法。
class MainThreadRunLoopSource: NSObject {
    
    var runloopSource: CFRunLoopSourceRef?
    var commandBuffer: Array<SecondaryThreadRunLoopSourceContext>?
    
    override init() {
        super.init()
        
        /*
         这里需要注意的是CFRunLoopSourceContext的init方法中的第二个参数和CFRunLoopSourceCreate方法的第三个参数都是指针，那么在Swift中，将对象转换为指针的方法有两种：
         
         1.使用unsafeBitCast方法，该方法会将第一个参数的内容按照第二个参数的类型进行转换。一般当需要对象与指针来回转换时使用该方法。
         2.在对象前面加&符号，表示传入指针地址。
         */
        var runloopSourceContex = CFRunLoopSourceContext(version: 0, info: unsafeBitCast(self, UnsafeMutablePointer<Void>.self), retain: nil, release: nil, copyDescription: nil, equal: nil, hash: nil, schedule: runloopSourceScheduleRoutine(), cancel: runloopSourceCancelRoutine(), perform: runloopSourcePerformRoutine())
        /**
         Run Loop事件源上下文很重要，我们来看看它的结构：
         
         struct CFRunLoopSourceContext {
         var version: CFIndex
         var info: UnsafeMutablePointer<Void>
         var retain: ((UnsafePointer<Void>) -> UnsafePointer<Void>)!
         var release: ((UnsafePointer<Void>) -> Void)!
         var copyDescription: ((UnsafePointer<Void>) -> Unmanaged<CFString>!)!
         var equal: ((UnsafePointer<Void>, UnsafePointer<Void>) -> DarwinBoolean)!
         var hash: ((UnsafePointer<Void>) -> CFHashCode)!
         var schedule: ((UnsafeMutablePointer<Void>, CFRunLoop!, CFString!) -> Void)!
         var cancel: ((UnsafeMutablePointer<Void>, CFRunLoop!, CFString!) -> Void)!
         var perform: ((UnsafeMutablePointer<Void>) -> Void)!
         }
         该结构体中我们需要关注的是前两个和后三个属性：
         
         version：事件源上下文的版本，必须设置为0。
         info：上下文中retain、release、copyDescription、equal、hash、schedule、cancel、perform这八个回调函数所有者对象的指针。
         schedule：该回调函数的作用是将该事件源与给它发送事件消息的线程进行关联，也就是说如果主线程想要给该事件源发送事件消息，那么首先主线程得能获取到该事件源。
         cancel：该回调函数的作用是使该事件源失效。
         perform：该回调函数的作用是执行其他线程或当前线程给该事件源发来的事件消息。
         */
        
        
        /**
         allocator：该参数为对象内存分配器，一般使用默认的分配器kCFAllocatorDefault。
         order：事件源优先级，当Run Loop中有多个接收相同事件的事件源被标记为待执行时，那么就根据该优先级判断，0为最高优先级别。
         context：事件源上下文。
         */
        runloopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &runloopSourceContex)
        
        commandBuffer = Array<SecondaryThreadRunLoopSourceContext>()
    }
    
    /**
     事件源创建好之后，接下来就是将其添加到指定某个模式的Run Loop中
     
     我们再来看看这个方法都干了些什么：
     
     void CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef rls, CFStringRef modeName) {
     .....
     __CFRunLoopSourceSchedule(rls, rl, rlm);
     .....
     }
     
     static void __CFRunLoopSourceSchedule(CFRunLoopSourceRef rls, CFRunLoopRef rl, CFRunLoopModeRef rlm) {
     .....
     
     if (0 == rls->_context.version0.version) {
     if (NULL != rls->_context.version0.schedule) {
     rls->_context.version0.schedule(rls->_context.version0.info, rl, rlm->_name);
     }
     }
     .....
     
     }
     从上述的代码片段可以看出，在CFRunLoopAddSource中调用了__CFRunLoopSourceSchedule内部函数，
     而该函数中正是执行了Run Loop事件源上下文中的schedule回调函数。
     也就是说当把事件源添加到Run Loop中后就会将事件源与给它发送事件消息的线程进行关联。
     */
    func addToCurrentRunLoop() {
        let cfRunloop = CFRunLoopGetCurrent()
        
        if let runSource = runloopSource {
            CFRunLoopAddSource(cfRunloop, runSource, kCFRunLoopDefaultMode)
        }
    }
    
    func signalSourceAndWakeUpRunloop(runloop: CFRunLoopRef) {
        CFRunLoopSourceSignal(runloopSource)
        CFRunLoopWakeUp(runloop)
    }
    
    /*
     前文中说过将事件源添加至Run Loop后会触发事件源的schedule回调函数，所以当执行完mainThreadRunLoopSource.addToCurrentRunLoop()这句代码后，便会触发主线程自定义事件源的schedule回调函数
     
     在Swift2.0中，如果一个作为回调函数方法的返回类型是指向函数的指针，
     这类指针可以转换为闭包，并且要在闭包前面加上@convention(c)标注。
     */
    func runloopSourceScheduleRoutine() -> @convention(c) (UnsafeMutablePointer<Void>, CFRunLoop!, CFString!) -> Void {
        return { (info, runloop, runloopMode) -> Void in
            let mainThreadRunloopSource = unsafeBitCast(info, MainThreadRunLoopSource.self)
            
            let mainThreadRunloopSourceContext = MainThreadRunLoopSourceContext(runloop: runloop, runloopSource: mainThreadRunloopSource)
            
            let runLoopSourceManager = RunLoopSourceManager.sharedInstance
            
//            runLoopSourceManager.registerMainThreadRunLoopSource(mainThreadRunloopSourceContext)
            runLoopSourceManager.performSelector(#selector(RunLoopSourceManager.registerMainThreadRunLoopSource(_:)), withObject: mainThreadRunloopSourceContext)
        }
    }
    
    func runloopSourceCancelRoutine() -> @convention(c) (UnsafeMutablePointer<Void>, CFRunLoop!, CFString!) -> Void {
        return { (info, runloop, runloopMode) -> Void in
            let mainThreadRunloopSource = unsafeBitCast(info, MainThreadRunLoopSource.self)
            CFRunLoopSourceInvalidate(mainThreadRunloopSource.runloopSource)
            RunLoopSourceManager.sharedInstance.removeMainThreadRunloopSourceContext()
        }
    }
    
    
    func runloopSourcePerformRoutine() -> @convention(c) (UnsafeMutablePointer<Void>) -> Void {
        return { info -> Void in
            
            RunLoopSourceManager.sharedInstance.performMainThreadRunloopSourceTask()
        }
    }
}





























