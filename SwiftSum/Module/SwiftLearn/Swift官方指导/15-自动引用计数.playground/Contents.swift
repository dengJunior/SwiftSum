//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 自动引用计数的工作机制
 - 自动引用计数实践
 - 类实例之间的循环强引用
 - 解决实例之间的循环强引用
 - 闭包引起的循环强引用
 - 解决闭包引起的循环强引用
 
 Swift 使用自动引用计数（ARC）机制来跟踪和管理你的应用程序的内存。
 */

// MARK: - ## 自动引用计数的工作机制

//当你每次创建一个类的新的实例的时候，ARC 会分配一块内存来储存该实例信息。内存中会包含实例的类型信息，以及这个实例所有相关的存储型属性的值。

//为了确保使用中的实例不会被销毁，ARC 会跟踪和计算每一个实例正在被多少属性，常量和变量所引用。哪怕实例的引用数为1，ARC都不会销毁这个实例。

// MARK: - ## 解决实例之间的循环强引用

//Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：弱引用（weak reference）和无主引用（unowned reference）。

//    - 对于生命周期中会变为nil的实例使用弱引用。
//    - 对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用。

//ARC 会在引用的实例被销毁后自动将其赋值为nil。
//如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。

// MARK: - ### 无主引用以及隐式解析可选属性

//存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为nil。
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        capitalCity = City(name: name, country: self)
    }
}
class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

// MARK: - ## 闭包引起的循环强引用

//Swift 提供了一种优雅的方法来解决这个问题，称之为闭包捕获列表（closure capture list）。

/**
 lazy var someClosure: (Int, String) -> String = {
 [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
 // 这里是闭包的函数体
 }
 
 如果闭包没有指明参数列表或者返回类型，即它们会通过上下文推断，那么可以把捕获列表和关键字in放在闭包最开始的地方：
 
 lazy var someClosure: Void -> String = {
 [unowned self, weak delegate = self.delegate!] in
 // 这里是闭包的函数体
 }
 */















