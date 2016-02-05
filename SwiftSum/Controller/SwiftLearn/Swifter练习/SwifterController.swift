//
//  SwifterController.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/3/18.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import UIKit



class SwifterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0...10 {
            print(randomInRange(1...10))
        }
    }

    // MARK: - 随机数生成
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        
        //arc4random_uniform改良版本接受一个 UInt32 的数字 n 作为输入，将结果归一化到 0 到 n - 1 之间。
        return Int(arc4random_uniform(count)) + range.startIndex
    }
    
    
    // MARK: - 条件编译
    /**
    *  #if <condition>
    
    #elseif <condition>
    
    是这几个表达式里的 condition 并不是任意的。Swift 内建了几种平台和架构的组合，来帮助我们为不同的平台编译不同的代码，具体地：
    
    方法 os()，可选参数 OSX, iOS
    方法 arch()，可选参数 x86_64, arm, arm64, i386
    
    #else
    
    #endif
    */
    
    #if os(OSX)
    typealias Color = UIColor
    #endif
    
    //另一种方式是对自定义的符号进行条件编译，比如我们需要使用同一个 target 完成同一个 app 的收费版和免费版两个版本，并且希望在点击某个按钮时收费版本执行功能，而免费版本弹出提示的话，可以使用类似下面的方法：
    #if FREE_VERSION
    #else
    #endif
    //在这里我们用 FREE_VERSION 这个编译符号来代表免费版本。为了使之有效，我们需要在项目的编译选项中进行设置，在项目的 Build Settings 中，找到 Swift Compiler - Custom Flags，并在其中的 Other Swift Flags 加上 -D FREE_VERSION 就可以了。
    
    
    // TODO:
    // FIXME:
    
    // MARK: - 可变参数函数
    
    //一个比较恼人的限制是可变参数都必须是同一种类型的
    func sum(input: Int...) -> Int {
        return input.reduce(0, combine: +)
    }
    //当我们想要同时传入多个类型的参数时就需要做一些变通。比如最开始提到的 -stringWithFormat: 方法。可变参数列表的第一个元素是等待格式化的字符串，在 Swift 中这会对应一个 String 类型，而剩下的参数应该可以是对应格式化标准的任意类型。一种解决方法是使用 Any 作为参数类型，然后对接收到的数组的首个元素进行特殊处理。不过因为 Swift 提供了使用下划线 _ 来作为参数的外部标签，来使调用时不再需要加上参数名字。我们可以利用这个特性，在声明方法是就指定第一个参数为一个字符串，然后跟一个匿名的参数列表，这样在写起来的时候就 "好像" 是所有参数都是在同一个参数列表中进行的处理，会好看很多。比如 Swift 的 NSString 格式化的声明就是这样处理的：
    
}

extension NSString {
    //convenience init(format: NSString, _ args: CVarArgType...)
}
let name = "Tom"
let date = NSDate()
let string = NSString(format: "Hello %@. Date: %@", name, date)




















