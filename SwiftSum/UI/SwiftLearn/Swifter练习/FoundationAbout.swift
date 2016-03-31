//
//  FoundationAbout.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/4/28.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import Foundation

// MARK: - Foundation 框架

//Swift 的基本类型都可以无缝转换到 Foundation 框架中的对应类型。 Swift 与 Foundation 之间的类型转换是自动完成的


//这个转换不仅是自动的，而且是双向的，而且无论何时只要有可能，转换的结果会更倾向于使用 Swift 类型。也就是说，只要你不写明类型是需要 NS 开头的类型的时候，你都会得到一个 Swift 类型。

func stringDemo() {
    //string 在 Swift 中是被推断为 String 类型的
    let string = "/hello/";
    
    //可以直接调用到 NSString 的实例方法 pathComponents。
    let componets = (string as NSString).pathComponents
    
    //pathComponents 返回的应该是一个 NSArray，但是如果我们检查这里的 components 的类型，会发现它是一个 [String]。
    
    //如果我们出于某种原因，确实需要 NSString 以及 NSArray 的话，我们需要显式的转换：
    let compont = (string as NSString).pathComponents as NSArray
    let fileName = compont.firstObject as? NSString
}


// MARK: - STRING 还是 NSSTRING

//尽可能的话还是使用原生的 String 类型。原因如下：
/**
*  
1.现在 Cocoa 所有的 API 都接受和返回 String 类型。我们没有必要也不必给自己凭空添加麻烦去把框架中返回的字符串做一遍转换

2.在 Swift 中 String 是 struct，相比起 NSObject 的 NSString 类来说，更切合字符串的 "不变" 这一特性。另外，在不触及 NSString 特有操作和动态特性的时候，使用 String 的方法，在性能上也会有所提升。

3.因为 String 实现了像 CollectionType 这样的接口，因此有些 Swift 的语法特性只有 String 才能使用，而 NSString 是没有的。一个典型就是 for...in 的枚举

*/


//使用 String 唯一一个比较麻烦的地方在于它和 Range 的配合。NSRange 会被映射成它在 Swift 中且对应 String 的特殊版本：Range<String.Index>。

func stringNSRangeDemo() {
    let levels = "ABCde"
    
    let nsRange = NSMakeRange(1, 3);
    
    // 编译错误
    // 'NSRange' is not convertible to 'Range<String.Index>'
    //levels.stringByReplacingCharactersInRange(nsRange, withString: "aa");
    
    let indexPositon = levels.startIndex.successor()
    let swiftRange = indexPositon..<indexPositon.advancedBy(4)
    levels.stringByReplacingCharactersInRange(swiftRange, withString: "aaa")
    
    //一般来说，我们可能更愿意和基于 Int 的 NSRange 一起工作，而不喜欢使用麻烦的
    (levels as NSString).stringByReplacingCharactersInRange(nsRange, withString: "rrr")
}



