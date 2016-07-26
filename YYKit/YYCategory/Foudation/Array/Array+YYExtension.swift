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
    
    // MARK: - 快速排序
    // 将数组分割成独立的两部分
    mutating func partition(lowIndex: Int, highIndex: Int) -> Int {
        //基准元素
        //        let sentinel = middle(self[lowIndex], two: self[highIndex/2], three: self[highIndex])
        let sentinel = self[lowIndex]
        
        var low = lowIndex
        var high = highIndex
        
        // 从表的两端交替地向中间扫描
        while low < high {
            while low < high && self[high] >= sentinel {
                high -= 1
            }
            // 从 high 所指位置向前搜索，至多到 low+1 位置。将比基准元素小的交换到前端
            if low != high {
                swap(&self[high], &self[low])
            }
            
            while low < high && self[low] <= sentinel {
                low += 1
            }
            // 从 low 所指位置向后搜索，至多到 high-1 位置。将比基准元素大的交换到后端
            if low != high {
                swap(&self[low], &self[high])
            }
        }
        //print(self)
        return low
    }
    
    mutating func quickSortImprove(lowIndex: Int, highIndex: Int, k: Int) {
        // 长度大于k时递归，k为指定数
        if highIndex - lowIndex > k {
            // 将表一分为二
            let pivotIndex = partition(lowIndex, highIndex: highIndex)
            
            // 递归对低子表递归排序
            quickSortImprove(lowIndex, highIndex: pivotIndex - 1, k: k)
            
            // 递归对高子表递归排序
            quickSortImprove(pivotIndex + 1, highIndex: highIndex, k: k)
        }
    }
    mutating func quickSortBetter() {
        if count < 2 {
            return
        }
        
        // 先调用改进算法，使之基本有序
        quickSortImprove(0, highIndex: count - 1, k: 8)
        //实践证明，改进后的算法时间复杂度有所降低，且当k取值为 8 左右时，改进算法的性能最佳。
        
        // 再用插入排序对基本有序序列排序
        //每次取一个元素插入
        for insert in 1 ..< count {
            var current = insert
            while current > 0{
                let prev = current - 1
                //如果插入元素小于前一个元素 就交换2者，直到找到合适插入位置
                if self[current] < self[prev] {
                    swap(&self[current], &self[prev])
                    current -= 1
                } else {
                    break
                }
            }
            
            print(self)
        }
    }
}



