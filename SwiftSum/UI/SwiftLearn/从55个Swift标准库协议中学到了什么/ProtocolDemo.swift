//
//  ProtocolDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/1.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ProtocolDemo: NSObject {
    
}

/**
 Swift标准库包括54个真正的共有协议。
 我把它们分成三类。"Can do"协议，"Is a"协议，"Can be"协议。
 */

// MARK: - "Can do"协议


struct YYKey {
    var key = ""
}

// MARK: Hashable
/**
 Hashable
 
 1. 需要实现 hashValue属性的getter
 2. 需要实现Equatable协议--实现==函数，注意是在外面
 */
extension YYKey: Hashable {
    var hashValue: Int {
        return key.hashValue
    }
}
func == (left: YYKey, right: YYKey) -> Bool {
    return left.hashValue == right.hashValue
}

// MARK: Comparable
/**
 Comparable
 
 1. 需要实现 < <= > >= 四个函数
 */
extension YYKey: Comparable {
    
}
func < (left: YYKey, right: YYKey) -> Bool{
    return left.key < right.key
}
func <= (left: YYKey, right: YYKey) -> Bool{
    return left.key <= right.key
}
func > (left: YYKey, right: YYKey) -> Bool{
    return left.key > right.key
}
func >= (left: YYKey, right: YYKey) -> Bool{
    return left.key >= right.key
}

// MARK: RawRepresentable
/**
 RawRepresentable
 
 1. associatedtype RawValue
 2. public init?(rawValue: Self.RawValue)
 3. public var rawValue: Self.RawValue { get }
 */
extension YYKey: RawRepresentable {
    var rawValue: String {
        return key
    }
    init?(rawValue: String) {
        key = rawValue
    }
}

// MARK: - CollectionType
/*
 protocol CollectionType : Indexable, SequenceType
 */
//extension YYKey: CollectionType {
//    
//}



