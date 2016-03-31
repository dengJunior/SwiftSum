//
//  ClosuresDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/9.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class ClosuresDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - 闭包
    /**
    闭包就是一个函数，或者一个指向函数的指针，加上这个函数执行的非局部变量。
    闭包是自包含的函数代码块，可以在代码中被传递和使用。
    
    闭包可以捕获和存储其所在上下文中任意常量和变量的引用。
    这就是所谓的闭合并包裹着这些常量和变量，俗称闭包。
    
    Swift 会为您管理在捕获过程中涉及到的所有内存操作。
    */

    /**
    *  在函数 章节中介绍的全局和嵌套函数实际上也是特殊的闭包，闭包采取如下三种形式之一：
    
    1. 全局函数是一个有名字但不会捕获任何值的闭包
    2. 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
    3. 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包
    */
    
    // MARK: - sort 方法（The Sort Method）
    /**
    *  根据您提供的用于排序的闭包函数将已知类型数组中的值进行排序。
    返回一个与原数组大小相同,包含同类型元素且元素已正确排序的新数组。
    原数组不会被sort(_:)方法修改。
    */
    
    // MARK: - 闭包函数
    func closuresDemo() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        var reversed = names.sort(backwards);
        // reversed 为 ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
        
        // MARK: - 闭包表达式语法（Closure Expression Syntax）
        /**
        *  闭包表达式语法有如下一般形式：
        
        { (parameters) -> returnType in
        statements
        }
        */
        //上面的简化版
        reversed = names.sort({ (s1: String, s2: String) -> Bool in
            return s1 > s2
        })
        
        //尾随闭包写法1
        reversed = names.sort() {
            (s1: String, s2: String) ->Bool in
                return s1 > s2
        }
        
        //尾随闭包写法2
        reversed = names.sort {
            (s1: String, s2: String) ->Bool in
            return s1 > s2
        }
        
        // MARK: - 根据上下文推断类型（Inferring Type From Context）
        /**
        *  因为排序闭包函数是作为sorted函数的参数进行传入的，Swift可以推断其参数和返回值的类型。
        sorted期望参数是类型为(String, String) -> Bool的函数，
        因此实际上String,String和Bool类型并不需要作为闭包表达式定义中的一部分。
        因为所有的类型都可以被正确推断，返回箭头 (->) 和围绕在参数周围的括号也可以被省略：
        */
        reversed = names.sort({s1, s2 in return s1 > s2})
        
        // MARK: - 单表达式闭包隐式返回（Implicit Return From Single-Expression Clossures）
        /*
        单行表达式闭包可以通过隐藏return关键字来隐式返回单行表达式的结果，如上版本的例子可以改写为：
        */
        reversed = names.sort({s1, s2 in s1 > s2})
        
        // MARK: - 参数名称缩写（Shorthand Argument Names）
        //Swift 自动为内联函数提供了参数名称缩写功能，
        //可以直接通过$0,$1,$2来顺序调用闭包的参数。in关键字也同样可以被省略
        //此时闭包表达式完全由闭包函数体构成：
        reversed = names.sort( {$0 > $1} )
        
        // MARK: - 运算符函数（Operator Functions）
        /**
        *  Swift 的String类型定义了关于大于号 (>) 的字符串实现，其作为一个函数接受两个String类型的参数并返回Bool类型的值。
        而这正好与sorted函数的第二个参数需要的函数类型相符合。
        */
        reversed = names.sort(>)//碉堡了..
        print(reversed);
        
        
        let incrementByTen = makeIncrementor(forIncrement: 10)
        incrementByTen()
        // 返回的值为10
        incrementByTen()
        // 返回的值为20
        incrementByTen()
        // 返回的值为30
        
        //如果您创建了另一个incrementor，它会有属于它自己的一个全新、独立的runningTotal变量的引用：
        let incrementBySeven = makeIncrementor(forIncrement: 7)
        incrementBySeven()
        // 返回的值为7
        
        
        //再次调用原来的incrementByTen会在原来的变量runningTotal上继续增加值，该变量和incrementBySeven中捕获的变量没有任何联系：
        incrementByTen()
        // 返回的值为40
        
        // MARK: - 闭包是引用类型（Closures Are Reference Types）
        /**
        *  上面的例子中，incrementBySeven和incrementByTen是常量，但是这些常量指向的闭包仍然可以增加其捕获的变量值。
        这是因为函数和闭包都是引用类型。
        */
        
        /**
        *  无论您将函数/闭包赋值给一个常量还是变量，您实际上都是将常量/变量的值设置为对应函数/闭包的引用。
        上面的例子中，incrementByTen指向闭包的引用是一个常量，而并非闭包内容本身。
        */
        
        //将闭包赋值给了两个不同的常量/变量，两个值都会指向同一个闭包：
        let alsoIncrementByTen = incrementByTen
        alsoIncrementByTen()    //50
    }
    
    func backwards(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    
    // MARK: - 尾随闭包（Trailing Closures）
    //如果您需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性。如下:
    /**
    *  func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数体部分
    }
    
    // 以下是不使用尾随闭包进行函数调用
    someFunctionThatTakesAClosure({
    // 闭包主体部分
    })
    
    // 以下是使用尾随闭包进行函数调用
    someFunctionThatTakesAClosure() {
    // 闭包主体部分
    }
    */
    
    
    // MARK: - 捕获值（Capturing Values）
    //闭包可以在其定义的上下文中捕获常量或变量。 即使定义这些常量和变量的原域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。
    func makeIncrementor(forIncrement amout:Int) -> ()->Int {
        var runingTotal = 0;
        
        //incrementor函数并没有获取任何参数，通过捕获在包含它的函数体内已经存在的runningTotal和amount变量
        func incrementor() -> Int {
            
            /**
            *  incrementor捕获了当前runningTotal变量的引用，而不是仅仅复制该变量的初始值。
            捕获一个引用保证了当makeIncrementor结束时候并不会消失，
            也保证了当下一次执行incrementor函数时，runningTotal可以继续增加。
            */
            runingTotal += amout
            return runingTotal
        }
        
        /**
        *  注意： Swift 会决定捕获引用还是拷贝值。
        您不需要标注amount或者runningTotal来声明在嵌入的incrementor函数中的使用方式。
        Swift 同时也处理runingTotal变量的内存管理操作，如果不再被incrementor函数使用，则会被清除。
        */
        return incrementor
    }
    
    
    // MARK: - 非逃逸闭包(Nonescaping Closures)
    /**
    *  当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。
    当你定义接受闭包作为参数的函数时，你可以在参数名之前标注@noescape，用来指明这个闭包是不允许“逃逸”出这个函数的。
    
    将闭包标注@noescape能使编译器知道这个闭包的生命周期,从而可以进行一些比较激进的优化。
    */
    func someFunctionWithNoescapeClosure(@noescape closure: ()->Bool) {
        closure()
    }
    
    
    /*一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中。
    
    很多启动异步操作的函数接受一个闭包参数作为 completion handler。
    这类函数会在异步操作开始之后立刻返回，但是闭包直到异步操作结束后才会被调用。
    在这种情况下，闭包需要“逃逸”出函数，因为闭包需要在函数返回之后被调用。例如：
    */
    var completionHandlers: [() -> Void] = []
    func someFunctionWithEscapingClosure(completionHandler: () -> Void) {
        completionHandlers.append(completionHandler)
    }
    
    // MARK: - 将闭包标注为@noescape使你能在闭包中隐式地引用self。
    class SomeClass {
        var x = 10
        func doSomething() {
//            someFunctionWithEscapingClosure { self.x = 100 }
//            someFunctionWithNoescapeClosure { x = 200 }
        }
    }
    
    /**
    *  let instance = SomeClass()
    instance.doSomething()
    print(instance.x)
    // prints "200"
    
    completionHandlers.first?()
    print(instance.x)
    // prints "100"
    */
    
    
    // MARK: - 自动闭包（Autoclosures）
    /**
    *  自动闭包是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。
    这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。
    
    自动闭包让你能够延迟求值，因为代码段不会被执行直到你调用这个闭包。
    */
    func autoclosuresDemo() {
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        print(customersInLine.count)
        // prints "5"
        
        //customerProvider的类型不是String，而是() -> String，一个没有参数且返回值为String的函数。
        let customerProvider = { customersInLine.removeAtIndex(0) }
        print(customersInLine.count)
        // prints "5"
        
        print("Now serving \(customerProvider())!")
        // prints "Now serving Chris!"
        print(customersInLine.count)
        // prints "4"
        
        
        serveCustomer( { customersInLine.removeAtIndex(0) } )
        // prints "Now serving Alex!"
        
        //自动闭包语法，这里参数是一个表达式
        serveCustomer2(customersInLine.removeAtIndex(0))
    }
    
    //serveCustomer(_:)接受一个返回顾客名字的显式的闭包。
    func serveCustomer(customerProvider: () -> String) {
        print("Now serving \(customerProvider())!")
    }
    
    //customerProvider参数将自动转化为一个闭包，因为该参数被标记了@autoclosure特性。
    func serveCustomer2(@autoclosure customerProvider:()-> String) {
        print("Now serving \(customerProvider())!")
    }
    
    //@autoclosure特性暗含了@noescape特性，这个特性在非逃逸闭包一节中有描述。如果你想让这个闭包可以“逃逸”，则应该使用@autoclosure(escaping)特性.
    var customerProviders: [() -> String] = []
    func collectCustomerProviders(@autoclosure(escaping) customerProvider: () -> String) {
        customerProviders.append(customerProvider)
    }
}




