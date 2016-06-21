//
//  AlgorithmsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension Array where Element: Comparable{
    func test() {
        
    }
}

// MARK: - 各种排序算法
class AlgorithmsDemo: NSObject {
    
    static func launch() {
        AlgorithmsDemo().launch()
    }
    
    func launch() {
        let arr = ["6", "9", "1", "2", "3", "7", "5", "4", "4"]
        var demoArr = arr
        print(demoArr)
        
        bubbleSort(&demoArr)
        print(demoArr)
    }
    
    
    func swap<T: Comparable>(inout a: T, inout _ b: T) {
        let tempA = a
        a = b
        b = tempA
    }
    
    // MARK: - 1. 冒泡排序
    /**
     冒泡排序可谓是最经典的排序算法了，它是基于比较的排序算法，时间复杂度为O(n^2)，其优点是实现简单，n较小时性能较好。
     
     算法原理
     相邻的数据进行两两比较，小数放在前面，大数放在后面，这样一趟下来，最小的数就被排在了第一位，第二趟也是如此，如此类推，直到所有的数据排序完成
     */
    func bubbleSort<T: Comparable>(inout arr: [T]) {
        let count = arr.count
        for current in 0 ..< count {
            for next in current+1 ..< count {
                if arr[next] < arr[current] {
                    swap(&arr[current], &arr[next])
                }
            }
        }
    }
    
    // MARK: - 2.
}








