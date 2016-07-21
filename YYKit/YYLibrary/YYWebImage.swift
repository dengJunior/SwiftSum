//
//  YYWebImage.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

enum YYWebImageOptions {
    case disk
}

/// Indicated where the image came from.
enum YYWebImageFromType {
    case none
    /// Fetched from memory cache immediately.
    /// If you called "setImageWithURL:..." and the image is already in memory,
    /// then you will get this value at the same call.
    case memoryCacheFast
    case memoryCache
    case diskCacheCache
    case romote
}

enum YYWebImageStage {
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
typealias YYWebImageProgressCallback = (receivedSize: Int, expectedSize: Int) -> Void

/**
 The block invoked when image fetch finished or cancelled.
 
 @param image       The image.
 @param url         The image url (remote or local file path).
 @param from        Where the image came from.
 @param error       Error during image fetching.
 @param finished    If the operation is cancelled, this value is NO, otherwise YES.
 */
typealias YYWebImageCompletionCallback = (image: UIImage?, url: NSURL?, from: YYWebImageFromType, stage: YYWebImageStage, error: NSError?) -> Void
























