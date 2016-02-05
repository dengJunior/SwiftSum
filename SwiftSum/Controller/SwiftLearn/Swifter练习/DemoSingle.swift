//
//  DemoSingle.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/3/18.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import Foundation

// MARK: - 单例
private let sharedDemoSing = DemoSing()

//在 Swift 中可以无缝直接使用 GCD，所以我们可以很方便地把类似方式的单例用 Swift 进行改写
class DemoSing {
    class var sharedInstance: DemoSing {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var staticInstance:DemoSing? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.staticInstance = DemoSing()
        }
        return Static.staticInstance!
    }
    
    
    //这样的写法当然没什么问题，但是在 Swift 里我们其实有一个更简单的保证线程安全的方式，那就是 let。把上面的写法简化一下，可以变成：
    class var sharedInstance2: DemoSing {
        struct Static {
            static let single: DemoSing = DemoSing()
        }
        return Static.single
    }
    
    
    //还有另一种更受大家欢迎，并被认为是当前的最佳实践的做法。由于现在 class 不支持存储式的 property，我们想要使用一个只存在一份的属性时，就只能将其定义在全局的 scope 中。值得庆幸的是，在 Swift 拥有访问级别控制后，我们可以在变量定义前面加上 private 关键字，使这个变量只在当前文件中可以被访问。这样我们就可以写出一个没有嵌套的，语法上也更简单好看的单例了：
    class var sharedInstance3: DemoSing {
        return sharedDemoSing
    }
    
    
    
    

    
}

 // MARK: - 初始化方法顺序

//与 Objective-C 不同，Swift 的初始化方法需要保证类型的所有属性都被初始化。所以初始化方法的调用顺序就很有讲究。
class Cat {
    var name: String
    init() {
        name = "cat";
    }
}

// MARK: 方式1
class Tiger: Cat {
    let power: Int
    override init() {
        power = 10;
        super.init()
        name = "tiger"
    }
}

// MARK: 方式2
class Tiger2: Cat {
    let power: Int
    override init() {
        power = 10;
        // 虽然我们没有显式地对 super.init() 进行调用
        // 不过由于这是初始化的最后了，Swift 替我们完成了
    }
}

/**
*  一般来说，子类的初始化顺序是：

1.设置子类自己需要初始化的参数，power = 10
2.调用父类的相应的初始化方法，super.init()
3.对父类中的需要改变的成员进行设定，name = "tiger"

其中第三步是根据具体情况决定的，如果我们在子类中不需要对父类的成员做出改变的话，就不存在第 3 步。而在这种情况下，Swift 会自动地对父类的对应 init 方法进行调用，也就是说，第 2 步的 super.init() 也是可以不用写的 (但是实际上还是调用的，只不过是为了简便 Swift 帮我们完成了)。

 初始化方法永远遵循以下两个原则：
1.初始化路径必须保证对象完全初始化，这可以通过调用本类型的 designated 初始化方法来得到保证；
2.子类的 designated 初始化方法必须调用父类的 designated 方法，以保证父类也完成初始化。
*/

 // MARK: - 深入初始化方法
class ClassA {
    let numA: Int
    
    //designated 初始化方法
    //如果我们希望init(bigNum: Bool)这个初始化方法对于子类一定可用，那么加上required
    required init(num: Int) {
        numA = num
    }
    
    //在 init 前加上 convenience 关键字的初始化方法。这类方法是 Swift 初始化方法中的 “二等公民”，只作为补充和提供使用上的方便。
    //convenience 初始化方法都必须调用同一个类中的 designated 初始化完成设置，另外 convenience 的初始化方法是不能被子类重写或者是从子类中以 super 的方式被调用的。
    convenience init(bigNum: Bool) {
        self.init(num: bigNum ? 1000 : 1);
    }
    
    //对于 convenience 的初始化方法，可以加上 required 以确保子类对其进行实现。这在要求子类不直接使用父类中的 convenience 初始化方法时会非常有帮助。
    required convenience init(smallNum: Bool) {
        self.init(num: smallNum ? -100 : 1);
    }
}

class ClassB: ClassA {
    let numB: Int
    
