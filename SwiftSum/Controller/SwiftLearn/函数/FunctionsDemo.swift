//
//  FunctionsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/9.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit



class FunctionsDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func functionsDemo() {
        print(sayHello("Anna"))
        sayHello2("peter")
        
        //注意： 如果你提供了外部参数名，那么函数在被调用时，必须使用外部参数名。
        join1(string: "hello", withString: " world")
        
        //这里在调用时,不能加局部参数名,s1或s2。
        join2("111", "world2")
        
        join(string: "hello", toString:"world")
        
        sum(2,2,2,2,5)
        
        //对变量参数所进行的修改在函数调用结束后便消失了，并且对于函数体外是不可见的。
        let five = 5
        add(1, outVal: five)
        print(five) //还是5
        
        var someInt = 3
        var another = 100
        //someInt 和 anotherInt 在传入 swapTwoInts 函数前，都加了 & 的前缀：
        swapInts(&someInt, second: &another)
        
        let addFun:(Int, Int) ->Int = addTwoInts
        addFun(2, 3)    //不用外部参数名
        addTwoInts(2, b: 3)    //必须加外部参数名,注意区别
        
        
        let addFun2 = addTwoInts
        let addFun3:addFunType = addTwoInts
        
        addFun2(3, b: 4)     //必须加外部参数名,注意区别
        addFun3(4, 5)       //不用外部参数名
        
        
        addThree(3, b: addFun)
        addThree2(3, b: addTwoInts)
        
        
        var currentVal = 3
        
        //你现在可以用 chooseStepFunction 来获得一个函数，不管是那个方向：
        let moveNearerToZero = chooseStepFunction(currentVal > 0)
        
        while currentVal != 0 {
            print("\(currentVal)... ")
            currentVal = moveNearerToZero(currentVal)
        }
        // 3...
        // 2...
        // 1...
    }
    
    func sayHello(personName:String) ->String {
        return "Hello again, " + personName + "!"
    }
    
    /**
     *  因为这个函数不需要返回值，所以这个函数的定义中没有返回箭头（->）和返回类型。
     
     注意： 严格上来说，虽然没有返回值被定义，sayGoodbye 函数依然返回了值。
     没有定义返回类型的函数会返回特殊的值，叫 Void。它其实是一个空的元组（tuple），typealias Void = ()
     */
    func sayGoodbye(personName: String) {
        print("Goodbye, \(personName)!")
    }
    
    // MARK: - 多重返回值函数,元组（tuple)
    func sayHello2(personName:String) ->(str:String, code:Int) {
        return (personName, 1)
    }
    

    // MARK: - 外部参数名（External Parameter Names）
    //func someFunction(externalParameterName localParameterName: Int)
    //你可以在局部参数名前指定外部参数名，中间以空格分隔：
    func join1(string s1:String, withString s2:String) ->String{
        return s1+s2
    }
    
    /**
     忽略外部参数名（Omitting External Parameter Names）
     如果你不想为第二个及后续的参数设置外部参数名，用一个下划线（_）代替一个明确的参数名。
     
     因为第一个参数默认忽略其外部参数名称，显式地写下划线是多余的。
     */
    func join2(s1:String, _ s2:String) ->String{
        return s1+s2
    }
    
    // MARK: -默认参数值（Default Parameter Values）,类似c++
    /**
    可以在函数体中为每个参数定义默认值（Deafult Values）。当默认值被定义后，调用这个函数时可以忽略这个参数。
    
    将带有默认值的参数放在函数参数列表的最后。这样可以保证在函数调用时，非默认参数的顺序是一致的，同时使得相同的函数在不同情况下调用时显得更为清晰。
    */
    func join(string s1: String, toString s2: String, withJoiner joiner: String = " ") -> String {
        return s1 + joiner + s2
    }
    
    // MARK: - 可变参数（Variadic Parameters）必须在最后
    //一个函数最多只能有一个可变参数。
    func sum(numbers: Double...) ->Double {
        var total = 0.0
        for number in numbers {
            total += number
        }
        return total
    }
    
    // MARK: - 常量参数和变量参数（Constant and Variable Parameters）
    /**
    函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误。
    可以通过指定一个或多个参数为变量参数，从而避免自己在函数中定义新的变量。
    通过在参数名前加关键字 var 来定义变量参数：
    
    
    注意
    对变量参数所进行的修改在函数调用结束后便消失了，并且对于函数体外是不可见的。
    变量参数仅仅存在于函数调用的生命周期中。
    */
    func add(num:Int, var outVal:Int) ->Int {
        //num += out    error
        outVal += num
        return outVal;
    }
    
    
    // MARK: - 输入输出参数（In-Out Parameters）
    /**
    *  变量参数，正如上面所述，仅仅能在函数体内被更改。
    如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，
    那么就应该把这个参数定义为输入输出参数（In-Out Parameters）。
    c++的引用?
    
    你只能传递变量给输入输出参数。你不能传入常量或者字面量（literal value），因为这些量是不能被修改的。
    当传入的参数作为输入输出参数时，需要在参数名前加&符，表示这个值可以被函数修改。
    */
    func swapInts(inout first:Int, inout second:Int) {
        let temp = second
        second = first
        first = temp
    }
    
    
    // MARK: - 函数类型（Function Types）
    /**
    每个函数都有种特定的函数类型，由函数的参数类型和返回类型组成。
    *  在 Swift 中，使用函数类型就像使用其他类型一样。例如，你可以定义一个类型为函数的常量或变量，并将函数赋值给它：
    函数指针.
    */
    
    func addTwoInts(a: Int, b: Int) -> Int {
        return a + b
    }
    
    // MARK: -  typealias 与函数
    
    typealias addFunType = (Int, Int) ->Int
    
    //函数类型作为参数类型
    func addThree(a:Int, b:(Int, Int) ->Int) ->Int{
        return b(a, 3)
    }
    
    
    func addThree2(a:Int, b:addFunType) ->Int{
        return b(a, 3)
    }
    
    // MARK: - 函数类型作为返回类型（Function Type as Return Types）
    
    func stepForward(input: Int) -> Int {
        return input + 1
    }
    func stepBackward(input: Int) -> Int {
        return input - 1
    }
    
    func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
        return backwards ? stepBackward : stepForward
    }
    
    // MARK: - 嵌套函数（Nested Functions）
    /**
    *  上面所见到的所有函数都叫全局函数（global functions），它们定义在全局域中。
    也可以把函数定义在别的函数体中，称作嵌套函数（nested functions）。
    */
    
    /**
    * 默认情况下，嵌套函数是对外界不可见的，但是可以被它们的外围函数（enclosing function）调用。
    一个外围函数也可以返回它的某一个嵌套函数，使得这个函数可以在其他域中被使用。
    */
    
    //你可以用返回嵌套函数的方式重写 chooseStepFunction 函数：
    func chooseStepFunction2(backwards:Bool) -> (Int)->Int {
        func stepForward(input: Int) -> Int { return input + 1 }
        func stepBackward(input: Int) -> Int { return input - 1 }
        return backwards ? stepBackward : stepForward
    }

}
