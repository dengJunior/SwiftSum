//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 泛型所解决的问题
 - 泛型函数
 - 类型参数
 - 命名类型参数
 - 泛型类型
 - 扩展一个泛型类型
 - 类型约束
 - 关联类型
 - Where 子句
 
 泛型是 Swift 最强大的特性之一，许多 Swift 标准库是通过泛型代码构建的。
 */

// MARK: - ## 泛型所解决的问题

//泛型代码让你能够根据自定义的需求，编写出适用于任意类型、灵活可重用的函数及类型。它能让你避免代码的重复，用一种清晰和抽象的方式来表达代码的意图。

// MARK: - ## 泛型函数

//泛型函数可以适用于任何类型，

//使用了占位类型名（在这里用字母 T 来表示）来代替实际类型名（例如 Int、String 或 Double）。占位类型名没有指明 T 必须是什么类型，但是它指明了 a 和 b 必须是同一类型 T，无论 T 代表什么类型。只有 swapTwoValues(_:_:) 函数在调用时，才能根据所传入的实际类型决定 T 所代表的类型。
func swapTwoValues<T>(inout a: T, inout _ b: T) {
    let temporaryA: T = a
    a = b
    b = temporaryA
}

// MARK: - ## 泛型类型
//除了泛型函数，Swift 还允许你定义泛型类型。这些自定义类、结构体和枚举可以适用于任何类型，类似于 Array 和 Dictionary。

//编写一个名为 Stack （栈）的泛型集合类型。
struct Stack<Element> {
    var items = [Element]()
    
    mutating func push(item: Element) {
        items.append(item)
    }
    mutating func pop(item: Element) -> Element {
        return items.removeLast()
    }
}

// MARK: - ## 扩展一个泛型类型
extension Stack {
    //原始类型定义中声明的类型参数列表在扩展中可以直接使用
    var topItem: Element? {
        return items.last
    }
}

// MARK: - ## 类型约束
//类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合。
func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

// MARK: - ## 关联类型
//关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定。
protocol Container {
    //定义了一个 Container 协议，该协议定义了一个关联类型 ItemType：
    associatedtype ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType{ get }
}

struct IntStack: Container {
    // IntStack 的原始实现部分
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Container 协议的实现部分
    
    //在实现 Container 的要求时，指定 ItemType 为 Int 类型，即 typealias ItemType = Int，从而将 Container 协议中抽象的 ItemType 类型转换为具体的 Int 类型。
    //不用也行，因为Swift 只需通过 append(_:) 方法的 item 参数类型和下标返回值的类型，就可以推断出 ItemType 的具体类型。
    typealias ItemType = Int
    mutating func append(item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

//让泛型 Stack 结构体遵从 Container 协议：
extension Stack: Container {
    //占位类型参数 Element 被用作 append(_:) 方法的 item 参数和下标的返回类型。Swift 可以据此推断出 Element 的类型即是 ItemType 的类型。
    mutating func append(item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

// MARK: - ## 通过扩展一个存在的类型来指定关联类型
//通过扩展添加协议一致性中描述了如何利用扩展让一个已存在的类型符合一个协议，这包括使用了关联类型的协议。

//定义了这个扩展后，你可以将任意 Array 当作 Container 来使用。
extension Array: Container {}

// MARK: - ## Where 子句
/**
 为关联类型定义约束也是非常有用的。你可以在参数列表中通过 where 子句为关联类型定义约束。
 
 - 你能通过 where 子句要求一个关联类型遵从某个特定的协议，
 - 以及某个特定的类型参数和关联类型必须类型相同。
 */

/**
 - C1 必须符合 Container 协议（写作 C1: Container）。
 - C2 必须符合 Container 协议（写作 C2: Container）。
 - C1 的 ItemType 必须和 C2 的 ItemType类型相同（写作 C1.ItemType == C2.ItemType）。
 - C1 的 ItemType 必须符合 Equatable 协议（写作 C1.ItemType: Equatable）。
 */
func allItemsMatch<C1: Container, C2: Container where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>(container1: C1, container2: C2) -> Bool {
    if container1.count != container2.count {
        return false
    }
    
    // 检查每一对元素是否相等
    for i in 0..<container2.count {
        if container1[i] != container2[i] {
            return false
        }
    }
    
    // 所有元素都匹配，返回 true
    return true
}









