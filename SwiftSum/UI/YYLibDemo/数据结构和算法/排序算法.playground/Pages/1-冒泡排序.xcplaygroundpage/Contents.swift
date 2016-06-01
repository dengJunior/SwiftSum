//: [Previous](@previous)

import Foundation

//参考 http://www.jianshu.com/p/d7fc06845a6f
extension Array where Element: Comparable {
    // MARK: - 最基本的冒泡排序
    mutating func bubbleSort1() {
        /*
         1. 整个排序过程共进行n-1趟
         2. 每次循环，会找出最大的元素，放到末尾
         3. 循环了多少次，末尾就有多少元素已经排好序了，内循环只需遍历前面未排好的元素
         */
        let totalLoop = count - 1
        
        for loopCount in 0 ..< totalLoop {
            //只需遍历前面未排好的元素
            for current in 0 ..< totalLoop - loopCount {
                let next = current + 1
                //比较相邻的2个元素，并把较大的元素往后面放
                if self[current] > self[next] {
                    swap(&self[current], &self[next])
                }
            }
            print(self)
        }
    }
    
    // MARK: - 冒泡排序算法的改进
    
    /*
     1. 对冒泡排序常见的改进方法是加入一标志性变量exchange，用于标志某一趟排序过程中是否有数据交换，如果进行某一趟排序时并没有进行数据交换，则说明数据已经按要求排列好，可立即结束排序，避免不必要的比较过程。
     */
    mutating func bubbleSortBetter1() {
        
        /*
         1. 整个排序过程共最多进行n-1趟，当没有元素交换时，就已经全部排好序了
         2. 每次循环，会找出最大的元素，放到末尾
         3. 循环了多少次，末尾就有多少元素已经排好序了，内循环只需遍历前面未排好的元素
         
         可以相对减少循环总次数
         */
        let totalLoop = count - 1
        for loopCount in 0 ..< totalLoop {
             var sorted = true
            
            for current in 0 ..< totalLoop - loopCount {
                let next = current + 1
                //比较相邻的2个元素，并把较大的元素往后面放
                if self[current] > self[next] {
                    swap(&self[current], &self[next])
                    sorted = false//这次循环进行了数据交换，说明没排好序
                }
            }
            print(self)
            //如果进行某一趟排序时并没有进行数据交换，则说明数据已经按要求排列好，可立即结束排序
            if sorted { break }
        }
    }
    
    /*
     2. 设置一标志性变量pos,用于记录每趟排序中最后一次进行交换的位置。由于pos位置之后的记录均已交换到位,故在进行下一趟排序时只要扫描到pos位置即可。
     */
    mutating func bubbleSortBetter2() {
        
        /*
         1. unSortedIndex记录每趟排序中最后一次进行交换的位置。
         2. 每次循环，只会对0~unSortedIndex进行比较，并找出最大的元素，放到末尾
         3. 当没有元素交换时，表示已经排好序，所以整个排序过程共最多进行n-1趟
         
         可以在上面基础上再相对减少循环总次数
         */
        var unSortedIndex = count - 1
        var sorted = false
        
        while !sorted {
            //如果进行某一趟排序时并没有进行数据交换，则说明数据已经按要求排列好，可立即结束排序
            sorted = true
            
            //每次循环，只会对0~unSortedIndex进行比较
            for current in 0 ..< unSortedIndex {
                let next = current + 1
                //比较相邻的2个元素，并把较大的元素往后面放
                if self[current] > self[next] {
                    swap(&self[current], &self[next])
                    unSortedIndex = current //记录每趟排序中最后一次进行交换的位置
                    sorted = false
                }
            }
            print(self)
        }
    }
    
    /*
     3. 传统冒泡排序中每一趟排序操作只能找到一个最大值或最小值,我们考虑利用在每趟排序中进行正向和反向两遍冒泡的方法一次可以得到两个最终值(最大者和最小者) , 从而使排序趟数几乎减少了一半。
     
     但总次数其实是一样的，有个卵用，不实现了
     */
    mutating func bubbleSortBetter3() {
        
    }
}

let arr = ["6", "1", "5", "2", "3", "4",]

var demoArr = arr
demoArr.bubbleSort1()

demoArr = arr
demoArr.bubbleSortBetter1()

demoArr = arr
demoArr.bubbleSortBetter2()


//: [Next](@next)



