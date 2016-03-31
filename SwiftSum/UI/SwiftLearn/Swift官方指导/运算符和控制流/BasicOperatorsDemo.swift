//
//  BasicOperatorsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/4.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class BasicOperatorsDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func basicOperatorsDemo() {
        
        // MARK: - 赋值运算符
        //如果赋值的右边是一个多元组，它的元素可以马上被分解多个常量或变量：
        let (x, y) = (1, 2)
        x   //1  Int
        y   //2
        
        //与 C 语言和 Objective-C 不同，Swift 的赋值操作并不返回任何值。所以以下代码是错误的：
//        if (x = y) {
//        
//        }
        
        let hellV = "hello" + "world"   //加法运算符也可用于String的拼接：
        let dog:Character = "d"
        
        // MARK: - 浮点数求余计算
        //不同于 C 语言和 Objective-C，Swift 中是可以对浮点数进行求余的。
        8 % 2.5 //结果是一个Double值0.5。
        
        
        // MARK: - 比较运算符
        //所有标准 C 语言中的比较运算都可以在 Swift 中使用。
        //注意： Swift 也提供恒等===和不恒等!==这两个比较符来判断两个对象是否引用同一个对象实例。
        
        
        // MARK: - 空合运算符(Nil Coalescing Operator)
        
        /**
        *  空合运算符(a ?? b)将对可选类型a进行空判断，如果a包含一个值就进行解封，否则就返回一个默认值b.这个运算符有两个条件:
        
        表达式a必须是Optional类型
        默认值b的类型必须要和a存储值的类型保持一致
        */
        //注意： 如果a为非空值(non-nil),那么值b将不会被估值。这也就是所谓的短路求值。
        let defaultColorName = "red"
        var userDefinedColorName:String?   //默认值为nil
        var colorNameToUse = userDefinedColorName ?? defaultColorName //等效于下面
        let colorNmaeToUes2 = userDefinedColorName != nil ? userDefinedColorName! : defaultColorName
        
        
        // MARK: - 闭区间运算符
        /**
        *  闭区间运算符（a...b）定义一个包含从a到b(包括a和b)的所有值的区间，b必须大于a。 ‌
        闭区间运算符在迭代一个区间的所有值时是非常有用的，如在for-in循环中：
        */
        for index in 1...5 {
            print("\(index) * 5 = \(index * 5)")
        }
        /**
        1 * 5 = 5
        2 * 5 = 10
        3 * 5 = 15
        4 * 5 = 20
        5 * 5 = 25
        */
        
        // MARK: - 半开区间运算符
        /**
        半开区间（a..<b）定义一个从a到b但不包括b的区间。 之所以称为半开区间，是因为该区间包含第一个值而不包括最后的值。
        */
        
        for index in 1..<5 {
            print("\(index) * 5 = \(index * 5)")
        }
        /**
        1 * 5 = 5
        2 * 5 = 10
        3 * 5 = 15
        4 * 5 = 20
        */
         
         
         // MARK: - While 循环
         
        //有一个repeat-while循环，和其他语言中的do-while循环是类似的。
        
        
         // MARK: - Switch
         
         /*
         switch语句必须是完备的。这就是说，每一个可能的值都必须至少有一个 case 分支与之对应。
         在某些不可能涵盖所有值的情况下，你可以使用默认（default）分支满足该要求，
         这个默认分支必须在switch语句的最后面。
         */
        
        let someCharacter: Character = "e"
        switch someCharacter {
        case "a", "e", "i", "o", "u":
            print("\(someCharacter) is a vowel")
        case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
        "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
            print("\(someCharacter) is a consonant")
        default:
            print("\(someCharacter) is not a vowel or a consonant")
        }
        // 输出 "e is a vowel"
        
        
        // MARK: - 不存在隐式的贯穿（No Implicit Fallthrough）
        /**
        *  当匹配的 case 分支中的代码执行完毕后，程序会终止switch语句,不用break
        */
        
        /**
        *  每一个 case 分支都必须包含至少一条语句。像下面这样书写代码是无效的，因为第一个 case 分支是空的：
        
        let anotherCharacter: Character = "a"
        switch anotherCharacter {
        case "a":
        case "A":
        println("The letter A")
        default:
        println("Not the letter A")
        }
        // this will report a compile-time error
        */
        
        
        //可以这样, 一个 case 也可以包含多个模式，用逗号把它们分开,如果想要贯穿至特定的 case 分支中，请使用fallthrough语句
        let anotherCharacter: Character = "a"
        switch anotherCharacter {
        case "a","A":
            print("The letter A")
        default:
            print("Not the letter A")
        }

        
        // MARK: - 区间匹配（Range Matching）
        
        let count = 3_000
        var naturalCount: String
        switch count {
        case 0:
            naturalCount = "no"
        case 1...3:
            naturalCount = "a few"
        case 4...9:
            naturalCount = "several"
        case 10...99:
            naturalCount = "tens of"
        case 100...999:
            naturalCount = "hundreds of"
        case 1000...999_999:
            naturalCount = "thousands of"
        default:
            naturalCount = "millions and millions of"
        }
        
        
        
        // MARK: - 元组匹配（Tuple）
        
        /**
        *  你可以使用元组在同一个switch语句中测试多个值。元组中的元素可以是值，也可以是区间。
        另外，使用下划线（_）来匹配所有可能的值。
        */
        
        let somePoint = (0, 0)
        switch somePoint {  //点(0, 0)可以匹配所有四个 case。但是，如果存在多个匹配，那么只会执行第一个被匹配到的 case 分支。
        case (0, 0):
            print("(0, 0) is at the origin")
        case (_, 0):
            print("(\(somePoint.0), 0) is on the x-axis")
        case (0, _):
            print("(0, \(somePoint.1)) is on the y-axis")
        case (-2...2, -2...2):
            print("(\(somePoint.0), \(somePoint.1)) is inside the box")
        default:
            print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
        }
        
        /*
        case 分支的模式允许将匹配的值绑定到一个临时的常量或变量，
        这些常量或变量在该 case 分支里就可以被引用了——这种行为被称为值绑定（value binding）。
        */
        
        let anotherPoint = (2, 0)
        switch anotherPoint {
        case (let x, 0):
            print("on the x-axis value of \(x)")
        case (0, let y):
            print("on the y-axis with a y value of \(y)")
        case let (x, y):
            print("somewhere else at (\(x), \(y))")
        }
        
        
        
        // MARK: - Where
        
        let point = (1, -1)
        switch point {
        case let (x, y) where x == y:
            print("(\(x), \(y)) is on the line x == y")
        case let (x, y) where x == -y:
            print("(\(x), \(y)) is on the line x == -y")
        case let (a, b):
            print("(\(a), \(b)) is just some arbitrary point")
        }
        
        /**
        *  这三个 case 都声明了常量x和y的占位符，用于临时获取元组yetAnotherPoint的两个值。
        这些常量被用作where语句的一部分，从而创建一个动态的过滤器(filter)。
        当且仅当where语句的条件为true时，匹配到的 case 分支才会被执行。
        
        就像是值绑定中的例子，由于最后一个 case 分支匹配了余下所有可能的值，
        switch语句就已经完备了，因此不需要再书写默认分支。
        */
        
        
         // MARK: - 控制转移语句（Control Transfer Statements）
         
         /**
         *  控制转移语句改变你代码的执行顺序，通过它你可以实现代码的跳转。Swift有四种控制转移语句。
         
         continue
         break
         fallthrough
         return
         throw
         */
         
         //如果你确实需要 C 风格的贯穿（fallthrough）的特性，你可以在每个需要该特性的 case 分支中使用fallthrough关键字。
        let integerToDescribe = 5
        var description = "The number \(integerToDescribe) is"
        switch integerToDescribe {
        case 2:
            description += " a x"
            fallthrough //fallthrough关键字不会检查它下一个将会落入执行的 case 中的匹配条件。
        case 2:
            description += " a xxx and"
            fallthrough
        default:
            description += " an integer."
        }
        print(description)
        /**
        *  注意：
        fallthrough关键字不会检查它下一个将会落入执行的 case 中的匹配条件。
        fallthrough简单地使代码执行继续连接到下一个 case 中的执行代码，这和 C 语言标准中的switch语句特性是一样的。
        */


         // MARK: - 带标签的语句（Labeled Statements）
         //在 Swift 中，你可以在循环体和switch代码块中嵌套循环体和switch代码块来创造复杂的控制流结构。
         //该while循环体的条件判断语句是 i < 20, c里的goto也有label
        var i = 0
        labelTest:while i++ < 20 {
            switch i {
            case 5: break labelTest     //这里的break,当i==5的时候就结束 while循环
            default:break;              //这里的break,结束switch 语句
            }
        }
        
       // MARK: - 检测 API 可用性
        
        /**
        Swift 有检查 API 可用性的内置支持，这可以确保我们不会不小心地使用对于当前部署目标不可用的 API。
        */
        
        //最后一个参数，*，是必须写的，用于处理未来潜在的平台。
        if #available(iOS 9, OSX 10.10, *) {
            // 在 iOS 使用 iOS 9 的 API, 在 OS X 使用 OS X v10.10 的 API
        } else {
            // 使用先前版本的 iOS 和 OS X 的 API
        }
        
        
        /**
        在它的一般形式中，可用性条件获取了一系列平台名字和版本。平台名字可以是iOS，OSX或watchOS。
        除了特定的主板本号像 iOS 8，我们可以指定较小的版本号像 iOS 8.3 以及 OS X v10.10.3。
        */
        
    }
    
    // MARK: - 提前退出
    
    /**
    *  像if语句一样，guard的执行取决于一个表达式的布尔值。我们可以使用guard语句来要求条件必须为真时，以执行guard语句后的代码。
    不同于if语句，一个guard语句总是有一个else分句，如果条件不为真则执行else分句中的代码。
    
    
    相比于可以实现同样功能的if语句，按需使用guard语句会提升我们代码的可靠性。 
    它可以使你的代码连贯的被执行而不需要将它包在else块中，它可以使你处理违反要求的代码使其接近要求。
    */
    func greet(person:[String: String]) {
        guard let name = person["name"] else {
            return
        }
        
        print("Hello \(name)")
        
        //在else分支上必须转移控制以退出guard语句出现的代码段。否则编译出错
        //需要return,break,continue或者throw
        guard let location = person["location"] else {
            print("I hope the weather is nice near you.")
            return
        }
        print("I hope the weather is nice in \(location).")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
