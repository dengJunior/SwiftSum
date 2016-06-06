//
//  FuncProgramingDemo.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/8/6.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import UIKit

class FuncProgramingDemo: UIViewController {
    
    // MARK: - 函数式编程demo
    /**
    *  以下面一个假设为例子,假设您性别男，爱好女。有位优雅的女士愿意与您做爱，不过这位女士对做爱有些要求：
    前戏至少要15分钟，性交要求在3到5分钟之间，最后要抱抱30分钟，说些情话。
    */
    
    func normalDemo1(foreplayMinutes:Int, sexualIntercourseMinutes:Int, hugMinutes:Int, smallTalk:Bool) {
        
        // MARK: - 用程序来描述上面的过程，大概如下：
        if foreplayMinutes >= 15 {
            if sexualIntercourseMinutes >= 3 && sexualIntercourseMinutes <= 5 {
                if hugMinutes >= 30 && smallTalk {
                    print("Satisfied!", terminator: "")
                }
            } else {
                print("Not satisfied!", terminator: "")
            }
        } else {
            print("Not satisfied!", terminator: "")
        }
        
        
        // MARK: - 将独立的部分抽象成函数后如下
        if foreplay(foreplayMinutes) {
            if sexualIntercourse(sexualIntercourseMinutes) {
                if hug(hugMinutes, smallTalk: smallTalk) {
                    print("Satisfied!", terminator: "")
                } else {
                    print("Not satisfied!", terminator: "")
                }
            } else {
                print("Not satisfied!", terminator: "")
            }
        } else {
            print("Not satisfied!", terminator: "")
        }
    }
    
    // MARK: - 抽象的函数
    //因为要按照女士的要求，所以这三个子过程的顺序并不能颠倒，但目前这三个函数并没有体现出顺序。
    func foreplay(minutes: Int) -> Bool {
        return minutes >= 15 ? true : false
    }
    
    func sexualIntercourse(minutes: Int) -> Bool {
        return (minutes >= 3 && minutes <= 5) ? true : false
    }
    
    func hug(minutes: Int, smallTalk: Bool) -> Bool {
        return ((minutes >= 30) ? true : false) && smallTalk
    }
    
    
    // MARK: - 上面做的就是所谓的“编程”，那什么是“函数式编程”？
    
    /**
    *  先来分析一下最上面的过程：
    
    1.首先我们定义了一些输入，如foreplayMinutes等；
    2.然后我们（主要是您）先执行 foreplay，当这个过程符合要求后才进行下一步；
    3.若三个子过程都满足要求，女士才会满足，中间某个过程一旦不满足，那就不可能满足了。
    
    再简化一点说，即：有输入，过程有顺序，过程可能有输出。那什么是“函数式编程”？
    */
    
    
    //下面修改函数，为它们增加参数：为了能适用于bind，函数的返回值也变为可选了。
    func foreplay1(minutes: Int) -> Bool? {
        return minutes >= 15 ? true : false
    }
    
    func sexualIntercourse1(foreplaySatisfied: Bool, minutes: Int) -> Bool? {
        if foreplaySatisfied {
            return (minutes >= 3 && minutes <= 5) ? true : false
        } else {
            return nil
        }
    }
    
    func hug1(sexualIntercourseSatisfied: Bool, minutes: Int, smallTalk: Bool) -> Bool? {
        if sexualIntercourseSatisfied {
            return (minutes >= 30 ? true : false) && smallTalk
        } else {
            return nil
        }
    }
    
    func funcDemo(foreplayMinutes:Int, sexualIntercourseMinutes:Int, hugMinutes:Int, smallTalk:Bool) {
        
        // MARK: - 怎么用bind来描述上面的过程呢？
        var satisfied: Bool = false
        /**
        *  可惜我们不能这么写，因为函数sexualIntercourse和hug都不只接受一个参数，无法适用于bind。
        satisfied = bind(foreplayMinutes, foreplay1) ?? false
        satisfied = bind(satisfied, sexualIntercourse1) ?? false //错误
        satisfied = bind(satisfied, hug1) ?? false               //错误
        */
        
        satisfied = bind(foreplayMinutes, f: foreplay1) ?? false
        
        //之后，我们就能使用这两个柯里化函数了：
        satisfied = bind(satisfied, f: sexualIntercourse(sexualIntercourseMinutes)) ?? false
        satisfied = bind(satisfied, f: hug(hugMinutes)(smallTalk: smallTalk)) ?? false
        
        //此时，我们用bind将我们的过程顺序链接起来了。不过bind的语法依然让人困惑，我们可以增加一个中缀操作符：
        
        if satisfied {
            print("Satisfied!", terminator: "")
        } else {
            print("Not satisfied!", terminator: "")
        }
        
        // MARK: - 最终版，变成一条链了，顺序非常清楚。
        _ = foreplay(foreplayMinutes) >>> sexualIntercourse(sexualIntercourseMinutes) >>> hug(hugMinutes)(smallTalk: smallTalk) ?? false
        
    }
    
