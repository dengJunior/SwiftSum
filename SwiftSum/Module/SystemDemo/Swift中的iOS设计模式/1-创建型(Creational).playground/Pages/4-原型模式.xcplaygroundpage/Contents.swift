//: [Previous](@previous)

import Foundation

/*
 Prototype 原型模式
 
 The prototype pattern is used to instantiate a new object by copying all of the properties of an existing object, creating an independent clone. This practise is particularly useful when the construction of a new object is inefficient.
 
 原型模式用于复制现有对象的所有属性，创建一个独立的克隆对象。这种模式在创建新对象的非常复杂且耗时特别有用。
 */
class PrototypeDemo {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func clone() -> PrototypeDemo {
        return PrototypeDemo(name: name)
    }
}

// MARK: - Usage
let Prototype = PrototypeDemo(name:"Hello")

let Philippe = Prototype.clone()
Philippe.name = "Philippe"

let Christoph = Prototype.clone()
Christoph.name = "Christoph"



//: [Next](@next)
