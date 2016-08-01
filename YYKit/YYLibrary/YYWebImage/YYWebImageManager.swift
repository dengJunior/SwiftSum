//
//  YYWebImageManager.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYWebImageManager {
    public static let sharedInstance = YYWebImageManager()
    
    public var cache: NSCache?
    
    /**
     The operation queue on which image operations are scheduled and run.
     You can set it to nil to make the new operation start immediately without queue.
     
     You can use this queue to control maximum number of concurrent operations, to obtain
     the status of the current operations, or to cancel all operations in this manager.
     */
    public var queue: NSOperationQueue?
    
    /**
     The image request timeout interval in seconds. Default is 15.
     */
    public var timeout = 15
    
    /**
     The username, password used by NSURLCredential, default is nil.
     */
    public var username: String?
    public var password: String?
    
    /**
     The image HTTP request header. Default is "Accept:image/webp,image/\*;q=0.8".
     */
    public var headers: [String: String] = ["Accept": "image/webp,image/\\*;q=0.8"]
    
    /**
     A block which will be invoked for each image HTTP request to do additional
     HTTP header process. Default is nil.
     
     Use this block to add or remove HTTP header field for a specified URL.
     */
    public var headersFileter: ((NSURL, [String: String]) -> [String: String])?
    
    /**
     A block which will be invoked for each image operation. Default is nil.
     
     Use this block to provide a custom image cache key for a specified URL.
     */
    public var cacheKeyFilter: ((NSURL) -> String)?
    
    public init(cache: NSCache, queue: NSOperationQueue) {
        self.cache = cache
        self.queue = queue
    }
    public convenience init() {
        self.init(cache: NSCache(), queue: NSOperationQueue())
    }
    
    /**
     Creates and returns a new image operation, the operation will start immediately.
     
     @param url        The image url (remote or local file path).
     @param options    The options to control image operation.
     @param progress   Progress block which will be invoked on background thread (pass nil to avoid).
     @param transform  Transform block which will be invoked on background thread  (pass nil to avoid).
     @param completion Completion block which will be invoked on background thread  (pass nil to avoid).
     @return A new image operation.
     */
    public func requestImage(urlString: String,
                             options: YYWebImageOptions? = nil,
                             progress: YYWebImageProgressCallback? = nil,
                             completion: YYWebImageCompletionCallback? = nil) -> YYWebImageOperation {
        
        return YYWebImageOperation(request: NSURLRequest(), options: options ?? YYWebImageOptions(rawValue: 1), cacheKey: "xx", progress: progress, completion: completion)!
    }
    
    
    /**
     Returns the HTTP headers for a specified URL.
     
     @param url A specified URL.
     @return HTTP headers.
     */
    public func headersFroUrl(url: NSURL) -> [String: String]? {
        return headers
    }
    
    /**
     Returns the cache key for a specified URL.
     
     @param url A specified URL
     @return Cache key used in YYImageCache.
     */
    public func cacheKeyFroUrl(url: NSURL) -> String {
        return ""
    }
}

// MARK: - YYWebImageOperation

/**
 The YYWebImageOperation class is an NSOperation subclass used to fetch image
 from URL request.
 
 @discussion It's an asynchronous operation. You typically execute it by adding
 it to an operation queue, or calls 'start' to execute it manually. When the
 operation is started, it will:
 
 1. Get the image from the cache, if exist, return it with `completion` block.
 2. Start an URL connection to fetch image from the request, invoke the `progress`
 to notify request progress (and invoke `completion` block to return the
 progressive image if enabled by progressive option).
 3. Process the image by invoke the `transform` block.
 4. Put the image to cache and return it with `completion` block.
 
 */
public class YYWebImageOperation: NSOperation {
    public let request: NSURLRequest
    
    public var response: NSURLResponse {
        get {
            return NSURLResponse()
        }
    }
    
    public let cache: NSCache
    
    public let cacheKey: String
    
    public let options: YYWebImageOptions
    
    let lock = NSRecursiveLock()
    var started = false
    
    init?(request: NSURLRequest, options: YYWebImageOptions, cacheKey: String, progress: YYWebImageProgressCallback? = nil,
        completion: YYWebImageCompletionCallback? = nil) {
        self.request = request
        self.cacheKey = cacheKey
        self.cache = NSCache()
        self.options = options
    }
    
    func cancelOperation() {
        endBackgroundTask()
    }
    
    func endBackgroundTask() {
        lock.lock()
        UIApplication.sharedApplication().endBackgroundTask(111)
        lock.unlock()
    }
    
    // MARK: - Override
    
    public override func start() {
        autoreleasepool { 
            lock.lock()
            started = true
            if cancelled {
                
            } else if ready && !finished && !executing {
                
            }
            //finished = true
        }
    }
    
}

public class YYWebImageSetter {
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