    // MARK: - 使用柯里化（Currying）技术改造我们的函数。
    /**
    *  我们可以使用柯里化（Currying）技术改造我们的函数。
    */
    func sexualIntercourse(minutes: Int)(foreplaySatisfied: Bool) -> Bool? {
        if foreplaySatisfied {
            return (minutes >= 3 && minutes <= 5) ? true : false
        } else {
            return nil
        }
    }
    
    func hug(minutes: Int)(smallTalk: Bool)(sexualIntercourseSatisfied: Bool) -> Bool? {
        if sexualIntercourseSatisfied {
            return (minutes >= 30 ? true : false) && smallTalk
        } else {
            return nil
        }
    }
    
}

/**
*  其实函数式编程的是一种更高层的抽象（类似于我们将“过程”抽象成“函数”）：
我们假设有个“高阶函数”，它能接受任意数据和一个函数（利用范型），并返回经过此函数处理的数据。我们命名此函数为bind：
*/
func bind<A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x);
    } else {
        return nil;
    }
}

//bind的语法依然让人困惑，我们可以增加一个中缀操作符：
infix operator >>> { associativity left precedence 160 }

func >>><A, B>(a: A?, f: A -> B?) -> B? {
    return bind(a, f: f)
}



// MARK: - 柯里化（Currying）函数。

/*
柯里化（Currying），又称部分求值（Partial Evaluation），是一种函数式编程思想，
就是把接受多个参数的函数转换成接收一个单一参数（最初函数的第一个参数，Swift的实现并不限定为第一个）的函数，并且返回一个接受余下参数的新函数技术。

*/
class Currying
{
    // uncurried:普通函数
    // 接收多个参数的函数
    func add(a: Int, b: Int, c: Int) -> Int{
        print("\(a) + \(b) + \(c)")
        return a + b + c
    }
    
    /*** 手动实现柯里化函数 ***/
    // 把上面的函数转换为柯里化函数，首先转成接收第一个参数a，并且返回接收余下第一个参数b的新函数（采用闭包）
    // 为了让大家都能看懂,我帮你们拆解来看下
    // (a: Int) : 参数
    // (b:Int) -> (c: Int) -> Int : 函数返回值（一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数)
    
    // 定义一个接收参数a,并且返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    func add(a: Int) -> (b:Int) -> (c: Int) -> Int{
        
