//: Playground -  noun: a place where people can play

import UIKit

var str = "Hello, playground"


/**
 ## 基础部分(TheBasics)
 
 [参考链接](http://wiki.jikexueyuan.com/project/swift/chapter2/01_The_Basics.html)
 
 Swift 包含了 C 和 Objective// MARK: - C 上所有基础数据类型，Int表示整型值；Double和Float表示浮点型值；Bool是布尔型值；String是文本型数据。Swift 还提供了三个基本的集合类型，Array，Set和Dictionary，详见集合类型。
 
 Swift 是一门类型安全的语言，可选类型就是一个很好的例子。Swift 可以让你清楚地知道值的类型。如果你的代码期望得到一个String，类型安全会阻止你不小心传入一个Int。你可以在开发阶段尽早发现并修正错误。
 */

// MARK: -  常量和变量

/**
 *  let来声明常量，用var来声明变量。
 可以在一行中声明多个常量或者多个变量，用逗号隔开：
 */
var x = 0, y = 0.1, z = "haha"

// MARK: -  类型标注

//当你声明常量或者变量的时候可以加上类型标注（type annotation），

var wel: String
var red, green, blue: Double

// MARK: -  常量和变量的命名

//可以用任何你喜欢的字符作为常量和变量名，包括 Unicode 字符：
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"
let `let` = "let hhah" //使用与Swift保留关键字相同的名称作为常量或者变量名

//常量与变量名不能包含数学符号，箭头，保留的（或者非法的）Unicode 码位，连线与制表符。也不能以数字开头，但是可以在常量与变量名的其他地方包含数字。

// MARK: -  输出常量和变量

//print(_:separator:terminator:)将会输出内容到“console”面板上。separator和terminator参数具有默认值，因此你调用这个函数的时候可以忽略它们。

let friendlyWelcome = "friendlyWelcome"
print("The current value of friendlyWelcome is \(friendlyWelcome)", separator: "")

// MARK: -  注释

/* 这是第一个多行注释的开头
 /* 这是第二个被嵌套的多行注释 */
 这是第一个多行注释的结尾 */


// MARK: -  分号

//不强制要求你在每条语句的结尾处使用分号，但下面这种在同一行内写多条独立的语句必须要
let cat = "🐱"; print(cat)

// MARK: -  整数范围

let minValue = UInt8.min  // minValue 为 0，是 UInt8 类型
let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型

// MARK: -  Int

/**
 在32位平台上，Int和Int32长度相同。
 在64位平台上，Int和Int64长度相同。
 */

// MARK: -  UInt

/**
 >注意：
 尽量不要使用UInt，除非你真的需要存储一个和当前平台原生字长相同的无符号整数。除了这种情况，最好使用Int，即使你要存储的值已知是非负的。统一使用Int可以提高代码的可复用性，避免不同类型数字之间的转换，并且匹配数字的类型推断，请参考类型安全和类型推断。
 */

// MARK: -  浮点数

/**
 - Double表示64位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
 - Float表示32位浮点数。精度要求不高的话可以使用此类型。
 
 Double精确度很高，至少有15位数字，而Float只有6位数字。
 */

// MARK: -  类型安全和类型推断

//Swift 是类型安全的，它会在编译你的代码时进行类型检查（type checks），并把不匹配的类型标记为错误。

let meaningOfLife = 42
// meaningOfLife 会被推测为 Int 类型

let pi = 3.14159
// pi 会被推测为 Double 类型

let anotherPi = 3 + 0.14159
// anotherPi 会被推测为 Double 类型

// MARK: -  数值型字面量

let decimalInteger = 17
let binaryInteger = 0b10001       // 二进制的17
let octalInteger = 0o21           // 八进制的17
let hexadecimalInteger = 0x11     // 十六进制的17

/**
 如果一个十进制数的指数为exp，那这个数相当于基数和10^exp的乘积：
 
 - 1.25e2 表示 1.25 × 10^2，等于 125.0。
 - 1.25e-2 表示 1.25 × 10^-2，等于 0.0125。
 
 如果一个十六进制数的指数为exp，那这个数相当于基数和2^exp的乘积：
 
 - 0xFp2 表示 15 × 2^2，等于 60.0。
 - 0xFp-2 表示 15 × 2^-2，等于 3.75。
 */

//下面的这些浮点字面量都等于十进制的12.1875：

let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0

//数值类字面量可以包括额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量：
    
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

// MARK: -  数值型类型转换

