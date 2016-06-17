//: [Previous](@previous)

import Foundation

/**
 - 数组下标越界直接崩，
 - 字典下标可能返回nil

 Swift 允许我们自定义下标
 
    1. 这不仅包含了对自己写的类型进行下标自定义，
    2. 也包括了对那些已经支持下标访问的类型 (没错就是 Array 和 Dictionay) 进行扩展。
 
 我们重点来看看向已有类型添加下标访问的情况吧，比如说 Array。很容易就可以在 Swift 的定义文件里找到 Array 已经支持的下标访问类型：
 
 subscript (index: Int) -> T
 subscript (subRange: Range<Int>) -> Slice<T>
 共有两种，它们分别接受单个 Int 类型的序号和一个表明范围的 Range<Int>，作为对应，返回值也分别是单个元素和一组对应输入返回的元素。
 */

var arr = [1,2,3,4,5,6]
print(arr[0])
print(arr[Range(1..<3)])//返回index为1，2的元素的数组

/**
 但是我们发现一个挺郁闷的问题，那就是我们很难一次性取出某几个特定位置的元素，比如在一个数组内，我想取出 index 为 0, 2, 3 的元素的时候，现有的体系就会比较吃力。
 
 我们很可能会要去枚举数组，然后在循环里判断是否是我们想要的位置。其实这里有更好的做法，比如说可以实现一个接受数组作为下标输入的读取方法：
 */
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

//使用如下

print(arr[[0, 2, 4]])//[1,3,5]

arr[[0, 2, 4]] = [-1,-2,-3]
print(arr[[0, 2, 4]])//[-1,-2,-3]


// MARK: - 另一种更好的实现方式
/**
 虽然我们在这里实现了下标为数组的版本，但是我并不推荐使用这样的形式。
 
 - 如果阅读过参数列表一节的读者也许会想为什么在这里我们不使用看起来更优雅的参数列表的方式，也就是 subscript(input: Int...) 的形式。
 - 不论从易用性还是可读性上来说，参数列表的形式会更好。
    - 但是存在一个问题，那就是在只有一个输入参数的时候参数列表会导致和现有的定义冲突，有兴趣的读者不妨试试看。
    - 当然，我们完全可以使用至少两个参数的的参数列表形式来避免这个冲突，即定义形如 subscript(first: Int, second: Int, others: Int...) 的下标方法，
 */





//: [Next](@next)
