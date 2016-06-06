//
//  Photo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

typealias PhotoDownloadCompletionClosure = (image: UIImage?, error: NSError?) -> Void
typealias PhotoDownloadProgressClosure = (completed: Int, total: Int) -> Void

enum PhotoStatus {
    case Downloading, GoodToGo, Failed
}

protocol Photo {
    var status: PhotoStatus { get }
    var image: UIImage? { get }
    var thumbnail: UIImage? { get }
}

//使用协议的好处
class AssetPhoto: Photo {
    var status: PhotoStatus {
        return .GoodToGo
    }
    var image: UIImage?
    var thumbnail: UIImage?
    
    init(image: UIImage) {
        self.image = image
        self.thumbnail = image
    }
}

//使用协议的好处
class DownloadPhoto: Photo {
    var status: PhotoStatus = .Downloading
    var image: UIImage?
    var thumbnail: UIImage?
    
    let url: NSURL
    //初始化后就开始下载图片
    init(url: NSURL, completion: PhotoDownloadCompletionClosure) {
        self.url = url
        downloadImage(completion)
    }
    
    func downloadImage(completion: PhotoDownloadCompletionClosure?) {
        let task = downloadSession.dataTaskWithURL(url) { (data, response, error) in
            self.image = UIImage(data: data!)
            self.thumbnail = self.image
            self.status = error == nil && self.image != nil ? .GoodToGo : .Failed
            
            if let completion = completion {
                completion(image: self.image, error: error)
            }
            
            YYGCD.dispatchInMainQueue {
                NSNotificationCenter.defaultCenter().postNotificationName(PhotoManagerContentUpdateNotification, object: nil)
            }
        }
        task.resume()
    }
}

private let downloadSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())






















