//
//  Array+YYExtension.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/1.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension Array {
    /**
     一次性取出某几个特定位置的元素的功能
     var arr = [1,2,3,4,5,6]
     print(arr[[0, 2, 4]])//[1,3,5]
     
     arr[[0, 2, 4]] = [-1,-2,-3]
     print(arr[[0, 2, 4]])//[-1,-2,-3]
     */
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "Index out of range")
                result.append(self[i])
            }
            return result
        }
        set {
            for (index, i) in input.enumerate() {
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

// MARK: - 取最大最小值
extension Array where Element: Comparable {
    public var maxValue: Element? {
        if let max = self.maxValueIndex() {
            return self[max]
        }
        return nil
    }
    public var minValue: Element? {
        if let min = self.minValueIndex() {
            return self[min]
        }
        return nil
    }
    
    public func minMaxValueIndex(starIndex: Int = 0) -> (min: Int, max: Int)? {
        if starIndex < count - 1 {
            var max = starIndex
            var min = starIndex
            
            for current in starIndex+1 ..< count {
                if self[current] > self[max] {
                    max = current
                }
                
                if self[current] < self[min] {
                    min = current
                }
                return (min, max)
            }
        }
        return nil
    }
    
    public func maxValueIndex(starIndex: Int = 0) -> Int? {
        return minMaxValueIndex(starIndex)?.max
    }
    public func minValueIndex(starIndex: Int = 0) -> Int? {
        return minMaxValueIndex(starIndex)?.min
    }
}

// MARK: - 排序
extension Array where Element: Comparable {
    
    //冒泡
    public mutating func bubbleSort() {
        var unSortedIndex = count - 1
        var sorted = false
        
        while !sorted {
            sorted = true
            for current in 0 ..< unSortedIndex {
                let next = current + 1
                if self[current] > self[next] {
                    swap(&self[current], &self[next])
                    unSortedIndex = current
                    sorted = false
                }
            }
        }
    }
    
    //二元选择排序
    public mutating func selectSort() {
        for begin in 0 ..< count / 2 {
            let end = count-1 - begin
            var max = begin
            var min = begin
            
            for next in begin+1 ... end {
                if self[next] < self[min] {
                    min = next
                    continue
                }
                
                if self[next] > self[max] {
                    max = next
                }
            }
            
            if min != begin {
                if begin == max {
                    max = min
                }
                swap(&self[begin], &self[min])
            }
            if max != end {
                swap(&self[end], &self[max])
            }
        }
    }
}



