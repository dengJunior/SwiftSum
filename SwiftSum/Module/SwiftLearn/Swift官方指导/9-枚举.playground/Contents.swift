//: Playground - noun: a place where people can play

import Cocoa

/**
 本页内容包含：
 
 - 枚举语法（Enumeration Syntax）
 - 使用 Switch 语句匹配枚举值（Matching Enumeration Values - with a Switch Statement）
 - 关联值（Associated Values）
 - 原始值（Raw Values）
 - 递归枚举（Recursive Enumerations）
 */

//枚举为一组相关的值定义了一个共同的类型

//在 Swift 中，枚举类型是一等（first-class）类型。它们采用了很多在传统上只被类（class）所支持的特性，

// MARK: - ## 枚举语法

enum CompassPoint {
    //多个成员值可以出现在同一行上，用逗号隔开：
    case North, South
    case East
    case West
}
//每个枚举定义了一个全新的类型。应该给枚举类型起一个单数名字而不是复数名字

//注意：与 C 和 Objective-C 不同，Swift 的枚举成员在被创建时不会被赋予一个默认的整型值。相反，这些枚举成员本身就是完备的值，这些值的类型是已经明确定义好的CompassPoint类型。

// MARK: - ## 使用 Switch 语句匹配枚举值

var directionToHead = CompassPoint.South
switch directionToHead {
case .North:
    print("Lots of planets have a north")
case .South:
    print("Watch out for penguins")
case .East:
    print("Where the sun rises")
case .West:
    print("Where the skies are blue")
}
// 输出 "Watch out for penguins”

//在判断一个枚举类型的值时，switch语句必须穷举所有情况。

// MARK: - ## 关联值（Associated Values）

//你可以定义 Swift 枚举来存储任意类型的关联值，如果需要的话，每个枚举成员的关联值类型可以各不相同。枚举的这种特性跟其他语言中的可识别联合（discriminated unions），标签联合（tagged unions），或者变体（variants）相似。
enum BarCode {
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}
//定义一个名为Barcode的枚举类型，它的一个成员值是具有(Int，Int，Int，Int)类型关联值的UPCA，另一个成员值是具有String类型关联值的QRCode。”

//这个定义不提供任何Int或String类型的关联值，它只是定义了，当Barcode常量和变量等于Barcode.UPCA或Barcode.QRCode时，可以存储的关联值的类型。

var productBarcode = BarCode.UPCA(8, 85909, 51226, 3)
productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

switch productBarcode {
    
//如果一个枚举成员的所有关联值都被提取为常量，或者都被提取为变量，为了简洁，你可以只在成员名称前标注一个let或者var：
case let .UPCA(numberSystem, manufacturer, product, check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
    
case .QRCode(let productCode):
    print("QR code: \(productCode).")
}
// 输出 "QR code: ABCDEFGHIJKLMNOP."

// MARK: - ## 原始值（Raw Values）

//作为关联值的替代选择，枚举成员可以被默认值（称为原始值）预填充，这些原始值的类型必须相同。
//原始值可以是字符串，字符，或者任意整型值或浮点型值。每个原始值在枚举声明中必须是唯一的。

enum ASCIIControlCharacter: Character {
    case Tab = "\t"
    case LineFeed = "\n"
    case CarriageReturn = "\r"
}
//枚举类型ASCIIControlCharacter的原始值类型被定义为Character

//>注意
//原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。

// MARK: - ## 原始值的隐式赋值（Implicitly Assigned Raw Values）

//在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。

/**
 - 当使用整数作为原始值时，隐式赋值的值依次递增1。如果第一个枚举成员没有设置原始值，其原始值将为0。
 - 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
 - 使用枚举成员的rawValue属性可以访问该枚举成员的原始值
 */

enum IntEnum: Int {
    case first, second
}
enum DoubleEnum: Double {
    case first, second
}
//Character 必须显示指定初始值
//enum CharEnum: Character {
//    case first, second
//}
enum StringEnum: String {
    case first, second
}

print(IntEnum.first.rawValue)//0
print(DoubleEnum.first.rawValue)//0.0
print(StringEnum.first.rawValue)//first

//如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做rawValue的参数，参数类型即为原始值类型，返回值则是枚举成员或nil。你可以使用这个初始化方法来创建一个新的枚举实例。

//原始值构造器是一个可失败构造器，因为并不是每一个原始值都有与之对应的枚举成员。
let possbleString = StringEnum(rawValue: "first")//first
let possbleString2 = StringEnum(rawValue: "fff")//nil

// MARK: - ## 递归枚举（Recursive Enumerations）

//递归枚举（recursive enumeration）是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。你可以在枚举成员前加上indirect来表示该成员可递归。

enum Arithmetic {
    case Number(Int)
    indirect case Add(Arithmetic, Arithmetic)
    indirect case Multi(Arithmetic, Arithmetic)
}
//上面定义的枚举类型可以存储三种算术表达式：纯数字、两个表达式相加、两个表达式相乘。枚举成员Add和Multi的关联值也是算术表达式——这些关联值使得嵌套表达式成为可能。

//也可以在枚举类型开头加上indirect关键字来表明它的所有成员都是可递归的：
indirect enum Arithmetic2 {
    case Number(Int)
    case Add(Arithmetic, Arithmetic)
    case Multi(Arithmetic, Arithmetic)
}

//要操作具有递归性质的数据结构，使用递归函数是一种直截了当的方式。
func evaluate(expression: Arithmetic) -> Int {
    switch expression {
    case .Number(let value):
        return value
    case .Add(let left, let right):
        return evaluate(left) + evaluate(right)
    case .Multi(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}

// 计算 (5 + 4) * 2
let five = Arithmetic.Number(5)
let four = Arithmetic.Number(4)
let sum = Arithmetic.Add(five, four)
let product = Arithmetic.Multi(sum, Arithmetic.Number(2))
print(evaluate(product))//18



















