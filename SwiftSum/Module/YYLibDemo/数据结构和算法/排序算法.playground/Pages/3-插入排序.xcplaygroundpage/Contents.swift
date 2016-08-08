//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    /**
     将 array[j] 插入到前面a[0…j-1]的有序区间所用的方法进行改写，用数据交换代替数据后移。
     如果 array[j] 前一个数据 array[j-1] > array[j]，就交换 array[j] 和 array[j-1]，再 j--
     直到 array[j-1] <= array[j]。这样也可以实现将一个新数据并入到有序区间。
     */
    mutating func insertSort() {
        /*
         1. 整个排序过程共进行n-1趟
         2. 每次取一个元素插入到前面排好序的数组中
         */
        if count < 2 {
            return
        }
        //每次取一个元素插入
        for insert in 1 ..< count {
            var current = insert
            while current > 0 {
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

let arr = ["6", "1", "5", "2", "3", "4"]

var demoArr = arr
demoArr.insertSort()


//: [Next](@next)
