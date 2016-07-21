//
//  YYWebImageManager.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYWebImageManager: NSObject {
    static let sharedInstance = YYWebImageManager()
}

class YYWebImageSetter {
    var imageUrl: NSURL?
    var sentinel: Int = 0
    static let queue: dispatch_queue_t = {
        let queue = dispatch_queue_create("com.ibireme.yykit.webimage.setter", DISPATCH_QUEUE_SERIAL)
        dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        return queue
    }()
    
    /// Create new operation for web image and return a sentinel value.
    func setOperation(sentinel: Int,
                      url: NSURL,
                      options: YYWebImageOptions,
                      manager: YYWebImageManager,
                      progress: YYWebImageProgressCallback,
                      completion: YYWebImageCompletionCallback) -> Int {
        imageUrl = url
        if self.sentinel != sentinel {
            completion(image: nil, url: url, from: .none, stage: .cancelled, error: nil)
            return sentinel
        }
        self.sentinel = sentinel
        let operation = NSOperation()
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
        self.operation?.cancel()
        self.operation = operation
//        sentinel += 1
        dispatch_semaphore_signal(lock)
        return sentinel
    }
    
    func cancel(url: NSURL? = nil) -> Int {
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
        if operation {
            operation?.cancel()
            operation = nil
        }
        imageUrl = url
        sentinel += 1
        dispatch_semaphore_signal(lock)
        return sentinel
    }
    
    let lock = dispatch_semaphore_create(1)
    var operation: NSOperation?
}