        // 一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
        return { (b:Int) -> (c: Int) -> Int in
            
            // 返回一个接收余下第一个参数c，并且有返回结果为Int类型的函数
            return { (c: Int) -> Int in
                
                return a + b + c;
                
                /**
                注解： 这里为什么能使用参数a,b,c?
                利用闭包的值捕获特性，即使这些值作用域不在了，也可以捕获到他们的值。
                闭包会自动判断捕获的值是值拷贝还是值引用，如果修改了，就是值引用，否则值拷贝。
                
                注意只有在闭包中才可以，a,b,c都在闭包中。
                */
                
            }
            
        }
        
    }
    
    // curried:柯里化函数
    // 柯里化函数,Swift中已经支持这样的语法了，可以直接写
    func addCur(a: Int)(b: Int)(c: Int) -> Int{
        print("\(a) + \(b) + \(c)")
        return a + b + c
    }
    
    
    
    
    
    // 方法类型: () -> Void
    func function(){
        
        print(#function)
    }
    // 方法类型: (Int) -> Void
    func functionParam(a: Int){
        print(#function)
    }
    // 方法类型: (Int, b: Int) -> Void
    func functionParam(a: Int, b: Int){
        print(#function)
    }
    
    // 方法类型: (Int) -> () -> Void
    func functionCur(a: Int)(){
        print(#function)
    }
}

// MARK: - 柯里化（Currying）函数使用。

func CurryingDemo() {
    // 创建柯里化类的实例
    let curryInstance = Currying()
    
    /*** 调用手动实现的柯里化函数 **/
    let r: Int = curryInstance.add(10)(b: 20)(c: 30)
    // 可能很多人都是第一次看这样的调用，感觉有点不可思议。
    // 让我们回顾下OC创建对象 [[Person alloc] init]，这种写法应该都见过吧，就是一下发送了两个消息，alloc返回一个实例，再用实例调用init初始化,上面也是一样，一下调用多个函数，每次调用都会返回一个函数，然后再次调用这个返回的函数。
    
    /***** 柯里化函数分解调用 *****/
    // 让我来帮你们拆解下，更容易看懂
    // curryInstance.add(10): 调用一个接收参数a,并且返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    // functionB: 一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    let functionB = curryInstance.addCur(10)
    
    // functionB(b: 20):调用一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    // functionC: 一个接收参数c,返回值为Int类型的函数
    let functionC = functionB(b: 20)
    
    // functionC(c: 30): 调用一个接收参数c,返回值为Int类型的函数
    // result: 函数的返回值
    var res: Int = functionC(c: 30);
    
    // 这里会有疑问?，为什么不是调用curryInstance.add(a: 10)，而是curryInstance.add(10),functionB(b: 20),functionC(c: 30),怎么就有b,c,这是因为func add(a: Int) -> (b:Int) -> (c: Int) -> Int这个方法中a是第一个参数，默认是没有外部参数名，只有余下的参数才有外部参数名,b,c都属于余下的参数。
    
    /***** 系统的柯里化函数调用 *****/
    let result: Int = curryInstance.addCur(10)(b: 20)(c: 30)
    
    /***** 系统的柯里化函数拆解调用 *****/
    // 注意：Swift是强类型语言，这里没有报错，说明调用系统柯里化函数返回的类型和手动的functionB类型一致
    
    // curryInstance.addCur(10) : 调用一个接收参数a,并且返回一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    // functionB: 一个接收参数b的函数,并且这个函数又返回一个接收参数c,返回值为Int类型的函数
    let funcB = curryInstance.addCur(10)
    
    // functionC: 一个接收参数c,返回值为Int类型的函数
    let funcC = funcB(b: 20)
    
    // result: 函数的返回值
    res = funcC(c: 30)
    
    // 打印 60，60，60说明手动实现的柯里化函数，和系统的一样。
    print("\(r),\(res),\(result)")
    
    
    // MARK: - 柯里化函数使用注意
    
    //1. 必须按照参数的定义顺序来调用柯里化函数,否则就会报错。
    //var resultt: Int = curryInstance.addCur(10)(c: 20)(b: 30)
    
    //2.柯里化函数的函数体只会执行一次，只会在调用完最后一个参数的时候执行柯里化函数体。以下调用functionC(c: 30)才会执行函数体。
    
    // 不会执行柯里化函数体
    let functionBb = curryInstance.addCur(10)
    
    // 不会执行柯里化函数体
    let functionCc = functionBb(b: 20)
    
    // 执行柯里化函数体
    res = functionCc(c: 30)
    
    
    //Swift中实例方法就是一个柯里化函数
    
    /*
    如何获取实例方法?可以直接通过类获取实例方法.
    
    注意:方法是什么类型,就返回什么类型的函数，不过需要传入一个参数（类实例）才能获取到,如果方法中有外部参数名，外部参数名也属于类型的一部分
    */
    
    let instance = Currying()
    
    // MARK: - Swift中实例方法的另一种调用方式(柯里化调用)
    // 调用function方法
    Currying.function(instance)()
    
    // 拆解调用function方法
    // 1.获取function方法
    let function = Currying.function(curryInstance)
    // 2.调用function方法
    function()
    
    //注解： 步骤都是一样，首先获取实例方法，在调用实例方法

}

// MARK: - 柯里化函数有什么好处?为什么要使用它?

/**
*  柯里化函数有什么好处?为什么要使用它?
这里就需要了解函数式编程思想了，推荐看这篇文章函数式编程初探

特点：

1.只用“表达式”(表达式:单纯的运算过程，总是有返回值)，不用“语句”(语句:执行某种操作，没有返回值)。2.不修改值，只返回新值。

好处：

1.代码简洁

2.提高代码复用性

3.代码管理方便，相互之间不依赖，每个函数都是一个独立的模块，很容易进行单元测试。

4.易于“并发编程”,因为不修改变量的值，都是返回新值。

柯里化函数就是运用了函数式编程思想，因此它也有以上的好处。

在iOS开发中如何运用柯里化函数（实用性）
实用性一：复用性

需求1:地图类产品，很多界面都有相同的功能模块，比如搜索框。

我们可以利用柯里化函数，来组装界面，把界面分成一个个小模块，这样其他界面有相同的模块，直接运用模块代码，去重新组装下就好了。

实用性二：延迟性，柯里化函数代码需要前面的方法调用完成之后，才会来到柯里化函数代码中。

需求2:阅读类产品，一个界面的显示，依赖于数据，需要加载完数据之后，才能判断界面显示。
这时候也可以利用柯里化函数，来组装界面，把各个模块加载数据的方法抽出来，等全部加载完成，在去执行柯里化函数，柯里化函数主要实现界面的组装。

举例说明:

*/

// 组合接口
// 为什么要定义接口，为了程序的扩展性，以后只需要在接口中添加对应的组合方法就好了。
protocol CombineUI
{
    func combine(top: () -> ())(bottom: () -> ())()
}

// 定义一个界面类，遵守组合接口
class UI: CombineUI
{
    func combine(top: () -> ())(bottom: () -> ())() {
        // 搭建顶部
        top()
        
        // 搭建底部
        bottom()
    }
}


