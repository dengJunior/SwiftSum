//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 闭包表达式（Closure Expressions）
 - 尾随闭包（Trailing Closures）
 - 值捕获（Capturing Values）
 - 闭包是引用类型（Closures Are Reference Types）
 - 非逃逸闭包(Nonescaping Closures)
 - 自动闭包（Autoclosures）
 
 闭包是自包含的函数代码块，可以在代码中被传递和使用。
 
 - 闭包可以捕获和存储其所在上下文中任意常量和变量的引用。
 - 这就是所谓的闭合并包裹着这些常量和变量，俗称闭包。
 - Swift 会为您管理在捕获过程中涉及到的所有内存操作。
 
 在函数章节中介绍的全局和嵌套函数实际上也是特殊的闭包，闭包采取如下三种形式之一：
 
 - 全局函数是一个有名字但不会捕获任何值的闭包
 - 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
 - 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包
 */

// MARK: - ## 闭包表达式（Closure Expressions）

//闭包表达式是一种利用简洁语法构建内联闭包的方式。闭包表达式语法有如下一般形式：

//{ (parameters) -> returnType in
//    statements
//}

//闭包表达式语法可以使用常量、变量和inout类型作为参数，不能提供默认值。也可以在参数列表的最后使用可变参数。元组也可以作为参数和返回值。

//闭包的函数体部分由关键字in引入。该关键字表示闭包的参数和返回值类型定义已经完成，闭包函数体即将开始。


let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// MARK: - ### 1. 普通函数版
func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
var reversed = names.sort(backwards)

// MARK: - ### 2. 闭包表达式版
reversed = names.sort({
    (s1: String, s2: String) -> Bool in
    return s1 > s2
})

//### 3. 由于这个闭包的函数体部分如此短，以至于可以将其改写成一行代码：
reversed = names.sort( { (s1: String, s2: String) -> Bool in return s1 > s2 } )

// MARK: - ### 4. 根据上下文推断类型（Inferring Type From Context）

//因为排序闭包函数是作为sort(_:)方法的参数传入的，Swift 可以推断其参数和返回值的类型。

//这意味着(String, String)和Bool类型并不需要作为闭包表达式定义的一部分。因为所有的类型都可以被正确推断，返回箭头（->）和围绕在参数周围的括号也可以被省略：
reversed = names.sort({ s1, s2 in return s1 > s2 })

// MARK: - ### 5. 单表达式闭包隐式返回（Implicit Return From Single-Expression Clossures）

//单行表达式闭包可以通过省略return关键字来隐式返回单行表达式的结果，
reversed = names.sort( {s1, s2 in s1 > s2 })

// MARK: - ### 6. 参数名称缩写（Shorthand Argument Names）

//Swift 自动为内联闭包提供了参数名称缩写功能，您可以直接通过`$0，$1，$2`来顺序调用闭包的参数，以此类推。

//如果您在闭包表达式中使用参数名称缩写，您可以在闭包参数列表中省略对其的定义，并且对应参数名称缩写的类型会通过函数类型进行推断。in关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构成：
reversed = names.sort({ $0 > $1 })

// MARK: - ### 7. 运算符函数（Operator Functions）

//Swift 的String类型定义了关于大于号（>）的字符串实现，其作为一个函数接受两个String类型的参数并返回Bool类型的值。因此，您可以简单地传递一个大于号，
reversed = names.sort( > )

// MARK: - ## 尾随闭包（Trailing Closures）

//如果需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性。尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用：
reversed = names.sort() { $0 > $1 }

//如果函数只需要闭包表达式一个参数，当您使用尾随闭包时，您甚至可以把()省略掉：
reversed = names.sort { $0 > $1 }

// MARK: - ## 捕获值（Capturing Values）

//闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。

//>注意
//为了优化，如果一个值是不可变的，Swift 可能会改为捕获并保存一份对值的拷贝。

//Swift 也会负责被捕获变量的所有内存管理工作，包括释放不再需要的变量。

