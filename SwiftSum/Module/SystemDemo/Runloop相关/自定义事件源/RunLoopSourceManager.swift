//
//  RunLoopSourceManager.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 为各自定义事件源回调方法执行内容的管理类。
class RunLoopSourceManager: NSObject {
    static let sharedInstance = RunLoopSourceManager()
    
    var mainThreadRunloopSourceContext: MainThreadRunLoopSourceContext?
    var secondaryThreadRunloopSourceContext: SecondaryThreadRunLoopSourceContext?
    var mainCollectionViewController: MainCollectionViewController?
    
    /**
     停止runloop
     */
    func stopSecondaryThreadRunloop() {
        
        if let runloop = secondaryThreadRunloopSourceContext?.runloop {
            CFRunLoopStop(runloop)
        }
        
    }
    
    func registerMainThreadRunLoopSource(runloopSourceContext: MainThreadRunLoopSourceContext) {
        mainThreadRunloopSourceContext = runloopSourceContext
    }
    
    func registerSecondaryThreadRunLoopSource(runloopSourceContext: SecondaryThreadRunLoopSourceContext) {
        secondaryThreadRunloopSourceContext = runloopSourceContext
        sendCommandToSecondaryThread()
    }
    
    func removeMainThreadRunloopSourceContext() {
        mainThreadRunloopSourceContext = nil
    }
    
    func removeSecondaryThreadRunloopSourceContext() {
        secondaryThreadRunloopSourceContext = nil
    }

    
    func performMainThreadRunloopSourceTask() {
        /**
         *  同样会先判断主线程事件源的指令池是否有内容，
         然后执行MainCollectionViewController中的刷新UI的方法，
         最后再次给二级线程发送事件消息，以此循环。
         */
        if mainThreadRunloopSourceContext?.runloopSource?.commandBuffer?.count > 0 {
            mainThreadRunloopSourceContext?.runloopSource?.commandBuffer?.removeAll()
            
            mainCollectionViewController?.collectionView.reloadData()
            let timer = NSTimer(timeInterval: 1, target: self, selector: #selector(sendCommandToSecondaryThread), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
    }
    
    func performSecondaryThreadRunLoopSourceTask() {
        /**
         *  先会判断二级线程事件源的指令池中有没有内容，
         如果有的话，那么执行计算UICollectionViewCell透明度的任务，
         然后从指令池中获取到主线程事件源上下文对象，
         将二级线程事件源上下文对象放入主线程事件源的指令池中，并将主线程事件源标记为待执行，
         然后唤醒主线程Run Loop。之后便会触发主线程事件源的perform回调函数：
         */
        if secondaryThreadRunloopSourceContext?.runloopSource?.commandBuffer?.count > 0 {
            mainCollectionViewController?.generateRandomAlpha()
            if let mainThreadRunloopSourceContext = secondaryThreadRunloopSourceContext?.runloopSource?.commandBuffer?.first {
                mainThreadRunloopSourceContext.runloopSource?.commandBuffer?.append(secondaryThreadRunloopSourceContext!)
                mainThreadRunloopSourceContext.runloopSource?.signalSourceAndWakeUpRunloop(mainThreadRunloopSourceContext.runloop!)
            }
            
        }
    }
    
    /**
     将主线程的事件源上下文放入了二级线程事件源的指令池中，这里我设计的是只要指令池中有内容就代表事件源需要执行后续任务了。
     然后执行了二级线程事件源的signalSourceAndWakeUpRunloop()方法，给其标记为待执行，并唤醒二级线程的Run Loop
     */
    func sendCommandToSecondaryThread() {
        secondaryThreadRunloopSourceContext?.runloopSource?.commandBuffer?.append(mainThreadRunloopSourceContext!)
        secondaryThreadRunloopSourceContext?.runloopSource?.signalSourceAndWakeUpRunloop((secondaryThreadRunloopSourceContext?.runloop)!)
    }
}






























