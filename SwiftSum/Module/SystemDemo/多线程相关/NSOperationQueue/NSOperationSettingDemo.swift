//
//  NSOperationSettingDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


// MARK: - 测试Operation对象之间的依赖
class TestOperationDependency {
    func launch() {
        
        // MARK: - 设置Completion Block
        let blockOperationA = NSBlockOperation {
            print("Task in blockOperationA...")
            sleep(3)
            print("Task in blockOperationA finished")
        }
        
        let blockOperationB = NSBlockOperation {
            print("Task in blockOperationB...")
            sleep(2)
            print("Task in blockOperationB finished")
        }
        
        /**注意，任务A在B执行完后就会马上开始执行，
         不会等到B的completionBlock执行完，打印如下
         
         Task in blockOperationB...
         Task in blockOperationB finished
         completionBlock in blockOperationB...
         Task in blockOperationA...
         completionBlock in blockOperationB finished
         Task in blockOperationA finished
         */
        blockOperationB.completionBlock = {
            print("completionBlock in blockOperationB...")
            sleep(1)
            print("completionBlock in blockOperationB finished")
        }
        
        //B执行完后A才执行
        blockOperationA.addDependency(blockOperationB)
        
        let operationQueue = NSOperationQueue();
        operationQueue.addOperation(blockOperationA)
        
        //如果队列中不加入B，那么A不会执行
        operationQueue.addOperation(blockOperationB)
        
        print("TestOperationDependency finished")
        sleep(10);
    }
}
// MARK: - 测试OperationQueue
class TestOperationQueue {
    func launch() {
        
        // MARK: - 设置Completion Block
        let blockOperationA = NSBlockOperation {
            print("Task in blockOperationA...")
            sleep(3)
            print("Task in blockOperationA finished")
        }
        
        let blockOperationB = NSBlockOperation {
            print("Task in blockOperationB...")
            sleep(2)
            print("Task in blockOperationB finished")
        }
        
        //B执行完后A才执行
        blockOperationA.addDependency(blockOperationB)
        
        let operationQueue = NSOperationQueue();
        
        /**
         *  如果设置为1，那么不管该操作队列中添加了多少Operation对象，每次都只运行一个，而且会按照添加Operation对象的顺序去执行。如下：
         
         Task in blockOperationB...
         Task in blockOperationB finished
         Task in blockOperationA...
         Task in blockOperationA finished
         task in addOperationWithBlock...
         task in addOperationWithBlock finished
         */
        operationQueue.maxConcurrentOperationCount = 1;
        
        //true会阻塞当前线程。直到A执行完
        operationQueue.addOperations([blockOperationA, blockOperationB], waitUntilFinished: false)
        print("addOperations:waitUntilFinished: finished")
        
        operationQueue.addOperationWithBlock { 
            print("task in addOperationWithBlock...")
            sleep(1)
            print("task in addOperationWithBlock finished")
        }
        
        print("TestOperationQueue finished")
        sleep(10);
    }
    
    // MARK: - 手动执行Operation对象
    
    /**
     operation的ready、concurrent、executing、finished、cancelled
     这些状态在我们使用操作队列时都不需要理会，都有操作队列帮我们把控判断，确保Operation对象的正确执行，我们只需要在必要的时候获取状态信息查看而已。
     如果手动执行Operation对象，那么这些状态都需要我们来把控，因为你手动执行一个Operation对象时要判断它的依赖对象是否执行完成，是否被终止了等等，所以并不是简单的调用start方法
     */
    func performOperation(operation: NSOperation) -> Bool {
        var result = false
        if operation.ready && !operation.cancelled {
            if operation.concurrent {
                operation.start()
            } else {
                NSThread.detachNewThreadSelector(#selector(operation.start), toTarget: operation, withObject: nil)
            }
            result = true
        }
        return result
    }
}



























