//: Playground - noun: a place where people can play

import Cocoa


/*
## 1-Swift数组高阶函数Map等使用

### 1.闭包介绍

Swift一大特性便是使用简洁的头等函数/闭包语法代替了复杂的blocks语法。（头等函数-即可将函数当作参数传递给其他的函数，或从其他的函数里返回值，并且可以将他们设定为变量，或者将他们存储在数据结构中）

闭包是自包含的blocks，它能在代码中传递和使用。让我们来看一些闭包例子以及它们为什么如此有用：

假设我们需要两个函数，其中一个计算两个数的平方的平均值，另一个计算两个数的立方的平均值，传统的解决方法会是这样：*/

func square(a:Float) -> Float {
    return a * a
}
func cube(a:Float) -> Float {
    return a * a * a
}
func averageSumOfSquares(a:Float,b:Float) -> Float {
    return (square(a) + square(b)) / 2.0
}
func averageSumOfCubes(a:Float,b:Float) -> Float {
    return (cube(a) + cube(b)) / 2.0
}

/*
我们注意到averageSumOfSquares和averageSumOfCubes的唯一不同只是分别调用平方函数或立方函数。
如果我能够定义一个通用函数，这个函数以两个数和一个使用这两个数的函数作为参数，
来计算平均值而不是重复调用将会非常好，我们可以使用闭包作为函数参数
*/
func averageOfFunction(a:Float, b:Float, f:(Float -> Float)) -> Float {
    return (f(a) + f(b))/2
}

//这里我们使用了命名闭包，我们也可以使用闭包表达式定义一个没有名称的内联闭包。
averageOfFunction(3, b: 4, f: square)
averageOfFunction(3, b: 4, f: cube)

/*
在Swift中有很多种定义闭包表达式的方法，这里从最啰嗦的开始讲到最简洁的为止：
(x: Float) -> Float 是闭包的类型（接收一个float参数，返回一个float值），
return x * x 为实现，关键字in为代码头，实现跟在in后面，简化一下。
*/
averageOfFunction(3, b: 4, f: {(x: Float) -> Float in return x * x})

/*
首先我们忽略类型声明，因为类型能够从averageOfFunction声明中推断出来
（编译器能够推断出averageOfFunction期望传入作为参数的函数需要接收一个float值，然后返回另一个float值）
*/
averageOfFunction(3, b: 4, f: { x in return x * x})

//还可以忽略return语句
averageOfFunction(3, b: 4, f: { x in x * x})

/*
最后我们还可以忽略指定参数名，使用默认参数名$0
（如果函数接收多个参数，使用$K作为第K-1个参数，如$0，$1，$2......）*/
averageOfFunction(3, b: 4, f: { $0 * $0 })


/*
数组操作

Swift的标准数组支持三个高阶函数：map，filter和reduce。
Objective-C的NSArray没有实现这些方法，但是开源社区弥补了这个不足(https://github.com/stuartervine/OCTotallyLazy)*/

/**
*  Map
map函数能够被数组调用，它接受一个闭包作为参数，作用于数组中的每个元素。闭包返回一个变换后的元素，接着将所有这些变换后的元素组成一个新的数组
*/

/**
*  1. 比如我们有一个这样的需求遍历一个数组中所有的元素，将每个元素自身与自身相加，最后返回一个保存相加后元素的数组
*/

let numbers = [1,2,3]
var sumNumbers = [Int]()
for var number in numbers {
    number += number
    sumNumbers.append(number)
}
// [2,4,6]
print(sumNumbers)

//数组的map函数可以帮我们简化上面的代码
let sumNumbers1 = numbers.map { (number) -> Int in
    return number + number
}
print(sumNumbers1)

// 下面介绍简便写法 因为map闭包里面的类型可以自动推断所以可以省略
let sumNumbers2 = numbers.map { number in
    return number + number
}
print(sumNumbers2)

// 可以省了return
let sumNumbers3 = numbers.map { number in
    number + number
}
print(sumNumbers3)

// 最终简化写法
let sumNumbers4 = numbers.map { $0 + $0 }
print(sumNumbers4)


/**
*  2. Map函数返回数组的元素类型不一定要与原数组相同
*/
let fruits = ["apple", "banana", "orange", ""]
// 这里数组中存在一个""的字符串 为了后面来比较 map 和 flatMap
let counts = fruits.map { fruit -> Int? in
    let length = fruit.characters.count
    guard length > 0 else {
        return nil
    }
    return length
}
// [Optional(5), Optional(6), Optional(6), nil]
print(counts)



