//: Playground - noun: a place where people can play

import UIKit


// MARK: - 控制流（Control Flow）

/**
 本页包含内容：
 
 - For-In 循环
 - While 循环
 - 条件语句
 - 控制转移语句（Control Transfer Statements）
 - 提前退出
 - 检测 API 可用性
 */


/**
 ## For-In 循环
 
 使用for-in循环来遍历一个集合里面的所有元素，
 
 ## While 循环
 
 while循环运行一系列语句直到条件变成false。
 
 ### Repeat-While
 
 repeat {
 statements
 } while condition
 
 ## 条件语句
 
 Swift 提供两种类型的条件语句：if语句和switch语句。
 
 ## If
 */


// MARK: - ## Switch

//switch语句必须是完备的。这就是说，每一个可能的值都必须至少有一个 case 分支与之对应。可以使用默认（default）分支满足该要求，必须在switch语句的最后面。

// MARK: - ### 不存在隐式的贯穿（No Implicit Fallthrough）

let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a":
    //每一个 case 分支都必须包含至少一条语句。这里不加break，报错
    break
    
//一个 case 也可以包含多个模式，用逗号把它们分开（如果太长了也可以分行写）
case "b",
     "B":
    print("The letter b")
    
//case 分支的模式也可以是一个值的区间。
case "c"..<"e":
    print("c~e")
default:
    print("Not the letter A")
}

// MARK: - ### 元组（Tuple）

//我们可以使用元组在同一个switch语句中测试多个值。元组中的元素可以是值，也可以是区间。
let somePoint = (0, 0)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
    
//下划线（_）来匹配所有可能的值。
case (_, 0):
    print("(\(somePoint.0), 0) is on the x-axis")
    
//值绑定（value binding） 允许将匹配的值绑定到一个临时的常量或变量
case (0, let y):
    print("(0, \(y)) is on the y-axis")

//case 分支的模式可以使用where语句来判断额外的条件。当且仅当where语句的条件为true时，匹配到的 case 分支才会被执行。
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
    
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}

//不像 C 语言，Swift 允许多个 case 匹配同一个值，但只取第一个，
//点(0, 0)可以匹配所有 case。但是，如果存在多个匹配，那么只会执行第一个被匹配到的 case 分支。
print("(0, 0) is at the origin")


// MARK: - ##控制转移语句（Control Transfer Statements）

/**
 Swift 有五种控制转移语句：
 
 - continue
 - break
 - fallthrough
 - return
 - throw
 */

//Swift 中的switch不会从上一个 case 分支落入到下一个 case 分支中。如果你确实需要 C 风格的贯穿的特性，你可以在每个需要该特性的 case 分支中使用fallthrough关键字。

let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)// 输出 "The number 5 is a prime number, and also an integer."
//>注意： fallthrough关键字不会检查它下一个将会落入执行的 case 中的匹配条件。fallthrough简单地使代码执行继续连接到下一个 case 中的执行代码，这和 C 语言标准中的switch语句特性是一样的。

// MARK: - ### 带标签的语句

//显式地指明break,continue语句想要终止的是哪个循环体或者switch代码块，会很有用。
//label name: while condition { statements }

let finalSquare = 25
var square = 0

gameLoop: while square != finalSquare {
    square += 1
    
    switch square {
    case finalSquare:
        // 到达最后一个方块，游戏结束
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // 超出最后一个方块，重新赋值，继续
        square = finalSquare - 10
        continue gameLoop
    default:
        square += 1
    }
}
print("Game over!")


// MARK: - ## 提前退出

//像if语句一样，guard的执行取决于一个表达式的布尔值。我们可以使用guard语句来要求条件必须为真时，以执行guard语句后的代码。
    
//    - 不同于if语句，一个guard语句总是有一个else分句，如果条件不为真则执行else分句中的代码。
//    - guard中的变量或常量在后面的代码段中是可用的。

func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)")
    
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}
greet(["name": "John"])
// 输出 "Hello John!"
// 输出 "I hope the weather is nice near you."
greet(["name": "Jane", "location": "Cupertino"])
// 输出 "Hello Jane!"
// 输出 "I hope the weather is nice in Cupertino."

// MARK: - ## 检测 API 可用性

//最后一个参数，*，是必须的并且指定在任何其他平台上，if段的代码在最小可用部署目标指定项目中执行。
if #available(iOS 9, OSX 10.10, *) {
    // 在 iOS 使用 iOS 9 的 API, 在 OS X 使用 OS X v10.10 的 API
} else {
    // 使用先前版本的 iOS 和 OS X 的 API
}

//在它普遍的形式中，可用性条件获取了平台名字和版本的清单。平台名字可以是iOS，OSX或watchOS。除了特定的主板本号像 iOS 8，我们可以指定较小的版本号像iOS 8.3 以及 OS X v10.10.3。

/*
if #available(`platform name` `version`, `...`, *) {
    `statements to execute if the APIs are available`
} else {
    `fallback statements to execute if the APIs are unavailable`
}
*/



