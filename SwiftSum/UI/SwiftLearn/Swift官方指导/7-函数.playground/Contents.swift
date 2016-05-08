//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 函数定义与调用（Defining and Calling Functions）
 - 函数参数与返回值（Function Parameters and Return Values）
 - 函数参数名称（Function Parameter Names）
 - 函数类型（Function Types）
 - 嵌套函数（Nested Functions）
 */

// MARK: - ## 函数的定义与调用（Defining and Calling Functions）

// MARK: - ## 函数参数与返回值（Function Parameters and Return Values）

//>注意
//没有定义返回类型的函数会返回特殊的值，叫 Void。它其实是一个空的元组（tuple），没有任何元素，可以写成()。

//你可以用元组（tuple）类型让多个值作为一个复合值从函数中返回。

// MARK: - ## 函数参数名称（Function Parameter Names）

//函数参数都有一个外部参数名（external parameter name）和一个局部参数名（local parameter name）。外部参数名用于在函数调用时标注传递给函数的参数，局部参数名在函数的实现内部使用。

func someFunction(
    first: Int,//第一个参数省略其外部参数名
    second: Int,//第二个以及随后的参数使用其局部参数名作为外部参数名。
    three third: Int,//在局部参数名前指定外部参数名，中间以空格分隔：
    _ four: Int,//用一个下划线（_）代替一个明确的参数名。
    five: Int = 5, //为每个参数定义默认值（Deafult Values）。当默认值被定义后，调用这个函数时可以忽略这个参数。
    var six: Int,//在参数名前加关键字 var 来定义变量参数。将在swift3中作废
    ints: Int... //可变参数的传入值在函数体中变为此类型的一个数组。
    ) {
    six += 1
    var total = first+second+third+four+five + six
    for num in ints {
        total += num
    }
    print(total)
}
someFunction(1, second: 2, three: 3, 4, six: 5, ints: 6,7,8,9,10)

// MARK: - ### 指定外部参数名（Specifying External Parameter Names）

//在局部参数名前指定外部参数名，中间以空格分隔：

// MARK: - ### 忽略外部参数名（Omitting External Parameter Names）

//如果不想为第二个及后续的参数设置外部参数名，用一个下划线（_）代替一个明确的参数名。

// MARK: - ### 默认参数值（Default Parameter Values）

//你可以在函数体中为每个参数定义默认值（Deafult Values）。当默认值被定义后，调用这个函数时可以忽略这个参数。
someFunction(1, second: 2, three: 3, 4, six: 5)

// MARK: - ### 可变参数（Variadic Parameters）

//一个可变参数（variadic parameter）可以接受零个或多个值。函数调用时，你可以用可变参数来指定函数参数可以被传入不确定数量的输入值。通过在变量类型名后面加入（...）的方式来定义可变参数。

//可变参数的传入值在函数体中变为此类型的一个数组。
someFunction(1, second: 2, three: 3, 4, six: 5, ints: 6,7,8,9,10)

/**
 *  >注意
 一个函数最多只能有一个可变参数。
 如果函数有一个或多个带默认值的参数，而且还有一个可变参数，那么把可变参数放在参数表的最后。
 */

// MARK: - ### 常量参数和变量参数（Constant and Variable Parameters）

//函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误。这意味着你不能错误地更改参数值。

//通过在参数名前加关键字 var 来定义变量参数：


// MARK: - ### 输入输出参数（In-Out Parameters）

//如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数（In-Out Parameters）。

//当传入的参数作为输入输出参数时，需要在参数名前加&符，表示这个值可以被函数修改。

//>注意
//输入输出参数不能有默认值，而且可变参数不能用 inout 标记。如果你用 inout 标记一个参数，这个参数不能被 var 或者 let 标记。
func swapTwoInts(inout a: Int, inout _ b: Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// prints "someInt is now 107, and anotherInt is now 3"

// MARK: - ## 函数类型（Function Types）

//每个函数都有种特定的函数类型，由函数的参数类型和返回类型组成。在 Swift 中，使用函数类型就像使用其他类型一样。
func addTwoInts(a: Int, _ b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts

// MARK: - ## 嵌套函数（Nested Functions）

//上面的都是全局函数（global functions），它们定义在全局域中。你也可以把函数定义在别的函数体中，称作嵌套函数（nested functions）。

//默认情况下，嵌套函数是对外界不可见的，但是可以被它们的外围函数（enclosing function）调用。一个外围函数也可以返回它的某一个嵌套函数，使得这个函数可以在其他域中被使用。

func chooseStepFunction(forward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return forward ? stepForward : stepBackward
}

var currentValue = -4
let moveToZero = chooseStepFunction(currentValue < 0)
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveToZero(currentValue)
}
print("zero!")












