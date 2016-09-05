//
//  AssertDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

//防御式编程：理解断言 http://www.jianshu.com/p/000a4d94603e

/*
 在防御式驾驶中要建立这样一种思维，那就是你永远也不能确定另一位司机将要做什么。
 这样才能确保在其他人做出危险动作时你也不会受到危害。
 你要承担起保护自己的责任，哪怕是其他司机犯的错误。
 防御式编程的主要思想是：子程序应该不因传入错误数据而被破坏，哪怕是由其他子程序产生的错误数据。
 
 在swift中，断言用assert函数。两个参数和OC中的相同。
 
 public func assert(@autoclosure condition: () -> Bool, @autoclosure _ message: () -> String = default, file: StaticString = #file, line: UInt = #line)
 通过声明可以发现，断言中会记录当前文件和行号，但是这里赋了默认值，所以使用assert时可以省略。
 这里顺带提下代码规范，有些人有时为了方便会把几句代码写在一行。这样写一个潜在的坏处就是如果发生异常，日志中记录了行号。但是因为这一行有几句代码，增加了判断是由具体哪一句代码产生异常。应该避免将几句代码写在一行里。
 */


/**
 ## 断言使用的原则
 ### 用错误处理代码来处理预期会发生的状况，用断言来处理绝不应该发生的状况
 
 错误处理代码用来检查不太可能经常发生的非正常情况，这些情况在写代码时就预料到的，而且在产品代码中也要处理这些情况。
 而断言是用于检查代码中的bug，如果在发生异常的时候触发了断言，采取的措施就不仅仅是对错误做出恰当的反应，而是应该修改源码并重新编译。
 可以把断言理解成一种注释，它说明了这个程序的假定。
 
 
 ### 避免把执行的代码放到断言中
 
 断言的可以在编译器中设置关闭，如果你把一些操作写在断言里，在某些情况下可能编译器会过滤掉这些代码。
 
 NSAssert([self performAction], @"could't perform);
 这样写就很危险，应该这样写：
 
 Bool performed=[self performAction];
 NSAssert(performed, @"could't perform);
 
 ### 高健壮性的代码，先使用断言再处理错误
 
 对于要求高健壮性的代码，可能项目非常庞大，超长的开发周期和很多的开发人员，也可能出现断言被触发但是没有被注意到，这时应该也处理一下触发断言时的错误。
 */



