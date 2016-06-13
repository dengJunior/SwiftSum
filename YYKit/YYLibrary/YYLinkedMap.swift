//
//  YYLinkedMap.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYLinkedMapNode<K: Hashable> {
    // retained by dic
    weak var prev: YYLinkedMapNode!
    weak var next: YYLinkedMapNode!
    var key: K!
    var value: AnyObject!
    
    var cost: Int = 0
    var time: NSTimeInterval = 0
}

/**
 A linked map used by YYMemoryCache.
 It's not thread-safe and does not validate the parameters.
 */
class YYLinkedMap<K: Hashable>: NSObject {
    var dict: [K: AnyObject] = [:]
    var head: YYLinkedMapNode<K>!
    var tail: YYLinkedMapNode<K>!
    
    var totalCost: Int = 0
    var totalCount: Int = 0
    var releaseOnMainThread = false
    var releaseAsynchronously = true
    
    func insertHead(node: YYLinkedMapNode<K>) {
        dict[node.key] = node
    }
}