/**
 如果数字超出了常量或者变量可存储的范围，编译的时候会报错：
 
 let cannotBeNegative: UInt8 = -1
 // UInt8 类型不能存储负数，所以会报错
 let tooBig: Int8 = Int8.max + 1
 // Int8 类型不能存储超过最大值的数，所以会报错
 */

/**
 下面的例子中，常量twoThousand是UInt16类型，然而常量one是UInt8类型。它们不能直接相加，因为它们类型不同,需要转换。
 
 let twoThousand: UInt16 = 2_000
 let one: UInt8 = 1
 let twoThousandAndOne = twoThousand + UInt16(one)
 */

// MARK: -  数整数和浮点数转换

//整数和浮点数的转换必须显式指定类型：
let pi2 = 3.14
let integerPi = Int(pi2)//3
//用这种方式来初始化一个新的整数值时，浮点值会被截断。也就是说4.75会变成4，-3.9会变成-3。

/*
 注意：结合数字类常量和变量不同于结合数字类字面量。
 字面量3可以直接和字面量0.14159相加，因为数字字面量本身没有明确的类型。
 它们的类型只在编译器需要求值的时候被推测。
 */
let ttt = 3 + 0.14//3.14

// MARK: -  类型别名

typealias AudioSample = UInt16

// MARK: -  布尔值

/**
 Swift 有两个布尔常量，true和false：
 *  在需要使用Bool类型的地方使用了非布尔值，Swift 的类型安全机制会报错。
 */

// MARK: -  元组

/**
 *  元组（tuples）把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。
 */
let http404Error = (404, "Not Found")
// http404Error 的类型是 (Int, String)，值是 (404, "Not Found")
//可以被描述为“一个类型为(Int, String)的元组”。

//可以将一个元组的内容分解（decompose）成单独的常量和变量
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")

//如果你只需要一部分元组值，分解的时候可以把要忽略的部分用下划线（_）标记：
let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")

//还可以通过下标来访问元组中的单个元素，下标从零开始：
print("The status code is \(http404Error.0)")

//你可以在定义元组的时候给单个元素命名：
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode)")


// MARK: -  可选

//使用可选类型（optionals）来处理值可能缺失的情况。

// MARK: -  nil

var someOptional: Int? = nil

/**
 你可以给可选变量赋值为nil来表示它没有值：
 nil不能用于非可选的常量和变量。如果你声明一个可选常量或者变量但是没有赋值，它们会自动被设置为nil：
 
 注意：Swift 的nil和 Objective-C 中的nil并不一样。在 Objective-C 中，nil是一个指向不存在对象的指针。在 Swift 中，nil不是指针——它是一个确定的值，用来表示值缺失。任何类型的可选状态都可以被设置为nil，不只是对象类型。
 */

// MARK: -  if 语句以及强制解析

//可以在可选的名字后面加一个感叹号（!）来获取值。
//使用!来获取一个不存在的可选值会导致运行时错误。

// MARK: -  可选绑定

/**
 *  使用可选绑定（optional binding）来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量。
 */
//像下面这样在if语句中写一个可选绑定：
if let constantName = someOptional {
}

// MARK: -  隐式解析可选类型

/**
 有时候在程序架构中，变量第一次被赋值之后，可以确定一个可选类型_总会_有值。
 
 这种类型的可选状态被定义为隐式解析可选类型（implicitly unwrapped optionals）。把想要用作可选的类型的后面的问号（String?）改成感叹号（String!）来声明一个隐式解析可选类型。
 */
let some: Int!
some = 1

/**
 在隐式解析可选类型没有值的时候尝试取值，会触发运行时错误。
 */

// MARK: -  错误处理

//错误处理可以推断失败的原因，并传播至程序的其他部分。
func canThrowAnError() throws {
    // 这个函数有可能抛出错误
}

//一个函数可以通过在声明中添加throws关键词来抛出错误消息。当你的函数能抛出错误消息时, 你应该在表达式中前置try关键词。

//一个do语句创建了一个新的包含作用域,使得错误能被传播到一个或多个catch从句。
do {
    try canThrowAnError()
    // 没有错误消息抛出
} catch {
    // 有一个错误消息抛出
}

// MARK: -  断言

let age = 3
assert(age > 0)
/**
 *  当代码使用优化编译的时候，断言将会被禁用，例如在 Xcode 中，使用默认的 target Release 配置选项来 build 时，断言会被禁用。
 */









