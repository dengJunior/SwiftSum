//: [Previous](@previous)

import Foundation

extension Array where Element: Comparable {
    
    func minMaxValueIndex(starIndex: Int = 0) -> (min: Int, max: Int)? {
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
    
    func maxValueIndex(starIndex: Int = 0) -> Int? {
        return minMaxValueIndex(starIndex)?.max
    }
    func minValueIndex(starIndex: Int = 0) -> Int? {
        return minMaxValueIndex(starIndex)?.min
    }
    
    var maxValue: Element? {
        if let max = self.maxValueIndex() {
            return self[max]
        }
        return nil
    }
    var minValue: Element? {
        if let min = self.minValueIndex() {
            return self[min]
        }
        return nil
    }
    
    // MARK: - 最基本的选择排序
    mutating func selectSort() {
        
        /*
         1. 整个排序过程共进行n-1趟
         2. 每次循环，会找出最小的元素，与当前位置的元素交换
         3. 循环了多少次，前面就有多少元素已经排好序了，内循环只需遍历后面未排好的元素
         */
        for begin in 0 ..< count - 1 {
            //只需遍历后面未排好的元素
            for next in begin+1 ..< count {
                //选出最小的一个数与每次循环开始位置的元素交换；
                if let min = self.minValueIndex(next) {
                    if self[min] < self[begin] {
                        swap(&self[begin], &self[min])
                    }
                }
            }
            print(self)
        }

    }
    
    // MARK: - 算法的改进（二元选择排序）
    
    /**
     简单选择排序，每趟循环只能确定一个元素排序后的定位。我们可以考虑改进为每趟循环确定两个元素（当前趟最大和最小记录）的位置,从而减少排序所需的循环次数。改进后对n个数据进行排序，最多只需进行[n/2]趟循环即可。
     */
    mutating func selectSortBetter() {
        /*
         1. 整个排序过程共进行n/2趟
         2. 每次循环，会找出最小和最大的元素，与起始位置的元素交换
         */
        for begin in 0 ..< count / 2 {
            //设置每躺循环的起始位置
            let end = count-1 - begin
            
            var max = begin
            var min = begin
            
            for next in begin+1 ... end {
                //选出最小元素的索引
                if self[next] < self[min] {
                    min = next
                    continue
                }
                
                if self[next] > self[max] {
                    max = next
                }
            }
            
            //先放最小的元素
            if min != begin {
                /*
                 因为会将最小元素和第一个元素交换
                 所以如果第一个元素就是最大的元素，那么max应该指向交换后的索引
                 */
                if begin == max {
                    max = min
                }
                swap(&self[begin], &self[min])
            }
            
            if max != end {
                swap(&self[end], &self[max])
            }
            
            print(self)
        }
    }
}

extension String {
    func toArray() -> [String] {
        var arr = [String]()
        for char in self.unicodeScalars {
            arr.append(String(char))
        }
        return arr
    }
}

//let arr = "2135".toArray()
let arr = ["6", "1", "5", "2", "3", "4"]

var demoArr = arr
demoArr.selectSort()

demoArr = arr
demoArr.selectSortBetter()

//: [Next](@next)
