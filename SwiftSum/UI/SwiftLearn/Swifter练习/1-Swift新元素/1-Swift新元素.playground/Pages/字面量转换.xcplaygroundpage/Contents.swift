//: [Previous](@previous)

import Foundation

//“所谓字面量，就是指像特定的数字，字符串或者是布尔值这样，能够直截了当地指出自己的类型并为变量进行赋值的值。比如在下面：

let a = 3
let s = "hello"

//Array 和 Dictionary 在使用简单的描述赋值的时候，使用的也是字面量，比如：”

let arr = [1,3]
let dict = ["key": "value"]

//“Swift 为我们提供了一组非常有意思的接口，用来将字面量转换为特定的类型。对于那些实现了字面量转换接口的类型，在提供字面量赋值的时候，就可以简单地按照接口方法中定义的规则“无缝对应”地通过赋值的方式将值转换为对应类型。这些接口包括了各个原生的字面量，在实际开发中我们经常可能用到的有：

/*
 ArrayLiteralConvertible
 BooleanLiteralConvertible
 DictionaryLiteralConvertible
 FloatLiteralConvertible
 NilLiteralConvertible
 IntegerLiteralConvertible
 StringLiteralConvertible
 
 所有的字面量转换接口都定义了一个 typealias 和对应的 init 方法。拿 BooleanLiteralConvertible 举个例子：
 */

//BooleanLiteralConvertible定义如下
protocol BooleanLiteralConvertible2 {
    associatedtype BooleanLiteralType
    
    init(booleanLiteral value: BooleanLiteralType)
}

//于是在我们需要自己实现一个字面量转换的时候，可以简单地只实现定义的 init 方法就行了。举个不太有实际意义的例子，比如我们想实现一个自己的 Bool 类型，可以这么做：”
enum MyBool: Int {
    case myTrue, myFalse
}

extension MyBool: BooleanLiteralConvertible {
    init(booleanLiteral value: Bool) {
        self = value ? .myTrue : .myFalse
    }
}

//这里就能自己用字面量给MyBool赋值了
let myTrue: MyBool = true

// MARK: - StringLiteralConvertible

/**
StringLiteralConvertible这个接口本身还要求实现下面两个接口：
 
 ExtendedGraphemeClusterLiteralConvertible
 UnicodeScalarLiteralConvertible
 
 这两个接口我们在日常项目中基本上不会使用，它们对应字符簇和字符的字面量转换。虽然复杂一些，但是形式上还是一致的，只不过在实现 StringLiteralConvertible 时我们需要将这三个 init 方法都进行实现。
 
 还是以例子来说明，比如我们有个 Person 类，里面有这个人的名字：”
 */
class Person: StringLiteralConvertible {
    let name: String
    init(name value: String) {
        self.name = value
    }
    
    //“在所有的接口定义的 init 前面我们都加上了 required 关键字，这是由初始化方法的完备性需求所决定的，这个类的子类都需要保证能够做类似的字面量转换，以确保类型安全”
    
    //所以不能通过扩展方式 实现该协议，“因为在 extension 中，我们是不能定义 required 的初始化方法的。也就是说，我们无法为现有的非 final 的 class 添加字面量转换 (不过也许这在今后的 Swift 版本中能有所改善)。”
    
    required convenience init(stringLiteral value: String) {
        self.init(name: value)
    }
    
    required convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
    
    convenience required init(unicodeScalarLiteral value: String) {
        self.init(name: value)
    }
}

let per: Person = "haha"
print(per.name)





//: [Next](@next)
