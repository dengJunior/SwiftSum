
//
//  YYSessionManager.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

typealias completionHandler = () -> Void

class YYSessionManager: NSObject {
    let operationQueue = NSOperationQueue()
    var receivedData = NSMutableData()
    
    var completionHandlerDictionary = [String: completionHandler]()
}


extension YYSessionManager: UIApplicationDelegate {
    //处理iOS后台活动(Handling iOS Background Activity)
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        print(#function)
        
        /*
         在iOS中使用NSURLSession,当一个下载任务完成时,app将会自动重启.
         app代理方法application:handleEventsForBackgroundURLSession:completionHandler:负责重建合适的会话,存储完成处理块
         */
        let backgroundConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(identifier)
        let backgroundSession = NSURLSession(configuration: backgroundConfig, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        print(backgroundSession)
        
        completionHandlerDictionary[identifier] = completionHandler
    }
    
    
}

// MARK: - NSURLSessionDelegate
extension YYSessionManager: NSURLSessionDelegate {
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print(#function)
        /*
         在会话对象调用会话代理的URLSessionDidFinishEventsForBackgroundURLSession:方法时调用完成处理块.
         */
        if let identifier = session.configuration.identifier {
            let handler = completionHandlerDictionary.removeValueForKey(identifier)
            handler?()
        }
    }

    /*
     当不在需要会话的时候,通过方法invalidateAndCancel或者finishTasksAndInvalidate来取消会话
     
        - 在取消会话之后,代理方法URLSession:didBecomeInvalidWithError:会调用
        - 如果任务正在下载而被我们取消了,会话会调用URLSession:task:didCompleteWithError:来报告这个错误.
     */
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        print(#function)
        //在取消会话之后,代理方法URLSession:didBecomeInvalidWithError:会调用
    }
    
    //处理认证和安全传输确认
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        print(#function)
        //如果app没有提供会话代理,会话对象调用任务得代理方法URLSession:task:didReceiveChallenge:completionHandler:
        
        // MARK: 尝试在没有证书的情况下继续的2种方式
        
        //取决于协议的实现，这种处理方法可能会导致连接失败而以送connectionDidFailWithError:消息，或者返回可选的不需要认证的URL内容。
        
        //处理请求，告诉NSURLSession代理没有提供一个方法来处理这个认证
        completionHandler(.PerformDefaultHandling, nil)
        
        //拒绝了这次认证.这个取决于服务器返回的响应类型,URL加载肯可能会调用多次这个方法来获取另外的保护空间.
        completionHandler(.RejectProtectionSpace, nil)
        
        //challenge实例会包含一些信息，包括是什么触发了认证查询、查询的尝试次数、任何先前尝试的证书、请求证书的NSURLProtectionSpace对象，及查询的发送者。
        if challenge.previousFailureCount == 0 {
            //使用证书
            let newCredential = NSURLCredential(user: "", password: "", persistence: .None)
            completionHandler(.UseCredential, newCredential)
        } else {
            // MARK: 取消连接
            completionHandler(.CancelAuthenticationChallenge, nil)
        }
    }
}
// MARK: - NSURLSessionTaskDelegate
extension YYSessionManager: NSURLSessionTaskDelegate {
    
    //表示任务已经接受了所有的数据或失败
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        //使用自定义代理来获取数据时，必须实现的方法
        print(#function)
    }
    
    // MARK: - 上传
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        //获取上传进度.
        print(#function)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, needNewBodyStream completionHandler: (NSInputStream?) -> Void) {
        //如果app使用流作为请求体,必须实现的方法,提供一个新的流以便会话重新进行请求(比如,认证失败).
        print(#function)
        completionHandler(NSInputStream())
    }
    
    // MARK: - 认证
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        //在非会话级别上,URLSession:didReceiveChallenge:completionHandler:不会被调用.
        print(#function)
    }
    
    // MARK: - 重定向
    
    //当服务器认定一个请求需要客户端重新创建一个新的不同的请求时会产生重定向. 如果所有的重定向相关的代理方法都没有实现,默认允许所有的改变.
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse, newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
        print(#function)
        
        let newRequest = request
        completionHandler(newRequest)
    }
    
}

// MARK: - NSURLSessionDataDelegate
extension YYSessionManager: NSURLSessionDataDelegate {
    
    //从请求提供数据给我们的任务，一次一个数据块
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        //使用自定义代理来获取数据时，必须实现的方法
        print(#function)
        receivedData.appendData(data)
    }
    
    // MARK: 控制缓存
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, willCacheResponse proposedResponse: NSCachedURLResponse, completionHandler: (NSCachedURLResponse?) -> Void) {
        print(#function)
        //这个代理方法只用于数据请求和上传任务。而下载任务的缓存由指定的缓存策略来决定。
        
        //调用一个完成处理器block来告知会话需要缓存什么东西
        //必须调用completionHandler.否则,会产生内存泄露.
        completionHandler(proposedResponse)
    }
    
    // MARK: - 任务转换
    
    //对于一个数据任务对象,会话对象会调用URLSession:dataTask:didReceiveResponse:completionHandler:方法来确定是否要将数据任务转换成下载任务转.
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        print(#function)
        completionHandler(.BecomeDownload)
    }
    
    //如果应用选择转换成下载任务,会话对象会调用URLSession:dataTask:didBecomeDownloadTask:方法并传递一个下载任务的对象.
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeDownloadTask downloadTask: NSURLSessionDownloadTask) {
        print(#function)
    }
    
    @available(iOS 9.0, *)
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didBecomeStreamTask streamTask: NSURLSessionStreamTask) {
        print(#function)
    }
}

// MARK: - NSURLSessionDownloadDelegate

extension YYSessionManager: NSURLSessionDownloadDelegate {
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //提供了下载进度的状态信息.
        print(#function)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //告诉app尝试恢复之前失败的下载.
        print(#function)
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print(#function)
        /**
         提供app下载内容的临时存储目录.
         
         注意:在这个方法返回之前,必须打开文件来进行读取或者将下载内容移动到一个永久目录.当方法返回后,临时文件将会被删除.
         */
        
        //读取文件内容
        if let fileHandle = try? NSFileHandle(forReadingFromURL: location) {
            fileHandle.availableData
        }
        
        // 移动文件
        let fileManager = NSFileManager.defaultManager()
        let cacheDir = NSHomeDirectory().stringByAppendingString("Library").stringByAppendingString("Caches")
        let cacehDirUrl = NSURL(fileURLWithPath: cacheDir)
        if (try? fileManager.moveItemAtURL(location, toURL: cacehDirUrl)) != nil {
            //文件移动成功
        } else {
            //文件移动失败
        }
        
    }
}