/**
*  3. Map还能返回判断数组中的元素是否满足某种条件的Bool值数组
*/
let array = [1,2,3,4,5,6]
// 最洁简的写法
let isEven = array.map{ $0 % 2 == 0 }
//[false, true, false, true, false, true]
print(isEven)



/**
*  FlatMap
flatMap 与 map 不同之处是
flatMap返回后的数组中不存在 nil 同时它会把Optional解包;
flatMap 还能把数组中存有数组的数组 一同打开变成一个新的数组 ;
flatMap也能把两个不同的数组合并成一个数组 这个合并的数组元素个数是前面两个数组元素个数的乘积
*/

/**
*  1. flatMap返回后的数组中不存在nil 同时它会把Optional解包
*/


let fruits1 = ["apple", "banana", "orange", ""]
let counts1 = fruits1.flatMap { fruit -> Int? in
    let length = fruit.characters.count
    guard length > 0 else {
        return nil;
    }
    return length
}
// [5,6,6]
print(counts1)


/**
*  2. flatMap 还能把数组中存有数组的数组 一同打开变成一个新的数组
*/
let array1 = [[1,2,3], [4,5,6], [7,8,9]]
let arrayMap = array1.map{ $0 }
// [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
print(arrayMap)

let arrayFlatMap = array1.flatMap{ $0 }
// [1, 2, 3, 4, 5, 6, 7, 8, 9]
print(arrayFlatMap)


/**
*  3. flatMap也能把两个不同的数组合并成一个数组 这个合并的数组元素个数是前面两个数组元素个数的乘积
*/
// 这种情况是把两个不同的数组合并成一个数组 这个合并的数组元素个数是前面两个数组元素个数的乘积
let fruits2 = ["apple", "banana", "orange"]
let counts2 = [1, 2, 3]

let fruitCounts2 = counts2.flatMap{ count in
    fruits2.map { fruit in
//        title + "\(index)"
        (fruit, count)
    }
}
// [("apple", 1), ("banana", 1), ("orange", 1), ("apple", 2), ("banana", 2), ("orange", 2), ("apple", 3), ("banana", 3), ("orange", 3)]
print(fruitCounts2)
// 这种方法估计用的很少 可以算是一个 flatMap 和 map 的结合使用吧



/**
*  Filter
filter 可以取出数组中符合条件的元素 重新组成一个新的数组

filter可以很好的帮我们把数组中不需要的值都去掉
*/
let numbers2 = [1,2,3,4,5,6]
let evens = numbers2.filter{ $0 % 2 == 0 }
// [2, 4, 6]
print(evens)




/**
*  Reduce
map,flatMap和filter方法都是通过一个已存在的数组，生成一个新的、经过修改的数组。
然而有时候我们需要把所有元素的值合并成一个新的值 那么就用到了Reduce
需要注意的是combine函数的两参数类型不同，$0为计算结果类型，$1为数组元素类型。
*/


/**
*  1. 比如我们要获得一个数组中所有元素的和
*/
let numbers3 = [1,2,3,4,5]
// reduce 函数第一个参数是返回值的初始化值
let sum = numbers3.reduce(0) { $0 + $1 }

// 这里我写下完整的格式
let sum1 = numbers3.reduce(0) { (total, num) -> Int in
    return total + num
}
print(sum)
print(sum1)



/**
*  2. 合并成的新值不一定跟原数组中元素的类型相同
*/
let numbers4 = [1,5,1,8,8,8,8,8,8,8,8]
// reduce 函数第一个参数是返回值的初始化值
let tel = numbers4.reduce("") { "\($0)" + "\($1)" }
// 15188888888
print(tel)




/**
*  3. ruduce 还可以实现 map 和 filter 并且时间复杂度变为O(n) 
原来 map 和 filter 的时间复杂度是O(n*n)
*/
extension Array {
    func mMap<U>(transform: Element -> U) -> [U] {
        return reduce([], combine: { $0 + [transform($1)]})
    }
    
    func mFilter (includeElement: Element -> Bool) -> [Element] {
        return reduce([]) { includeElement($1) ? $0 + [$1] : $0 }
    }
}


/**
*  另一点需要说明的是数据比较大的时候，高阶函数会比传统实现更快，因为它可以并行执行（如运行在多核上），
除非真的需要更高定制版本的map，reduce和filter，否则可以一直使用它们以获得更快的执行速度。
*/


























