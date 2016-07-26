//
//  YYWebImage.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public struct YYWebImageKey {
    public static let fadeAnimation = "YYWebImageFade"
}

/// The options to control image operation.
public struct YYWebImageOptions: OptionSetType {
    public var rawValue = 0
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// Show network activity on status bar when download image.
    public static var showNetworkActivity = YYWebImageOptions(rawValue: 1 << 0)
    
    /// Display progressive/interlaced/baseline image during download (same as web browser).
    public static var progressive = YYWebImageOptions(rawValue: 1 << 1)
    
    /// Display blurred progressive JPEG or interlaced PNG image during download.
    /// This will ignore baseline image for better user experience.
    public static var progressiveBlur = YYWebImageOptions(rawValue: 1 << 2)
    
    /// Use NSURLCache instead of YYImageCache.
    public static var useNSURLCache = YYWebImageOptions(rawValue: 1 << 3)
    
    /// Allows untrusted SSL ceriticates.
    public static var allowInvalidSSLCertificates = YYWebImageOptions(rawValue: 1 << 4)
    
    /// Allows background task to download image when app is in background.
    public static var allowBackgroundTask = YYWebImageOptions(rawValue: 1 << 5)
    
    /// Handles cookies stored in NSHTTPCookieStore
    public static var handleCookies = YYWebImageOptions(rawValue: 1 << 6)
    public static var refreshImageCache = YYWebImageOptions(rawValue: 1 << 7)
    public static var ignoreDiskCache = YYWebImageOptions(rawValue: 1 << 8)
    public static var ignorePlaceHolder = YYWebImageOptions(rawValue: 1 << 9)
    
    /// Ignore image decoding.
    /// This may used for image downloading without display.
    public static var ignoreImageDecoding = YYWebImageOptions(rawValue: 1 << 10)
    
    
    public static var ignoreAnimatedImage = YYWebImageOptions(rawValue: 1 << 11)
    public static var avoidSetImage = YYWebImageOptions(rawValue: 1 << 11)
    public static var setImageFade = YYWebImageOptions(rawValue: 1 << 11)
    
    /// This flag will add the URL to a blacklist (in memory) when the URL fail to be downloaded,
    /// so the library won't keep trying.
    public static var ignoreFailedURL = YYWebImageOptions(rawValue: 1 << 11)
    
    
}

/// Indicated where the image came from.
public enum YYWebImageFromType {
    case none
    /// Fetched from memory cache immediately.
    /// If you called "setImageWithURL:..." and the image is already in memory,
    /// then you will get this value at the same call.
    case memoryCacheFast
    case memoryCache
    case diskCacheCache
    case romote
}

public enum YYWebImageStage {
    /// Incomplete, progressive image.
    case progress
    case cancelled
    case finished
}

/**
 The block invoked in remote image fetch progress.
 
 @param receivedSize Current received size in bytes.
 @param expectedSize Expected total size in bytes (-1 means unknown).
 */
public typealias YYWebImageProgressCallback = (receivedSize: Int, expectedSize: Int) -> Void

/**
 The block invoked when image fetch finished or cancelled.
 
 @param image       The image.
 @param url         The image url (remote or local file path).
 @param from        Where the image came from.
 @param error       Error during image fetching.
 @param finished    If the operation is cancelled, this value is NO, otherwise YES.
 */
public typealias YYWebImageCompletionCallback = (image: UIImage?, url: NSURL?, from: YYWebImageFromType, stage: YYWebImageStage, error: NSError?) -> Void
























