//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    /**
     - 1）选择一个基准元素，通常选择第一个元素或者最后一个元素。
     - 2）通过一趟排序将待排序的记录分割成独立的两部分，其中一部分记录的元素值均比基准元素值小；另一部分记录的元素值均比基准值大。
     - 3）此时基准元素在其排好序后的正确位置
     - 4）然后分别对这两部分记录用同样的方法继续进行排序，直到整个序列有序。
     */
    mutating func quickSort() {
        if count < 2 {
            return
        }
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

let arr = ["6", "1", "5", "2", "3", "4"]

var demoArr = arr
demoArr.quickSort()()


//: [Next](@next)


//: [Next](@next)
