//
//  NSURLSessionDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit



// MARK: - 创建并配置NSURLSession

class NSURLSessionDemo: UIViewController {
    let defaultConfiguration: NSURLSessionConfiguration = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // 配置会话的缓存
        let cachePath = "/MyCacheDirectory"
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first!
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier!
        let fullCachePath = cacheDirectory + "/" + bundleIdentifier + "/" + cachePath
        print(fullCachePath)
        let urlCache = NSURLCache(memoryCapacity: 16384, diskCapacity: 268435456, diskPath: fullCachePath)
        
        configuration.URLCache = urlCache
        configuration.requestCachePolicy = .UseProtocolCachePolicy
        return configuration
    }()
    let ephemeralConfiguration: NSURLSessionConfiguration = {
       let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.allowsCellularAccess = true
        return configuration
    }()
    let backgroundConfiguration: NSURLSessionConfiguration = {
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("myBackgroundSessionIdentifier")
        configuration.allowsCellularAccess = true
        return configuration
    }()
    
    let sessionManager = YYSessionManager()
    lazy var defaultSession: NSURLSession = {
        //当创建一个会话时,configuration对象的传递是由深拷贝实现的
        let session =  NSURLSession(configuration: self.defaultConfiguration, delegate: self.sessionManager, delegateQueue: self.sessionManager.operationQueue)
        return session
    }()
    lazy var ephemeralSession: NSURLSession = {
        let session =  NSURLSession(configuration: self.ephemeralConfiguration, delegate: self.sessionManager, delegateQueue: self.sessionManager.operationQueue)
        return session
    }()
    
    //不能重用后台配置对象是因为两个后台会话不能使用相同的标识符identifier
    lazy var backgroundSession: NSURLSession = {
        let session =  NSURLSession(configuration: self.backgroundConfiguration, delegate: self.sessionManager, delegateQueue: self.sessionManager.operationQueue)
        return session
    }()
    
    static let urlString = "http://www.sina.com"
    let url = NSURL(string: urlString)!
    
    // MARK: - 获取数据
    
    func testWithCustomDelegate() {
        //使用系统提供代理
        let dataTask = defaultSession.dataTaskWithURL(url) { (nsdata, urlResponse, nserror) in
            print(nsdata)
        }
        //这里通过回调block的方式创建了一个任务,那么代理方法将不会再被调用.
        dataTask.resume()
        
        //使用自定义的代理
        let dataTask2 = defaultSession.dataTaskWithURL(url)
        dataTask2.resume()
    }
    
    // MARK: - 下载文件
    
    func doloadTask() {
        /**
         如果将下载任务安排在后台会话中,在app非运行期间下载行为仍将继续.如果将下载任务安排在系统默认会话或者临时会话中,当app重新启动时,下载只能重新开始
         */
        
        let downLoadTask = defaultSession.downloadTaskWithURL(url)
        
        var data = NSData()
        //如果用户进行了暂停操作,app可以调用cancelByProducingResumeData: 方法取消任务.
        downLoadTask.cancelByProducingResumeData { (nsData) in
            data = nsData!
        }
        
        //app可以将已传输的数据作为参数传递给downloadTaskWithResumeData:或者downloadTaskWithResumeData:completionHandler:来创建一个新的下载任务继续下载.
        let resumeDownLoadTask = defaultSession.downloadTaskWithResumeData(data)
        resumeDownLoadTask.resume()
    }
    
    
    // MARK: - 上传数据内容
    
    func uploadTask() {
        let request = NSMutableURLRequest(URL: url)
        /*
         使用NSData对象上传数据
         
         会话对象根据NSData对象计算内容长度,赋值给请求头的Content-Length.
         app还要在URL request对象中提供服务器可能需要的请求头信息-例如:content type.
         */
        let data = NSData()
        let uploadTask = defaultSession.uploadTaskWithRequest(request, fromData: data)
        uploadTask.resume()
        
        /*
         使用文件形式上传
         
         需要提供一个文件路径来读取内容
         会话对象自动计算Content-Length
         */
        let fileUrl = NSURL()
        let uploadFileTask = defaultSession.uploadTaskWithRequest(request, fromFile: fileUrl)
        uploadFileTask.resume()
        
        
        /**
         使用流形式上传
         
         - 此外,因为会话对象不能保证必定能从提供的流中读取数据,所以app需要提供一个新的流以便会话重新进行请求(比如,认证失败).
            - app需要实现 URLSession:task:needNewBodyStream:方法.
            - 当这个方法被调用时,app需要取得或者创建一个新的流,然后调用提供的完成处理块.
         */
        request.HTTPBodyStream = NSInputStream()
        let uploadStreameTask = defaultSession.uploadTaskWithStreamedRequest(request)
        uploadStreameTask.resume()
        
        
        /**
         使用下载任务来上传文件
         
         当下载任务创建时,app需要提供一个NSData对象或者一个流作为NSURLRequest对象的参数.
         */
        request.HTTPBodyStream = NSInputStream()
        request.HTTPBody = data
    }
}


