func makeIncrementor(forIncrement amout: Int) -> () -> Int {
    var runningTotal = 0
    
    func incrementor() -> Int {
        //从外围函数捕获了runningTotal和amount变量的引用。捕获引用保证了runningTotal和amount变量在调用完makeIncrementer后不会消失，并且保证了在下一次执行incrementer函数时，runningTotal依旧存在。
        runningTotal += amout
        return runningTotal
    }
    return incrementor
}

let incrementByTen = makeIncrementor(forIncrement: 10)
incrementByTen()// 返回的值为10
incrementByTen()// 返回的值为20

//如果您创建了另一个incrementor，它会有属于它自己的一个全新、独立的runningTotal变量的引用：
let incrementBySeven = makeIncrementor(forIncrement: 7)
incrementBySeven() // 返回的值为7

//再次调用原来的incrementByTen会在原来的变量runningTotal上继续增加值，该变量和incrementBySeven中捕获的变量没有任何联系：
incrementByTen()// 返回的值为30


// MARK: - ## 闭包是引用类型（Closures Are Reference Types）

//上面的例子中，incrementBySeven和incrementByTen是常量，但是这些常量指向的闭包仍然可以增加其捕获的变量的值。这是因为函数和闭包都是引用类型。

//无论您将函数或闭包赋值给一个常量还是变量，您实际上都是将常量或变量的值设置为对应函数或闭包的引用。上面的例子中，指向闭包的引用incrementByTen是一个常量，而并非闭包内容本身。
//这也意味着如果您将闭包赋值给了两个不同的常量或变量，两个值都会指向同一个闭包：
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()// 返回的值为40

// MARK: - ## 非逃逸闭包(Nonescaping Closures)

//当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。
//当你定义接受闭包作为参数的函数时，你可以在参数名之前标注@noescape，用来指明这个闭包是不允许“逃逸”出这个函数的。
//将闭包标注@noescape能使编译器知道这个闭包的生命周期（译者注：闭包只能在函数体中被执行，不能脱离函数体执行，所以编译器明确知道运行时的上下文），从而可以进行一些比较激进的优化。
func someFuntionWithNoEscapeClosue(@noescape closure: () -> Void) {
    closure()
}

//一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中。
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: () -> Void) {
    completionHandlers.append(completionHandler)
}

//将闭包标注为@noescape使你能在闭包中隐式地引用self。
class SomeClass {
    var x = 10
    func doSomeThing() {
        someFunctionWithEscapingClosure {
            //这里必须用self.变量名 才能访问属性
            self.x = 100
        }
        
        someFuntionWithNoEscapeClosue {
            //这里可以直接使用变量名访问,做了优化
            x = 200
        }
    }
}
let instance = SomeClass()
instance.doSomeThing()
print(instance.x)//200

completionHandlers.first?()
print(instance.x)//100

// MARK: - ## 自动闭包（Autoclosures）

//自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够用一个普通的表达式来代替显式的闭包，从而省略闭包的花括号。

//自动闭包让你能够延迟求值，因为代码段不会被执行直到你调用这个闭包。延迟求值对于那些有副作用（Side Effect）和代价昂贵的代码来说是很有益处的，因为你能控制代码什么时候执行。下面的代码展示了闭包如何延时求值。

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

//customerProvider的类型是() -> String，一个没有参数且返回值为String的函数。
let customerProvider =  {
    customersInLine.removeFirst()
    print(customersInLine.count)
}
print(customersInLine.count)

print("Now serving \(customerProvider())!")

//将闭包作为参数传递给函数时，你能获得同样的延时求值行为。
func serveCustomer(customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serveCustomer( { customersInLine.removeAtIndex(0) } )

//@autoclosure特性, 自动转化为一个闭包
func serverCustomer(@autoclosure customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}

//可以将该函数当做接受String类型参数的函数来调用。customerProvider参数将自动转化为一个闭包
serverCustomer(customersInLine.removeFirst())

//@autoclosure特性暗含了@noescape特性，如果你想让这个闭包可以“逃逸”，则应该使用@autoclosure(escaping)特性.

var customerProviders: [() -> String] = []
func collectCustomerProviders(@autoclosure(escaping) customerProvider: () -> String) {
    customerProviders.append(customerProvider)
}


