//
//  BooleanTypeyyy.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/1.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/*
 if (42) {
    print("42 is the truth!")
 }
 */
extension Int: BooleanType {
    public var boolValue: Bool {
        return self != 0
    }
}

/*
 let opt1: String? = nil
 if opt1 {
    print("opt 1 appears true!")
 }
 */
extension Optional: BooleanType {
    public var boolValue: Bool {
        switch self {
        case .None:
            return false
        case .Some:
            return true
        }
    }
}

/*
 if [0, 1, 2] {
    print("non-empty arrays are true!")
 }
 */
extension Array: BooleanType {
    public var boolValue: Bool {
        return self.count > 0
    }
}









