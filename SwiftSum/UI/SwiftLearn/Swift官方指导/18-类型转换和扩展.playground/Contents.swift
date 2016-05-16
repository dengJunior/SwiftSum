//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 向下转型（Downcasting）
 - Any 和 AnyObject 的类型转换
 - 扩展语法
 - 计算型属性
 - 构造器
 - 方法
 - 下标
 - 嵌套类型
 
 类型转换在 Swift 中使用 is 和 as 操作符实现。
 
 你也可以用它来检查一个类型是否实现了某个协议，就像在检验协议的一致性部分讲述的一样。
 */

//类型转换在 Swift 中使用 is 和 as 操作符实现。也可以用它来检查一个类型是否实现了某个协议，

//用类型检查操作符（is）来检查一个实例是否属于特定子类型。若实例属于那个子类型，类型检查操作符返回 true，否则返回 false。

//某类型的一个常量或变量可能在幕后实际上属于一个子类。你可以尝试向下转到它的子类型，用类型转换操作符（as? 或 as!）。

//当你试图使用强制形式（as!）向下转型为一个不正确的类型时，会触发一个运行时错误。

// MARK: - ## Any 和 AnyObject 的类型转换

/**
 Swift 为不确定类型提供了两种特殊的类型别名：
 
 - AnyObject 可以表示任何类类型的实例。
 - Any 可以表示任何类型，包括函数类型。
 */


// MARK: - ## 扩展

/**
 扩展 就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。
 
 Swift 中的扩展可以：
 
 - 添加计算型属性和计算型类型属性
 - 定义实例方法和类型方法
 - 提供新的构造器
 - 定义下标
 - 定义和使用新的嵌套类型
 - 使一个已有类型符合某个协议
 */

//>注意
//扩展可以为一个类型添加新的功能，但是不能重写已有的功能。

//扩展可以添加新的计算型属性，但是不可以添加存储型属性，也不可以为已有属性添加属性观察器。
extension Double {
    //## 计算型属性（Computed Properties）
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.km//25400

// MARK: - ## 构造器（Initializers）

extension Array {
    //扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供。
//    public init(counts: Int) {
//        self.init(count: 6, repeatedValue: 0)
//    }
}

extension Int {
    //通过扩展添加的实例方法也可以修改该实例本身。结构体和枚举类型中修改 self 或其属性的方法必须将该实例方法标注为 mutating
    mutating func square() {
        self = self * self
    }
    
    //### 下标（Subscripts）
    //该下标 [n] 返回十进制数字从右向左数的第 n 个数字：
    subscript(var digitIndex: Int) -> Int {
        var base = 1
        while digitIndex > 0 {
            base *= 10
            digitIndex -= 1
        }
        return (self / base) % 10
    }
    
    
    // MARK: - ## 嵌套类型（Nested Types）
    
    //要在一个类型中嵌套另一个类型，将嵌套类型的定义写在其外部类型的{}内，而且可以根据需要定义多级嵌套。
    enum Kind {
        //为 Int 添加了嵌套枚举。这个名为 Kind 的枚举表示特定整数的类型。
        case Negative, Zero, Positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}
var i = 3
i.square() //9

746381295[0]// 返回 5
746381295[1]// 返回 9

print(2.kind)//Posivive

if 0.kind == Int.Kind.Zero {
    print(0)
}
//简写
if 0.kind == .Zero {
    print(0)
}