    required init(num: Int) {
        
        // init 里我们可以对 let 的实例常量进行赋值，这是初始化方法的重要特点。在 Swift 中 let 声明的值是不变量，无法被写入赋值，这对于构建线程安全的 API 十分有用。而因为 Swift 的 init 只可能被调用一次，因此在 init 中我们可以为不变量进行赋值，而不会引起任何线程安全的问题。
        numB = num + 1
        super.init(num: num)
    }
    
    required convenience init(smallNum: Bool) {
        self.init(num: smallNum ? -100 : 1);
    }
}

 // MARK: - 初始化返回 NIL


//在 Swift 中默认情况下初始化方法是不能写 return 语句来返回值的，也就是说我们没有机会初始化一个 Optional 的值。


class Url {
    var str: String!
     // MARK: Swift 1.0 及之前
    //写一个类方法来生成和返回实例,算是一种折衷。
    class func urlWithString(str: String!) -> Url! {
        return nil;
    }
    
     // MARK: Swift 1.1 及之后
    //可以在 init 声明时在其后加上一个 ? 或者 ! 来表示初始化失败时可能返回 nil。
    init?(fromString: String!) {
        str = fromString
        if ( fromString != nil) {
            
        } else {
            return nil
        }
        
    }
}

 // MARK: - PROTOCOL 组合

//我们有下面的三个接口，分别代表了三种动物的叫的方式
protocol Kit {
    func meow() -> String
}
protocol Dog {
    func bark() -> String
}
protocol Tig {
    func aou() -> String
}
//而有动物，同时实现了这三个接口
class Anim:Kit, Dog, Tig {
    func meow() -> String{
        return "meow"
    }
    
    func bark() -> String{
        return "bark"
    }
    
    func aou() -> String{
        return "aou"
    }
}

 // MARK:检查某种动物作为猫科动物的叫声，protocol 组合是可以使用 typealias 来命名的
typealias CatLike = protocol<Kit,Tig>

 // MARK: 原生的 Swift protocol 里没有可选项，所有定义的方法都是必须实现的。如果我们想要像 Objective-C 里那样定义可选的接口方法，就需要将接口本身定义为 Objective-C 的
@objc protocol Optionall {
    //使用没有 @ 符号的关键字 optional 来定义可选方法：
    optional func heloo()   // 可选
    
    //必须对每一个可选方法添加前缀，对于没有前缀的方法来说，它们是默认必须实现的：
    func necessaryMethod()          // 必须
    optional func anotherOptionalMethod() // 可选
}
//一个不可避免的限制是，使用 @objc 修饰的 protocol 就只能被 class 实现了，也就是说，对于 struct 和 enum 类型，我们是无法令它们所实现的接口中含有可选方法或者属性的。

// MARK: 关于实现多个接口时接口内方法冲突的解决方法
protocol A {
    func bar() -> Int
}
protocol B {
    func bar() -> String
}
//有一个类型 Class 同时实现了 A 和 B，我们要怎么才能避免和解决调用冲突呢？
class C:A, B {
    func bar() -> Int {
        return 1
    }
    
    func bar() -> String {
        return "Hi"
    }
}
func test() {
    let instace = C()
    //只要在调用前进行类型转换就可以了：
    let num = (instace as A).bar()// 1
    let str = (instace as B).bar()// "Hi"
}


// MARK: - 类型范围作用域 这一概念有两个不同的关键字，它们分别是 static 和 class。
//在非 class 的类型上下文中，我们统一使用 static 来描述类型作用域。这包括在 enum 和 struct
struct Point {
    let x: Double
    let y: Double
    
    // 存储属性
    static let zero = Point(x: 0, y: 0)
    
    // 计算属性
    static var ones: [Point] {
        return [Point(x: 1, y: 1),
            Point(x: -1, y: 1),
            Point(x: 1, y: -1),
            Point(x: -1, y: -1)]
    }
    
    // 类型方法
    static func add(p1: Point, p2: Point) -> Point {
        return Point(x: p1.x + p2.x, y: p1.y + p2.y)
    }
}

