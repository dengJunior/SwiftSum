//
//  UIImageView+YYWebImage.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

var ImageUrlKey: UInt8 = 0
var ImageSetterKey: UInt8 = 0
extension UIImageView {
    // MARK: - image
    
    /**
     Current image URL.
     
     @discussion Set a new value to this property will cancel the previous request
     operation and create a new request operation to fetch image. Set nil to clear
     the image and image URL.
     */
    public var imageUrl: NSURL? {
        get {
            return objc_getAssociatedObject(self, &ImageUrlKey) as? NSURL
        }
        set {
            objc_setAssociatedObject(self, &ImageUrlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var setter: YYWebImageSetter? {
        get {
            return objc_getAssociatedObject(self, &ImageSetterKey) as? YYWebImageSetter
        }
        set {
            objc_setAssociatedObject(self, &ImageSetterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var buttonCount: Int {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int
            return value ?? 0 //初始化为0
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(urlString: String,
                  placeholder: UIImage? = nil,
                  options: YYWebImageOptions? = nil,
                  manager: YYWebImageManager? = nil,
                  progress: YYWebImageProgressCallback? = nil,
                  completion: YYWebImageCompletionCallback? = nil) {
        let imageUrl = urlString.toNSURL()
        //1. 初始化一个YYWebImageManager，然后动态的添加_YYWebImageSetter属性，为的是管控整个YYImage的下载，查找有没有相同的url在下载，如果有的话就要取消操作，确保同一个url只有一个队列在下载处理：
        if !setter {
            setter = YYWebImageSetter()
        }
        let sentinel = setter?.cancel(imageUrl)
        let imageManager = manager ?? YYWebImageManager.sharedInstance
        YYGCD.dispatchInMainQueue(task: {
            if !options?.contains(.avoidSetImage) && options?.contains(.setImageFade) {
                if !self.highlighted {
                    self.layer.removeAnimationForKey(YYWebImageKey.fadeAnimation)
                }
            }
            
            if !imageUrl && !options?.contains(.ignorePlaceHolder) {
                self.image = placeholder
                return
            }
            
            // get the image from memory as quickly as possible
            var imageFromMemory: UIImage?
            
        })
    }
    
    func cancelCurrentImageRequest() {
        
    }
    
    // MARK: - highlight image
    
    var highlightImageUrl: NSURL? {
        get {
            return nil
        }
    }
    
    func setHighlightedImage(urlString: String,
                             placeholder: UIImage? = nil,
                             options: YYWebImageOptions? = nil,
                             manager: YYWebImageManager? = nil,
                             progress: YYWebImageProgressCallback? = nil,
                             completion: YYWebImageCompletionCallback? = nil) {
        
    }
    
    func cancelCurrentHighlightedImageRequest() {
        
    }
}






















