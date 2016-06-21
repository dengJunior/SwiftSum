//: Playground - noun: a place where people can play

import Cocoa

/**
 本页包含内容：
 
 - 存储属性（Stored Properties）
 - 计算属性（Computed Properties）
 - 属性观察器（Property Observers）
 - 全局变量和局部变量（Global and Local Variables）
 - 类型属性（Type Properties）
 */

// MARK: - ## 存储属性

//存储属性只能用于类和结构体。属性的全部信息——包括命名、类型和内存管理特征——都在唯一一个地方（类型定义中）定义。

// MARK: - ### 常量结构体的存储属性

struct ValueRange {
    var length: Int
    var value: Int
    
    /*
     ### 延迟存储属性 是指当第一次被调用的时候才会计算其初始值的属性。
     1. 必须将延迟存储属性声明成变量
     2. 必须被初始化
     */
    lazy var size: Int = {
        let i = 6;
        return i;
    }()
    //>注意:<mark>如果一个被标记为 lazy 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次。
}

//如果创建了一个结构体的实例并将其赋值给一个常量，则无法修改该实例的任何属性
let value1 = ValueRange(length: 0, value: 2, size: 4)
//value1.length = 1 error

//这种行为是由于结构体（struct）属于值类型。当值类型的实例被声明为常量的时候，它的所有属性也就成了常量。

//属于引用类型的类（class）则不一样。把一个引用类型的实例赋给一个常量后，仍然可以修改该实例的变量属性。

// MARK: - ### 存储属性和实例变量

//Swift中属性的全部信息——包括命名、类型和内存管理特征——都在唯一一个地方（类型定义中）定义。

// MARK: - ## 计算属性

//计算属性不直接存储值，而是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或变量的值。

//计算属性可以用于类、结构体和枚举

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}

class Rect {
    var origin = Point()
    var size: Size {
        willSet {
            print("Rect size willSet")
        }
    }
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    //必须使用 var 关键字定义计算属性
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        
        //默认是newValue 可以自定义名字
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
    
    //### 只读计算属性 可以去掉 get 关键字和花括号
    var x: Double {
        return origin.x
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")

// MARK: - ## 属性观察器

//属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外。

//除了延迟存储属性之外的其他存储属性都可以添加属性观察器，也可以通过重写属性的方式为继承的属性（包括存储属性和计算属性）添加属性观察器。

class SubRect: Rect {
    override var size: Size {
        //willSet 观察器会将新的属性值作为常量参数传入，默认名称 newValue，可自定义
        willSet {
            print("SubRect size willSet \(newValue)")
        }
        
        //didSet 观察器会将旧的属性值作为参数传入，默认名称 oldValue，可自定义
        didSet {
            print("SubRect size didSet \(oldValue)")
        }
    }
    
    var size2: Size {
        //在新的值被设置之前调用
        willSet(newSize) {
            print("SubRect size willSet \(newSize)")
        }
        //在新的值被设置之后立即调用
        didSet(oldSize) {
            print("SubRect size2 didSet \(oldSize)")
        }
    }
    
    //>注意
    //父类的属性在子类的构造器中被赋值时，它在父类中的 willSet 和 didSet 观察器会被调用，随后才会调用子类的观察器。在父类初始化方法调用之前，子类给属性赋值时，观察器不会被调用。
    init() {
        //这里不会触发didSet
        size2 = Size(width: 19.0, height: 19.0)
        super.init(origin: Point(x: 0.0, y: 0.0),
                   size: Size(width: 10.0, height: 10.0))
        self.origin = Point(x: 0, y: 0)
        
        //这里会触发willSet
        size = Size(width: 14.0, height: 14.0)
    }
}

let subRect = SubRect()
subRect.size2 = Size(width: 11.0, height: 11.0)

//>注意
//如果将属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值。
func observerDemo(inout size:Size) {
    size = Size(width: 20.0, height: 20.0)
}
//这里会触发size2的观测器
observerDemo(&subRect.size2)

// MARK: - ## 全局变量和局部变量

//>注意
//<mark>全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。局部范围的常量或变量从不延迟计算。

// MARK: - ## 类型属性

//可以为类型本身定义属性，无论创建了多少个该类型的实例，这些属性都只有唯一一份。这种属性就是类型属性。

//存储型类型属性可以是变量或常量，计算型类型属性跟实例的计算型属性一样只能定义成变量属性。

//>注意
//跟实例的存储型属性不同，必须给存储型类型属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值。

//<mark>存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符。
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    /**
     在方法和属性之前加上关键字static或者class都可以用于指定类方法和属性.
     */
    
    /*区别
     1.static关键字指定的类方法或属性不能被子类重写, 根据报错信息: Class method overrides a 'final' class method property
     2.class关键字指定的类方法和属性可以被子类重写
     */
    
    static var storedTypeProperty = "Some value." {
        willSet {
            print(newValue)
        }
    }
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
    
    static func funcCannotBeOverride() {
    }
    class func funcCanBeOverride() {
    }
}

class SubSomeClass: SomeClass {
    
    //重写父类属性
    override class var overrideableComputedTypeProperty: Int {
        return 107
    }
    
//    override class func funcCannotBeOverride() {
//            error: Class method overrides a 'final' class method.
//    }

    //重写父类方法
    override class func funcCanBeOverride() {
    }
}

SomeClass.storedTypeProperty = "hahah"








