
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
    
    //处理认证和安全传输确认
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        //如果app没有提供会话代理,会话对象调用任务得代理方法URLSession:task:didReceiveChallenge:completionHandler:
        print(#function)
    }
    
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
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        print(#function)
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
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        //在非会话级别上,URLSession:didReceiveChallenge:completionHandler:不会被调用.
        print(#function)
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















