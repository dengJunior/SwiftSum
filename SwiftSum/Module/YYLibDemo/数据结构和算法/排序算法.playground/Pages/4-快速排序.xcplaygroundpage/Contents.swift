//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    /**
     ## 基本思想：
     
     1. 选择一个基准元素，通常选择第一个元素或者最后一个元素。
     2. 通过一趟排序将待排序的记录分割成独立的两部分，其中一部分记录的元素值均比基准元素值小；另一部分记录的元素值均比基准值大。
     3. 此时基准元素在其排好序后的正确位置
     4. 然后分别对这两部分记录用同样的方法继续进行排序，直到整个序列有序。
     */
    
    func middle<T where T: Comparable>(one: T, two: T, three: T) -> T {
        return min(max(one, two), max(two, three))
    }
    
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
    mutating func quickSort(lowIndex: Int, highIndex: Int) {
        if lowIndex < highIndex {
            // 将表一分为二
            let pivotIndex = partition(lowIndex, highIndex: highIndex)
            
            // 递归对低子表递归排序
            quickSort(lowIndex, highIndex: pivotIndex - 1)
            
            // 递归对高子表递归排序
            quickSort(pivotIndex + 1, highIndex: highIndex)
        }
        
    }
    mutating func quickSort() {
        if count < 2 {
            return
        }
        quickSort(0, highIndex: count - 1)
    }
    
    /*
     ## 快速排序的改进
     快速排序是通常被认为在同数量级（O(nlog2n)）的排序方法中平均性能最好的。但若初始序列按关键码有序或基本有序时，快排序反而蜕化为冒泡排序。为改进之，通常以“三者取中法”来选取基准记录，即将排序区间的两个端点与中点三个记录关键码居中的调整为支点记录。快速排序是一个不稳定的排序方法。
     
     在本改进算法中，只对长度大于k的子序列递归调用快速排序，让原序列基本有序，然后再对整个基本有序序列用插入排序算法排序。实践证明，改进后的算法时间复杂度有所降低，且当k取值为 8 左右时，改进算法的性能最佳。
     */
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

let arr = ["6", "1", "5", "2", "3", "4"]

var demoArr = arr
demoArr.quickSort()
demoArr.quickSortBetter()


//: [Next](@next)


//: [Next](@next)
