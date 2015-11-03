//
//  TheBasicsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class TheBasicsDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - 声明常量和变量
    
    /**
    常量和变量必须在使用前声明，用let来声明常量，用var来声明变量。
    */
    func variableDemo() {
        let maximumNumberOfLoginAttempts = 10
        var currentLoginAttempt = 0
        var x = 0.0, y = 0.0, z = 0.0
        
        // MARK: - 类型标注
        
        /**
        当你声明常量或者变量的时候可以加上类型标注（type annotation），
        说明常量或者变量中要存储的值的类型。
        如果要添加类型标注，需要在常量或者变量名后面加上一个冒号和空格，然后加上类型名称。
        */
        
        //这个例子给welcomeMessage变量添加了类型标注，表示这个变量可以存储String类型的值：
        var welcomeMessage: String
        welcomeMessage = "hello"
        /*
        一般来说你很少需要写类型标注。如果你在声明常量或者变量的时候赋了一个初始值，
        Swift可以推断出这个常量或者变量的类型，请参考类型安全和类型推断。
        */
        
        
        // MARK: - 常量和变量的命名
        //你可以用任何你喜欢的字符作为常量和变量名，包括 Unicode 字符：
        let π = 3.14159
        let 你好 = "你好世界"
        let 🐶🐮 = "dogcow"
        
        
        // MARK: - 输出常量和变量
        //你可以用print(_:separator:terminator:)函数来输出当前常量或变量的值:
        print(welcomeMessage)
        
        /**
        如果你用 Xcode，println将会输出内容到“console”面板上。
        (另一种函数叫print，唯一区别是在输出内容最后不会换行。)
        */
        print(welcomeMessage);
        
        /**
        *  Swift 用字符串插值（string interpolation）的方式把常量名或者变量名当做占位符加入到长字符串中，
        Swift 会用当前常量或变量的值替换这些占位符。
        将常量或变量名放入圆括号中，并在开括号前使用反斜杠将其转义：
        */
        print("hi polly \(welcomeMessage)")
    }
    
    
    func numberDemo() {
        // MARK: - 整数
        /**
        *  Swift 提供了8，16，32和64位的有符号和无符号整数类型。
        这些整数类型和 C 语言的命名方式很像，比如8位无符号整数类型是UInt8，32位有符号整数类型是Int32。
        就像 Swift 的其他类型一样，整数类型采用大写命名法。
        */
        let minVale = UInt8.min
        let minVale2 = Int8.min
        let maxVale = UInt32.max
        
        /**
        *  Int
        一般来说，你不需要专门指定整数的长度。Swift 提供了一个特殊的整数类型Int，长度与当前平台的原生字长相同：
        
        在32位平台上，Int和Int32长度相同。
        在64位平台上，Int和Int64长度相同。
        同理 UInt
        */

         // MARK: - 浮点数
         /**
         Swift 提供了两种有符号浮点数类型：
         Double表示64位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
         Float表示32位浮点数。精度要求不高的话可以使用此类型。
         注意：
         Double精确度很高，至少有15位数字，而Float最少只有6位数字。
         选择哪个类型取决于你的代码需要处理的值的范围。
         */
        let float1 = Float.abs(1.2)
        
        
        // MARK: - 类型安全和类型推断
        /**
        *  Swift 是一个类型安全（type safe）的语言。类型安全的语言可以让你清楚地知道代码要处理的值的类型。
        如果你的代码需要一个String，你绝对不可能不小心传进去一个Int。
        
        由于 Swift 是类型安全的，所以它会在编译你的代码时进行类型检查（type checks），
        并把不匹配的类型标记为错误。这可以让你在开发的时候尽早发现并修复错误。
        */
        let pi = 3.14159
        // pi 会被推测为 Double 类型
        //当推断浮点数的类型时，Swift 总是会选择Double而不是Float。
        
        //如果表达式中同时出现了整数和浮点数，会被推断为Double类型：
        let anotherPi = 3 + 0.14159
        // anotherPi 会被推测为 Double 类型
        
        
        // MARK: - 数值型字面量
        
        let decimalInteger = 17         //一个十进制数，没有前缀
        let binaryInteger = 0b10001     // 二进制的17,前缀是0b
        let octalInteger = 0o21         // 八进制的17,前缀是0o
        let hexadecimalInteger = 0x11   // 十六进制的17,前缀是0x
        
        let decimalDouble = 12.1875
        let exponentDouble = 1.21875e1  //通过大写或者小写的e来指定
        //1.25e2 表示 1.25 × 10^2，等于 125.0。   1.25e-2 表示 1.25 × 10^-2，等于 0.0125。
        
        let hexadecimalDouble = 0xC.3p0 //在十六进制浮点数中通过大写或者小写的p来指定
        //0xFp2 表示 15 × 2^2，等于 60.0。        0xFp-2 表示 15 × 2^-2，等于 3.75。
        
        /*
        数值类字面量可以包括额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量：
        */
        let paddedDouble = 000123.456
        let oneMillion = 1_000_000
        let justOverOneMillion = 1_000_000.000_000_1
        
        
        
        
        // MARK: - 数值型类型转换
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        let twoThousandAndOne = twoThousand + UInt16(one)
        
        
        //整数和浮点数的转换必须显式指定类型：
        
        let three = 3
        let pointOneFourOneFiveNine = 0.14159
        let pii = Double(three) + pointOneFourOneFiveNine
        // pii 等于 3.14159，所以被推测为 Double 类型
        //这个例子中，常量three的值被用来创建一个Double类型的值，所以加号两边的数类型须相同。如果不进行转换，两者无法相加。
        
        //浮点数到整数的反向转换同样行，整数类型可以用Double或者Float类型来初始化：
        let integerPi = Int(pi)
        // integerPi 等于 3，所以被推测为 Int 类型
        //当用这种方式来初始化一个新的整数值时，浮点值会被截断。也就是说4.75会变成4，-3.9会变成-3。
        
        //注意：
        //结合数字类常量和变量不同于结合数字类字面量。字面量3可以直接和字面量0.14159相加，因为数字字面量本身没有明确的类型。
        //它们的类型只在编译器需要求值的时候被推测。
        
        
        
        // MARK: - 类型别名
        //当你想要给现有类型起一个更有意义的名字时，类型别名非常有用。假设你正在处理特定长度的外部资源的数据：
        typealias Age = UInt8
        
        //定义了一个类型别名之后，你可以在任何使用原始名的地方使用别名：
        let age:Age = Age.max


        // MARK: - 布尔值
        
        //Swift 有两个布尔常量，true和false：
        let orangesAreOrange = true
        var turnipsAreDelicious = false
        
        //turnipsAreDelicious = 2  报错,同理 if 判断的时候
        
        if orangesAreOrange {
            print("Mmm, tasty turnips!")
        }

        
        // MARK: - 元组
        
        //元组（tuples）把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。类似oc中的array
        let http404Error = (404, "Not Found")
        // http404Error 的类型是 (Int, String)，值是 (404, "Not Found")
        
        //你可以将一个元组的内容分解（decompose）成单独的常量和变量，然后你就可以正常使用它们了：
        let (statusCode, statusMessage) = http404Error
        print("The status code is \(statusCode)")
        
        //如果你只需要一部分元组值，分解的时候可以把要忽略的部分用下划线（_）标记：
        let (_, message) = http404Error
        print("The message is \(message)")
        
        //还可以通过下标来访问元组中的单个元素，下标从零开始：
        http404Error.0
        
        //可以在定义元组的时候给单个元素命名：
        let http2005 = (statusCode:2005, desc:"http2005")
        //给元组中的元素命名后，你可以通过名字来获取这些元素的值：
        http2005.statusCode
        
        //作为函数返回值时，元组非常有用。
        //注意：元组在临时组织值的时候很有用，但是并不适合创建复杂的数据结构。
    }
}














































