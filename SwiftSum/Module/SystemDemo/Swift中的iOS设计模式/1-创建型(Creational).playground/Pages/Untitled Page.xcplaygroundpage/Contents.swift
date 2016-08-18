//: [Previous](@previous)

import Foundation

/**
 # 创建型（Creational）
 
 - [参考链接](https://github.com/ochococo/Design-Patterns-In-Swift)
 
 In software engineering, creational design patterns are design patterns that deal with object creation mechanisms, trying to create objects in a manner suitable to the situation. The basic form of object creation could result in design problems or added complexity to the design. Creational design patterns solve this problem by somehow controlling this object creation.
 
 在软件工程中，创建型设计模式用来处理对象的创建机制，用适合情况的方式来创建对象。对象创建的基本形式可能会导致设计问题或增加设计的复杂性。创建型设计模式，通过某种方式控制该对象的创建解决这个问题。
 
 Source: [wikipedia.org](https://en.wikipedia.org/wiki/Creational_pattern)
 
 ## Abstract Factory 抽象工厂模式
 
 The abstract factory pattern is used to provide a client with a set of related or dependant objects. The "family" of objects created by the factory are determined at run-time.
 
 抽象工厂模式用来提供一个客户端和一组相关或依赖的对象。由工厂创建的对象的“家族”都在运行时确定的。
 */

// MARK: - Example

// MARK: - Protocols

protocol Decimal {
    func stringValue() -> String
    // factory
    static func make(string: String) -> Decimal
}

typealias NumberFactory = (String) -> Decimal

// Number implementations with factory methods
struct NextStepNumber: Decimal {
    
    private var nextStepNumber: NSNumber
    
    func stringValue() -> String {
        return nextStepNumber.stringValue
    }
    
    static func make(string: String) -> Decimal {
        return NextStepNumber(nextStepNumber: NSNumber(longLong: (string as NSString).longLongValue))
    }
}

struct SwiftNumber: Decimal {
    private var swiftInt: Int
    
    func stringValue() -> String {
        return "\(swiftInt)"
    }
    
    static func make(string: String) -> Decimal {
        return SwiftNumber(swiftInt: (string as NSString).integerValue)
    }
}

// MARK: - Abstract factory

enum NumberType {
    case nextStep, swift
}

enum NumberHelper {
    static func factoryFor(type: NumberType) -> NumberFactory {
        switch type {
        case .nextStep:
            return NextStepNumber.make
        case .swift:
            return SwiftNumber.make
        }
    }
}

// MARK: - Usage

let factoryOne = NumberHelper.factoryFor(.nextStep)
let numberOne = factoryOne("1")
numberOne.stringValue()

let factoryTwo = NumberHelper.factoryFor(.swift)
let numberTwo = factoryTwo("2")
numberTwo.stringValue()


/**
 工厂方法（Factory Method）
 
 Define an interface for creating an object, but let subclasses decide which class to instantiate. Factory Method lets a class defer instantiation to subclasses。
 定义一个用于创建对象的接口，让子类决定实例化哪一个类。工厂方法使一个类的实例化延迟到其子类。
 
 在工厂方法模式中，抽象产品类Product负责定义产品的共性，实现对事物最抽象定义；
 Creator为抽象创建类，也就是抽象工厂，具体如何创建产品类是由具体的实现工厂ConcreteCreator完成的。
 */

//1. 抽象产品Currency负责定义产品的共性
protocol Currency {
    func symbol() -> String
    func code() -> String
}

//2. 具体的产品Euro和UnitedStateDolar
class Euro: Currency {
    func symbol() -> String {
        return "€"
    }
    
    func code() -> String {
        return "EUR"
    }
}
class UnitedStateDolar: Currency {
    func symbol() -> String {
        return "$"
    }
    
    func code() -> String {
        return "USD"
    }
}

//3. 要创建产品需要的参数
enum Country {
    case UnitedStates, Spain, UK, Greece
}

//4. CurrencyFactory为抽象创建类，也就是抽象工厂
enum CurrencyFactory {
    //具体如何创建产品类是由具体的实现工厂currencyFor完成
    static func currencyFor(country: Country) -> Currency? {
        switch country {
        case .Spain, .Greece:
            return Euro()
        case .UnitedStates:
            return UnitedStateDolar()
        default:
            return nil
        }
    }
}

// Usage
let noCurrencyCode = "No Currency Code Available"

CurrencyFactory.currencyFor(.Greece)?.code() ?? noCurrencyCode
CurrencyFactory.currencyFor(.Spain)?.code() ?? noCurrencyCode
CurrencyFactory.currencyFor(.UnitedStates)?.code() ?? noCurrencyCode
CurrencyFactory.currencyFor(.UK)?.code() ?? noCurrencyCode

/*
 ## Builder 建造者模式
 
 The builder pattern is used to create complex objects with constituent parts that must be created in the same order or using a specific algorithm. An external class controls the construction algorithm.
 
 建造者模式用于创建与必须按相同的顺序来创建或使用特定的算法构成部件复杂的对象。外部类控制构造算法。
 
 将一个复杂对象的构建与它的表现分离，使得同样的构建过程可以创建不同的表现。
 */
class DeathStarBuilder {
    var x: Double?
    var y: Double?
    var z: Double?
    
    typealias BuilderClosure = (DeathStarBuilder) -> Void
    
    init(builderClosure: BuilderClosure) {
        builderClosure(self)
    }
}

struct DeathStar: CustomStringConvertible {
    let x: Double
    let y: Double
    let z: Double
    
    init?(builder: DeathStarBuilder) {
        if let x = builder.x, y = builder.y, z = builder.z {
            self.x = x
            self.y = y
            self.z = z
        } else {
            return nil
        }
    }
    var description:String {
        return "Death Star at (x:\(x) y:\(y) z:\(z))"
    }
}

// MARK: - Usage
let empire = DeathStarBuilder { builder in
    builder.x = 0.1
    builder.y = 0.2
    builder.z = 0.3
}
let deathStar = DeathStar(builder: empire)

/*
 Prototype 原型模式
 
 The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. This practise is particularly useful when the construction of a new object is inefficient.
 
 原型模式用于复制现有对象的所有属性，创建一个独立的克隆对象。这种模式在创建新对象的非常复杂且耗时特别有用。
 */
class ChungasRevengeDisplay {
    var name: String?
    let font: String
    
    init(font: String) {
        self.font = font
    }
    
    func clone() -> ChungasRevengeDisplay {
        return ChungasRevengeDisplay(font: font)
    }
}

// MARK: - Usage
let Prototype = ChungasRevengeDisplay(font:"GotanProject")

let Philippe = Prototype.clone()
Philippe.name = "Philippe"

let Christoph = Prototype.clone()
Christoph.name = "Christoph"


/*
 Singleton 单例模式
 
 The singleton pattern ensures that only one object of a particular class is ever created. All further references to objects of the singleton class refer to the same underlying instance. There are very few applications, do not overuse this pattern!
 
 单例模式确保只有一个特定类的对象被创建。对该类的对象所有引用引用相同的底层的实例。不要过度使用这种模式！
 */
class DeathStarSuperlaser {
    static let sharedInstance = DeathStarSuperlaser()
    
    private init() {
        // Private initialization to ensure just one instance is created.
    }
}
/*:
 ### Usage:
 */
let laser = DeathStarSuperlaser.sharedInstance











//: [Next](@next)