//class 关键字是专门用在 class 类型的上下文中的，可以用来修饰类方法以及类的计算属性。要特别注意 class 中现在是不能出现存储属性的，
class MyClass {
    //class var bar: Bar?   //编译时会得到一个错误, 这主要是因为在 Objective-C 中就没有类变量这个概念，为了运行时的统一和兼容，暂时不太方便添加这个特性。Apple 表示今后将会考虑在某个升级版本中实装 class 类型的类存储变量，现在的话，我们只能在 class 中用 class 关键字声明方法和计算属性。
    
}

// MARK: 如果我们想在 protocol 里定义一个类型域上的方法或者计算属性的话，应该用哪个关键字呢？
//答案是使用 static 进行定义
protocol Pro {
    static func foo() -> String
    //注意
    //在 Swift 1.2 之前 protocol 中使用的是 class 作为关键字，但这确实是不合逻辑的。Swift 1.2 对此进行了改进，现在只需要记住除了确实是具体的 class以外，其他情况都使用 static 就行了。

}

struct Mstruct: Pro {
    static func foo() -> String {
        return "MyStruct"
    }
}
enum MyEnum: Pro {
    static func foo() -> String {
        return "MyEnum"
    }
}
class MyClas: Pro {
    class func foo() -> String {
        return "MyClass"
    }
}

// MARK: - @OBJC 和 DYNAMIC

/**
*  Swift 不得不考虑与 Objective-C 的兼容。

Apple 采取的做法是允许我们在同一个项目中同时使用 Swift 和 Objective-C 来进行开发。其实一个项目中的 Objective-C 文件和 Swift 文件是处于两个不同世界中的，为了让它们能相互联通，我们需要添加一些桥梁。

首先通过添加 {product-module-name}-Bridging-Header.h 文件，并在其中填写想要使用的头文件名称，我们就可以很容易地在 Swift 中使用 Objective-C 代码了。
*/

//Objective-C 和 Swift 在底层使用的是两套完全不同的机制，Cocoa 中的 Objective-C 对象是基于运行时的，它从骨子里遵循了 KVC (Key-Value Coding，通过类似字典的方式存储对象信息) 以及动态派发 (Dynamic Dispatch，在运行调用时再决定实际调用的具体实现)。
//而 Swift 为了追求性能，如果没有特殊需要的话，是不会在运行时再来决定这些的。也就是说，Swift 类型的成员或者方法在编译时就已经决定，而运行时便不再需要经过一次查找，而可以直接使用。

//这带来的问题是如果我们要使用 Objective-C 的代码或者特性来调用纯 Swift 的类型时候，我们会因为找不到所需要的这些运行时信息，而导致失败。解决起来也很简单，在 Swift 类型文件中，我们可以将需要暴露给 Objective-C 使用的任何地方 (包括类，属性和方法等) 的声明前面加上 @objc 修饰符。注意这个步骤只需要对那些不是继承自 NSObject 的类型进行，如果你用 Swift 写的 class 是继承自 NSObject 的话，Swift 会默认自动为所有的非 private 的类和成员加上 @objc。这就是说，对一个 NSObject 的子类，你只需要导入相应的头文件就可以在 Objective-C 里使用这个类了。



//@objc 修饰符的另一个作用是为 Objective-C 侧重新声明方法或者变量的名字。虽然绝大部分时候自动转换的方法名已经足够好用 (比如会将 Swift 中类似 init(name: String) 的方法转换成 -initWithName:(NSString *)name 这样)，但是有时候我们还是期望 Objective-C 里使用和 Swift 中不一样的方法名或者类的名字，比如 Swift 里这样的一个类：

// MARK: Objective-C 的话是无法使用中文来进行调用的，因此我们必须使用 @objc 将其转为 ASCII 才能在 Objective-C 里访问：

class 类 {
    //添加 @objc 修饰符并不意味着这个方法或者属性会变成动态派发
    @objc(greeting:)
    func 打人(名字: String) {
        print("哈喽，\(名字)")
    }
}
//添加 @objc 修饰符并不意味着这个方法或者属性会变成动态派发，Swift 依然可能会将其优化为静态调用。如果你需要和 Objective-C 里动态调用时相同的运行时特性的话，你需要使用的修饰符是 dynamic。一般情况下在做 app 开发时应该用不上，但是在施展一些像动态替换方法或者运行时再决定实现这样的 "黑魔法" 的时候，我们就需要用到 dynamic 修饰符了。














