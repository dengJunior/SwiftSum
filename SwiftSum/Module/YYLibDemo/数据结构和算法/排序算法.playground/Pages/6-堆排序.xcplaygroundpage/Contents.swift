//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    /**
     二叉堆的定义
     
     二叉堆是完全二叉树或者是近似完全二叉树。
     
     二叉堆满足二个特性：
     
     1．父结点的键值总是大于或等于（小于或等于）任何一个子节点的键值。
     
     2．每个结点的左子树和右子树都是一个二叉堆（都是最大堆或最小堆）。
     
     当父结点的键值总是大于或等于任何一个子节点的键值时为最大堆。当父结点的键值总是小于或等于任何一个子节点的键值时为最小堆。
     */
    //插入一个新数据时堆的调整代码
    mutating func minHeadFixup(at index: Int) {
        var i = index
        //  新加入i结点  其父结点为(i - 1) / 2
        var parent = (i - 1) / 2;
        let temp = self[i]
        while parent >= 0 && i != 0 {
            if self[parent] <= temp {
                break
            }
            swap(&self[i], &self[parent])
            i = parent
            parent = (i - 1) / 2
        }
    }
    
    //删除一个数据时堆的调整代码
    mutating func minHeadFixdown(at index: Int, count: Int) {
        //  从i节点开始调整, 从0开始计算 i节点的子节点为 2*i+1, 2*i+2 
        let temp = self[index]
        var i = index
        var leftChild = 2 * i + 1
        while leftChild < count {
            let rightChild = leftChild + 1
            //在左右孩子中找最小的
            if rightChild < count && self[rightChild] < self[leftChild] {
                leftChild += 1
            }
            if self[leftChild] >= temp {
                 break
            }
            //把较小的子结点往上移动,替换它的父结点
            self[i] = self[leftChild]
            i = leftChild
            leftChild = 2 * i + 1
        }
        self[i] = temp
    }
    
    mutating func makeMinHeap() {
        var i = count / 2 - 1
        while i >= 0 {
            minHeadFixdown(at: i, count: count)
            i -= 1
        }
    }
    
    //注意使用最小堆排序后是递减数组，要得到递增数组，可以使用最大堆。
    mutating func minHeadSort() {
        makeMinHeap()
        var i = count - 1
        while i >= 1 {
            swap(&self[i], &self[0])
            minHeadFixdown(at: 0, count: i)
            i -= 1
        }
        
    }
}

let arr = ["6", "1", "5", "2", "3", "4"]

var demoArr = arr
demoArr.minHeadSort()

//: [Next](@next)
