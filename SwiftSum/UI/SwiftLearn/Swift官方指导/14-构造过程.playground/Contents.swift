//: Playground - noun: a place where people can play

import UIKit

/*
 本页包含内容：
 
 - 存储属性的初始赋值
 - 自定义构造过程
 - 默认构造器
 - 值类型的构造器代理
 - 类的继承和构造过程
 - 可失败构造器
 - 必要构造器
 - 通过闭包或函数设置属性的默认值
 */

class Class14 {
    //类和结构体在创建实例时，必须为所有存储型属性设置合适的初始值。存储型属性的值不能处于一个未知的状态。
    //    当你为存储型属性设置默认值或者在构造器中为其赋值时，它们的值是被直接设置的，不会触发任何属性观察者（property observers）。
    var str: String = "1" {
        willSet {
            print(newValue)
        }
    }
    
    //可选类型的属性将自动初始化为nil，表示这个属性是有意在初始化时设置为空的。
    var str2: String?
    
    //常量属性只能在定义它的类的构造过程中修改；不能在子类中修改。
    let int1: Int
    
    //构造器在创建某个特定类型的新实例时被调用。以关键字init命名：
    init() {
        //没有触发willSet
        str = "2"
        
        //你可以在构造过程中的任意时间点给常量属性指定一个值，只要在构造过程结束时是一个确定的值。一旦常量属性被赋值，它将永远不可更改。
        int1 = 2
    }
}
let c1 = Class14()
c1.str = "3"

// MARK: - ## 默认构造器
//如果结构体或类的所有属性都有默认值，同时没有自定义的构造器，那么 Swift 会给这些结构体或类提供一个默认构造器（default initializers）。这个默认构造器将简单地创建一个所有属性值都设置为默认值的实例。

//由于Class2类中的所有属性都有默认值，且它是没有父类的基类，会自动默认构造器init
class Class2 {
    let int1 = 1
    var int2 = 2
    var str1 = "1"
}
let c2 = Class2()//默认构造器

//除了上面提到的默认构造器，如果结构体没有提供自定义的构造器，它们将自动获得一个逐一成员构造器，即使结构体的存储型属性没有默认值。
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)//逐一成员构造器
let two = Size()//默认的

// MARK: - ### 指定构造器和便利构造器

class Vehicle {
    
    let str2 = "ste2"
    //如果某个存储型属性的默认值需要一些定制或设置，你可以使用闭包或全局函数为其提供定制的默认值。每当某个属性所在类型的新实例被创建时，对应的闭包或函数会被调用，而它们的返回值会当做默认值赋值给这个属性。
    var str1: String = {
        
        //>注意
        //<mark>如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。同样，你也不能使用隐式的self属性，或者调用任何实例方法。
        //let str2 = self.str2; error
       return "ss"
    }()//注意闭包结尾的大括号后面接了一对空的小括号。这用来告诉 Swift 立即执行此闭包。如果你忽略了这对括号，相当于将闭包本身作为值赋值给了属性，而不是将闭包的返回值赋值给属性。
    
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
    
    //如果你为某个值类型定义了一个自定义的构造器，你将无法访问到默认构造器（如果是结构体，还将无法访问逐一成员构造器）。
    init(number: Int) {
        numberOfWheels = number
    }
    
    //手动加个
    init() {
    }

    //可失败构造器,
    init?(count: Int) {
        return nil
    }
    
    //在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器：
//    >注意
//    如果子类继承的构造器能满足必要构造器的要求，则无须在子类中显式提供必要构造器的实现。
    required init(n: Int) {
        numberOfWheels = n
    }
}

extension Vehicle{
    //假如你希望默认构造器、逐一成员构造器以及你自己的自定义构造器都能用来创建实例，可以将自定义的构造器写到扩展（extension）中，而不是写在值类型的原始定义中。
    //Designated initilazer cannot be declare in an extension of xxx
    
    convenience init(number: Int, numb2: Int) {
        self.init()
        numberOfWheels = number
    }
    
    //可失败构造器 init! 一旦init!构造失败，则会触发一个断言。
    convenience init!(numb1: Int, numb2: Int) {
        self.init(count: 3)!
        numberOfWheels = numb1
    }
    
    convenience init?(numb11: Int, numb2: Int) {
        //<mark>无论是向上代理还是横向代理，如果你代理到的其他可失败构造器触发构造失败，整个构造过程将立即终止，接下来的任何构造代码不会再被执行。
        self.init(count: 3)
        
        //这句不会执行了
        numberOfWheels = numb2
    }
}


class Bicycle: Vehicle {
    
    /*
     Swift 中类的构造过程包含两个阶段。
     
     - 第一个阶段，每个存储型属性被引入它们的类指定一个初始值。当每个存储型属性的初始值被确定后，第二阶段开始，
     - 第二阶段给每个类一次机会，在新实例准备使用之前进一步定制它们的存储型属性。
     */
    var int1: Int
    var int2: Int
    let int3 = 3
    
    /*
     - 指定构造器（designated initializers）是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性，并根据父类链往上调用父类的构造器来实现父类的初始化。
     - 每一个类都必须拥有至少一个指定构造器。在某些情况下，许多类通过继承了父类中的指定构造器而满足了这个条件。
     */
    override init() {
        //4. 构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用self作为一个值。
//        func1(); error use of self in method call func1 before super.init initializes self
//        let int2 = self.int2; error used before be initilized
        
        
        //1. 指定构造器必须保证它所在类引入的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器。
        int1 = 1
        self.int2 = 2
        super.init()
        //2. 先向上代理调用父类构造器，然后再为继承的属性设置新值
        numberOfWheels = 2
        
        func1()//ok
    }
    
    /**
     - 便利构造器（convenience initializers）是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器，并为其参数提供默认值。
     */
    convenience init(num: Int) {
        //3. 便利构造器必须先代理调用同一类中的其它构造器，然后再为任意属性赋新值。
        self.init()
        int1 = num
    }
    
    required init(n: Int) {
        self.int1 = 1
        self.int2 = 2
        super.init(n: n)
    }
    
    func func1() {
        print(#function)
    }
}

let bycy = Bicycle()
bycy.func1()


// MARK: - ### 构造器的自动继承

/**
 如果满足特定条件，父类构造器是可以被自动继承的。
 
 1. 如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器。
 2. 如果子类提供了所有父类指定构造器的实现——无论是通过规则 1 继承过来的，还是提供了自定义实现——它将自动继承所有父类的便利构造器。
 - 子类可以将父类的指定构造器实现为便利构造器。
 */


//带原始值的枚举类型会自带一个可失败构造器init?(rawValue:)，该可失败构造器有一个名为rawValue的参数，其类型和枚举类型的原始值类型一致，如果该参数的值能够和某个枚举成员的原始值匹配，则该构造器会构造相应的枚举成员，否则构造失败。
enum Enum1: Int {
    case one, two, three
}
let en1 = Enum1(rawValue: 4)//nil










