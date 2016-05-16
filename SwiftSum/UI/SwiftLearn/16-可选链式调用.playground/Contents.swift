//: Playground - noun: a place where people can play

import UIKit

/**
 本页包含内容：
 
 - 使用可选链式调用代替强制展开
 - 为可选链式调用定义模型类
 - 通过可选链式调用访问属性
 - 通过可选链式调用调用方法
 - 通过可选链式调用访问下标
 - 连接多层可选链式调用
 - 在方法的可选返回值上进行可选链式调用
 
 可选链式调用（Optional Chaining）是一种可以在当前值可能为nil的可选值上请求和调用属性、方法及下标的方法。
 
 - 如果可选值有值，那么调用就会成功；
 - 如果可选值是nil，那么调用将返回nil。
 - 多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为nil，整个调用链都会失败，即返回nil。
 
 >注意
 Swift 的可选链式调用和 Objective-C 中向nil发送消息有些相像，但是 Swift 的可选链式调用可以应用于任意类型，并且能检查调用是否成功。
 */

class Person {
    var residence: Residence?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

func createAddress() -> Address {
    print("createAddress was called.")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    return someAddress
}

let john = Person()

//可选链式调用的返回结果与原本的返回结果具有相同的类型，但是被包装成了一个可选值。
if let roomCount = john.residence?.numberOfRooms {
    print(roomCount)
} else {
    //当可选值为空时可选链式调用只会调用失败
    print("call failed")
}

// MARK: - 通过可选链式调用来设置属性值

//<mark>赋值过程是可选链式调用的一部分，这意味着可选链式调用失败时，等号右侧的代码不会被执行。
john.residence?.address = createAddress()//没有任何打印消息，可以看出createAddress()函数并未被执行。

// MARK: - ## 通过可选链式调用调用方法

/**
 没有返回值的方法具有隐式的返回类型Void，如无返回值函数中所述。这意味着没有返回值的方法也会返回()，或者说空的元组。
 
 如果在可选值上通过可选链式调用来调用返回类型Void的方法，该方法的返回类型会是Void?，而不是Void，因为通过可选链式调用得到的返回值都是可选的。这样我们就可以使用if语句来判断能否成功调用
 */

//可以通过可选链式调用来调用方法，并判断是否调用成功，即使这个方法没有返回值。
if john.residence?.printNumberOfRooms() != nil {
    //printNumberOfRooms也不会调用
}

//同样的，可以据此判断通过可选链式调用为属性赋值是否成功。
let someAddress = createAddress()
//通过可选链式调用给属性赋值会返回Void?，通过判断返回值是否为nil就可以知道赋值是否成功
if (john.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
}


// MARK: - ## 通过可选链式调用访问下标

//注意：通过可选链式调用访问可选值的下标时，应该将问号放在下标方括号的前面而不是后面。可选链式调用的问号一般直接跟在可选表达式的后面。
if let firstRoomName = john.residence?[0].name {
}
//类似的，可以通过下标，用可选链式调用来赋值：
john.residence?[0] = Room(name: "Bathroom")

if let street = john.residence?.address?.street {
    print(street)
}

// MARK: - ## 连接多层可选链式调用

/**
 - 如果你访问的值不是可选的，可选链式调用将会返回可选值。通过可选链式调用访问一个Int值，将会返回Int?，无论使用了多少层可选链式调用。
 - 如果你访问的值就是可选的，可选链式调用不会让可选返回值变得“更可选”。通过可选链式调用访问Int?值，依旧会返回Int?值，并不会返回Int??。
 */

//在方法的圆括号后面加上问号是因为你要在buildingIdentifier()方法的可选返回值上进行可选链式调用，而不是方法本身。
john.residence?.address?.buildingIdentifier()?.hasPrefix("xx")



















