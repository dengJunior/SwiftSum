//: [Previous](@previous)

import Foundation

/**
 ## 基本思想：
 
 先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，待整个序列中的记录“基本有序”时，再对全体记录进行依次直接插入排序。相对直接排序有较大的改进。
 
 操作方法：
 
 1. 选择一个增量序列t1，t2，…，tk，其中ti>tj，tk=1；
 
 2. 按增量序列个数k，对序列进行k趟排序；
 
 3. 每趟排序，根据对应的增量ti，将待排序列分割成若干长度为m的子序列，分别对各子表进行直接插入排序。仅增量因子为1时，整个序列作为一个表来处理，表长度即为整个序列的长度。
 */
extension Array where Element: Comparable {
    
    /**
     ## 算法的实现：
     我们简单处理增量序列：增量序列d = {n/2 ,n/4, n/8 .....1} n为要排序数的个数即：
     
     1. 先将要排序的一组记录按某个增量d（n/2,n为要排序数的个数）分成若干组子序列，每组中记录的下标相差d.
     2. 对每组中全部元素进行直接插入排序，然后再用一个较小的增量（d/2）对它进行分组，在每组中再进行直接插入排序。
     3. 继续不断缩小增量直至为1，
     4. 最后使用直接插入排序完成排序。
     */
    
    // 直接插入排序的一般形式，参数 int dk 为缩小增量，如果是直接插入排序，dk=1
    mutating func shellInsertSort(dk: Int) {
        /*
         1. 整个排序过程共进行n-1趟
         2. 每次取一个元素插入到前面排好序的数组中
         */
        if count < 2 {
            return
        }
        
        // 若第i个元素大于i-dk元素，直接插入；小于的话，移动有序表后插入
        for i in dk ..< count {
            
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
demoArr.insertSort()

//: [Next](@next)
