//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 协议语法（Protocol Syntax）
 - 属性要求（Property Requirements）
 - 方法要求（Method Requirements）
 - Mutating 方法要求（Mutating Method Requirements）
 - 构造器要求（Initializer Requirements）
 - 协议作为类型（Protocols as Types）
 - 委托（代理）模式（Delegation）
 - 通过扩展添加协议一致性（Adding Protocol Conformance with an Extension）
 - 通过扩展采纳协议（Declaring Protocol Adoption with an Extension）
 - 协议类型的集合（Collections of Protocol Types）
 - 协议的继承（Protocol Inheritance）
 - 类类型专属协议（Class-Only Protocol）
 - 协议合成（Protocol Composition）
 - 检查协议一致性（Checking for Protocol Conformance）
 - 可选的协议要求（Optional Protocol Requirements）
 - 协议扩展（Protocol Extensions）
 
 协议定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。
 */

protocol Prot {
    // MARK: - 属性要求
    
    //用 var 关键字来声明变量属性，在类型声明后加上 { set get } 来表示属性是可读可写的
    var name: String { get set}
    
    //在协议中定义类型属性时，总是使用 static 关键字作为前缀
    static var name: String { get set}
    
    // MARK: - ## 方法要求
    
    //可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。
    func func1(num1: Int, nums: Int...) -> Int
    //func func2(num: Int = 2)  error 不支持为协议中的方法的参数提供默认值。
    
    //注意：实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写 mutating 关键字。
    mutating func func3()
    
    // MARK: - 构造器要求
    
    //1. 你可以在采纳协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。无论哪种情况，你都必须为构造器实现标上 required 修饰符：final类除外
    //2. 如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注 required 和 override 修饰符：现在不用了
    init(num: Int)
    init?(num2: Int?)
    
}

// MARK: - ## 可选的协议要求
@objc protocol Prot2 {
    func desc() -> String
    
    //使用 optional 关键字作为前缀来定义可选要求。使用可选要求时（例如，可选的方法或者属性），它们的类型会自动变成可选的。比如，一个类型为 (Int) -> String 的方法会变成 ((Int) -> String)?。需要注意的是整个函数类型是可选的，而不是函数的返回值。
    optional func desc1() -> String
    
    /**>注意
     可选的协议要求只能用在标记 @objc 特性的协议中。
     该特性表示协议将暴露给 Objective-C 代码
     
     还需要注意的是，标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类采纳，其他类以及结构体和枚举均不能采纳这种协议。

     */
}

//协议能够继承一个或多个其他协议，可以在继承的协议的基础上增加新的要求。
protocol Prot3: Prot2 {
    func desc2() -> String
}

// MARK: - ## 类类型专属协议

//通过添加 class 关键字来限制协议只能被类类型采纳，而结构体或枚举不能采纳该协议。class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前：
protocol Prot4: class, Prot2 {
    func desc4() -> String
}

class Cla1: Prot {
    var name: String = "name"
    static var name: String = "name"
    func func1(num1: Int, nums: Int...) -> Int {
        return num1
    }
    
    required init(num: Int) {
        
    }
    required init?(num2: Int?) {
        
    }
    
    @objc func desc() -> String {
        return "desc"
    }
}

//已经符合了某个协议中的所有要求，却还没有声明采纳该协议时，可以通过空扩展体的扩展来采纳该协议：,必须显式地采纳协议。
extension Cla1: Prot2 {}

extension Cla1 {
    //通过扩展采纳并符合协议，和在原始定义中采纳并符合协议的效果完全相同。
    func func3() {
        
    }
}

//>注意
//如果类已经被标记为 final，那么不需要在协议构造器的实现中使用 required 修饰符，因为 final 类不能有子类。 还是要。。
final class Cla2: Cla1, Prot3, Prot4 {
    required init(num: Int) {
        super.init(num: num)
    }
    
    required init?(num2: Int?) {
        super.init(num2: num2)
    }
    
    func desc2() -> String {
        return "desc2"
    }
    
    func desc4() -> String {
        return "ddd"
    }
}

// MARK: - ## 协议合成

//有时候需要同时采纳多个协议，你可以将多个协议采用 protocol<SomeProtocol, AnotherProtocol> 这样的格式进行组合，称为 协议合成（protocol composition）。你可以在 <> 中罗列任意多个你想要采纳的协议，以逗号分隔。
func prtocolHe(some: protocol<Prot, Prot2>) {
//    >注意
//    协议合成并不会生成新的、永久的协议类型，而是将多个协议中的要求合成到一个只在局部作用域有效的临时协议中。
}

// MARK: - ##检查协议一致性

/**
 - is 用来检查实例是否符合某个协议，若符合则返回 true，否则返回 false。
 - as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil。
 - as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
 */

// MARK: - ##协议扩展

//协议可以通过扩展来为采纳协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个采纳协议的类型中都重复同样的实现，也无需使用全局函数。

// MARK: - ### 为协议扩展添加限制条件,这里必须是Cla1类才有默认实现
extension Prot2 where Self: Cla1{
    //如果采纳协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。
    func desc1() -> String {
        return "desc1"
    }
}

/*
 >注意
 如果多个协议扩展都为同一个协议要求提供了默认实现，而采纳协议的类型又同时满足这些协议扩展的限制条件，那么将会使用限制条件最多的那个协议扩展提供的默认实现。
 */


let c1 = Cla1(num: 4)
c1.desc1()

class Cla3: Prot2 {
    @objc func desc() -> String {
        return "desc"
    }
}
let c3 = Cla3()
c3.desc()
//c3.desc1() 报错  Cla3 is not a subtype of Cla1





