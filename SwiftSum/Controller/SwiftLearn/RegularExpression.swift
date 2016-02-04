//
//  RegularExpression.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/3/25.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import Foundation


// MARK: - 正则表达式

// Swift 至今为止并没有在语言层面上支持正则表达式。

//我们是否能像其他语言一样，使用比如 =~ 这样的符号来进行正则匹配呢？

//最容易想到也是最容易实现的当然是自定义 =~ 这个运算符。在 Cocoa 中我们可以使用 NSRegularExpression 来做正则匹配

//先写一个接受正则表达式的字符串，以此生成 NSRegularExpression 对象。然后使用该对象来匹配输入字符串，并返回结果告诉调用者匹配是否成功。

struct RegexHelper {
    let regex: NSRegularExpression!
    
    init(_ pattern: String) {
        var error: NSError?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        } catch let error1 as NSError {
            error = error1
            regex = nil
        }
    }
    
    func match(input: String) ->Bool{
        if let matches = regex?.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.utf16.count)) {
                return matches.count > 0
        } else {
            return false
        }
    }
}

func regexHelperDemo() {
    let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    let matcher = RegexHelper(mailPattern)
    let maybeMail = "abc@163.com"
    
    if matcher.match(maybeMail) {
        print("有效的邮箱地址")
    }
    
    //这下我们就可以使用类似于其他语言的正则匹配的方法了：
    if "onev@onevcat.com" =~
        "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
            print("有效的邮箱地址")
    }
    // 输出:
    // 有效的邮箱地址
}

//现在我们有了方便的封装，接下来就让我们实现 =~ 吧。

infix operator =~ {
associativity none
precedence 130
}

func =~(lhs: String, rhs: String) -> Bool {
    return RegexHelper(rhs).match(lhs)
}


// MARK: - 模式匹配
//一个和正则匹配有些相似的特性其实是内置于 Swift 中的，那就是模式匹配。

/**
如果我们看看 API 的话，可以看到这个操作符有下面几种版本：

func ~=<T : Equatable>(a: T, b: T) -> Bool

func ~=<T>(lhs: _OptionalNilComparisonType, rhs: T?) -> Bool

func ~=<I : IntervalType>(pattern: I, value: I.Bound) -> Bool
*/

// MARK:  Swift 的 switch 就是使用了 ~= 操作符进行模式匹配，
//case 指定的模式作为左参数输入，而等待匹配的被 switch 的元素作为操作符的右侧参数。只不过这个调用是由 Swift 隐式地完成的。
func switchDemo() {
    
    //1.可以判等的类型的判断
    let pwd = "pwd"
    switch pwd {
        case "pwd": print("密码通过")
        default:        print("验证失败")
    }
    
    //2.对 Optional 的判断
    let num: Int? = nil
    switch num {
    case nil: print("没值")
    default:  print("\(num!)")
    }
    
    //3.对范围的判断
    let x = 0.5
    switch x {
    case -1.0...1.0: print("区间内")
    default: print("区间外")
    }
}


//在 switch 中做 case 判断的时候，我们完全可以使用我们自定义的模式匹配方法来进行判断，有时候这会让代码变得非常简洁，具有条例。

func ~=(pattern: NSRegularExpression, input: String) -> Bool {
    return pattern.numberOfMatchesInString(input,
        options: [],
        range: NSRange(location: 0, length: input.characters.count)) > 0
}

//再添加一个将字符串转换为 NSRegularExpression 的操作符
prefix operator ~/ {}

prefix func ~/(pattern: String) -> NSRegularExpression {
    return try! NSRegularExpression(pattern: pattern, options: [])
}

func pattenDemo() {
    let contact = ("http://onevcat.com", "onev@onevcat.com")
    let mailRegex =
    ~/"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    let siteRegex =
    ~/"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
    
    switch contact {
    case (siteRegex, mailRegex): print("同时拥有有效的网站和邮箱")
    case (_, mailRegex): print("只拥有有效的邮箱")
    case (siteRegex, _): print("只拥有有效的网站")
    default: print("嘛都没有")
    }
    
    // 输出
    // 同时拥有网站和邮箱
}



















