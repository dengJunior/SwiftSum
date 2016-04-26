//
//  NetworkController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import CoreData

/*
 一个网络控制器：它会与互联网、您的本地网络，甚至与纯文本文件 (Flat file) 系统建立连接。
 接下来它会将数据放到您的缓存、或者持久化存储引擎当中。
 这里最精彩的部分在于：您的整个视图层都只与缓存进行沟通交流。
 它不会直接从网络中获取任何数据。
 视图控制器的任务就是展示或者更新数据就可以了，但是不会执行任何的网络操作。
 */
class NetworkController: NSObject {
    
    let queue = NSOperationQueue()
    //使用CoreData作缓存机制
    var mainContext: NSManagedObjectContext?
    
    func requestData() {
        
    }
    func requestData1() -> NSFetchedResultsController {
        return NSFetchedResultsController()
    }
    func requestData(completion: (Void) -> Bool) {
        
    }
}


class YYNetworkRequest: NSOperation, NSURLSessionDelegate {
    var context: NSManagedObjectContext?
    
    //为了可以在多线程上使用 Core Data，我们可以持有多个上下文变量
    private var innerContext: NSManagedObjectContext?
    
    /*
     对于 NSURLSession 来说，我是又爱又恨（不过更倾向于喜欢），但是对于在 iOS 9 已经废除的 NSURLConnection 来说，已经是一个极大地提升了。
     我讨厌的部分是，如果您想要使用它的闭包实现 (block implementation) 的话，这将是一个棘手的问题。因为它会让您折回到 UIViewController 里面去，然后突然一下子您让当前的这个视图控制器离开了屏幕，结果发生了内存问题。不过，您同样可以在 NSOperation 设计当中使用它，我觉得这是最好的方式。
     */
    private var sessionTask: NSURLSessionTask?
    private var error: NSError?
    private let incomingData = NSMutableData()
    
    init(myParam1: String, myParam2: String) {
        super.init()
        //在这里设置参数
    }
    
    /*
     重载这个变量的目的在于，我们需要告诉队列我们已经结束了操作。
     为了实现这个效果，队列将会监听 “isFinished” 这个属性。
     在 Objective-C 当中，isFinished 翻译为变量 Finished 是完全没有问题的；
     在 Swift 中，它只能够监听 “isFinished”，它实际上并不能够监听实际的 Finish 属性，您无法对此进行改变。
     */
    var internalFinished: Bool = false
    override var finished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValueForKey("isFinished")
            internalFinished = newAnswer
            didChangeValueForKey("isFinished")
        }
    }
    
    
    func urlSession(session: NSURLSession,
                    dataTask: NSURLSessionDataTask,
                    didReceiveResponse response: NSURLResponse,
                    completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        //检查回调代码，并根据结果做出相应的回应
        completionHandler(.Allow)
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask,
                    didReceiveData data: NSData) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        incomingData.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask,
                    didCompleteWithError error: NSError?) {
        if cancelled {
            finished = true
            sessionTask?.cancel()
            return
        }
        if error != nil {
            self.error = error
            print("Failed to receive response: \(error)")
            finished = true
            return
        }
        
        //向 Core Data 中写入数据
        finished = true
    }
    
}























