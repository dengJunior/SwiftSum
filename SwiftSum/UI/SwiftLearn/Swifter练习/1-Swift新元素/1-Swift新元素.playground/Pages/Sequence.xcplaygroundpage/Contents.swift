//: [Previous](@previous)

import Foundation

/*
 Swift 的 for...in 可以用在所有实现了 SequenceType 的类型上，而为了实现 SequenceType 你首先需要实现一个 GeneratorType。
 */

//比如一个实现了反向的 generator 和 sequence 可以这么写：

// 先定义一个实现了 GeneratorType protocol 的类型
// GeneratorType 需要指定一个 typealias Element
// 以及提供一个返回 Element? 的方法 next()”
class ReverseGenerator<T>: GeneratorType {
    typealias Element = T
    
    var array: [Element]
    var currentIndex = 0
    
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    
    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        }
        let element = array[currentIndex]
        currentIndex -= 1
        return element
    }
}

// 然后我们来定义 SequenceType
// 和 GeneratorType 很类似，不过换成指定一个 typealias Generator
// 以及提供一个返回 Generator? 的方法 generate()”
struct ReverseSequence<T>: SequenceType {
    var array: [T]
    init(array: [T]) {
        self.array = array
    }
    
    typealias Generator = ReverseGenerator<T>
    func generate() -> Generator {
        return ReverseGenerator(array: array)
    }
}

let arr = [2, 2, 3, 4, 5]
let reverse = ReverseSequence(array: arr)

for i in reverse {
    print(i) //5 4 3 2 2
}

//for...in展开大概是这样
var g = reverse.generate()
while let obj = g.next() {
    print(obj) //5 4 3 2 2
}

/*
 另外ReverseSequence可以直接使用map,filter,reduce等方法，因为SequenceType扩展已经实现它们
 */
print(reverse.map{ $0 + 1 })// 6 5 4 3 3


//: [Next](@next)
