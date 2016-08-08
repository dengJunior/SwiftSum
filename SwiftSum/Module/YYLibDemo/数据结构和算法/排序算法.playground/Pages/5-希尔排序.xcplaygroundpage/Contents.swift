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
    
    //参数 int dk 为缩小增量，如果是直接插入排序，dk=1
    mutating func shellInsertSort(dk: Int) {
        for i in 0 ..< dk {
            /*
             每次循环，i, i+k, i+k+k, ...为一个分组
             对该分组使用插入插入排序
             */
            var insert = i + dk
            while insert < count {
                var current = insert
                var prev = current - dk
                while prev >= 0 {
                    if self[current] < self[prev] {
                        swap(&self[current], &self[prev])
                    } else {
                        break;
                    }
                    current = prev
                    prev -= dk
                }
                insert += dk
            }
        }
    }
    
    /**
     上面的shellsort代码虽然对直观的理解希尔排序有帮助，但代码量太大了，不够简洁清晰。
     因此进行下改进和优化，以第二次排序为例，
     原来是每次从1A到1E，从2A到2E，可以改成从1B开始，先和1A比较，然后取2B与2A比较，
     再取1C与前面自己组内的数据比较…….。
     这种每次从数组第gap个元素开始，每个元素与自己组内的数据进行直接插入排序显然也是正确的。
     */
    mutating func shellInsertSortBetter(dk: Int) {
        //从数组第dk个元素开始
        for i in dk ..< count {
            var insert = i
            var prev = i - dk
            while prev >= 0 {
                if self[insert] < self[prev] {
                    swap(&self[insert], &self[prev])
                } else {
                    break
                }
                insert = prev
                prev -= dk
            }
        }
    }
    
    mutating func shellSort() {
        /*
         我们简单处理增量序列：增量序列d = {n/2 ,n/4, n/8 .....1} n为要排序数的个数即：
         
         1. 先将要排序的一组记录按某个增量d（n/2,n为要排序数的个数）分成若干组子序列，每组中记录的下标相差d.
         2. 对每组中全部元素进行直接插入排序，然后再用一个较小的增量（d/2）对它进行分组，在每组中再进行直接插入排序。
         3. 继续不断缩小增量直至为1，
         4. 最后使用直接插入排序完成排序。
         */
        if count < 2 {
            return
        }
        var dk = count / 2
        while dk >= 1 {
//            shellInsertSort(dk)
            shellInsertSortBetter(dk)
            dk /= 2
        }
    }
}

let arr = ["6", "1", "5", "2", "3", "4"]

var demoArr = arr
demoArr.shellSort()

//: [Next](@next)


















