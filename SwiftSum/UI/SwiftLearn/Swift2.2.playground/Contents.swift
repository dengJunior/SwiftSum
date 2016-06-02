//: Playground - noun: a place where people can play

import UIKit

func indexOf(value: String, in array: [String]) {
    
}

/**
 - [参考链接](http://blog.csdn.net/chaoyang805/article/details/50989789)
 
 
 ## 1.允许（大部分）关键字作为参数标签
 原来的解决冲突的方案如下：
 
	func indexOf(value: String, `in` array: [String])
 
 in需要使用``来告诉编译器
 
 现在提出解决方案：允许使用的关键词除了inout，var,let 参数标签。因为这会影响三个地方的语法，可以直接定义如下：
 
	func indexOf(value: String, in array: [String])
 
 ## 2.元组比较运算符
 
 元组可以使用＝＝  ， ！＝ ，< , <= , > , >=  运算符进行比较
 
 ```
 @warn_unused_result
 public func == <A: Equatable, B: Equatable, C: Equatable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
 return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
 }
 。。。
 ```
 
 ## 3. 元组的splat语法被弃用了
 
 另一个被弃用的特性是Swift自从2010年(对，Swift发布以前)就存在的，它被称作”the tuple splat”，并没有多少人用过它。这也是被弃用的原因之一，虽然主要还是因为这个语法会给阅读代码带来歧义，所以才被弃用。
 
 下面的splat语法的例子：
 
 ```
 func describePerson(name: String, age: Int) {
 print("\(name) is \(age) years old")
 }
 let person = ("Taylor Swift", age: 26)
 describePerson(persion)
 ```
 
 ## 4. 用associatedtype 替换 typealias 关键字相关的类型声明
 
 原来的typealias关键字用于声明两种类型:
 
 1. 类型别名(替代名称为现有类型)
 2. 相关类型(占位符名称类型作为协议的一部分)
 
 但这两种声明是不同的,应该使用不同的关键字。这将强调它们之间的差异,减少周围的一些混乱的使用相关联的类型。所以添加新关键字是associatedtype。
 
 ## 5. ++，--和传统的C风格for循环 被弃用了
 
 下面列出了一些原因，但不是所有：
 
 1. 写++而非+= 1没有显著的节省时间
 2. 虽然一旦你知道了它后用起来很容易，但是++对学习Swift的人来说并没有一个明确的含义，然而+=至少可以理解为”求和并赋值”
 3. C语言风格的for循环，这是++和–用的最多的地方，同样也被Swift弃用了
 
 ```
 记住，创建一个开始比结束值大的range是不对的，虽然你的代码会通过编译，但会在运行时崩溃掉。所以不要这么写：
 
 for i in 10...1 {
 print("\(i) green bottles")
 }
 而是应该写成这样：
 
 for i in (1...10).reverse() {
 print("\(i) green bottles")
 }
 ```
 
 ## 6. var 参数被弃用
 另一个被抛弃的，同样也是有原因的：var参数被弃用是因为它提供的用处微不足道，并且经常和inout搞混。
 
 ## 7. 数组和其他的slice类型现在有removeFirst()函数了
 
 ## 8.重命名了调试标识符：#line，#function，#file
 Swift 2.1和更早的版本使用”screaming snake case”的符号：FILE,LINE,COLUMN和FUNCTION，这些符号出现的地方会被编译器自动替换为文件名，行号，列号和函数名称
 
 在Swift 2.2中，这些旧的符号已经被#file,#line,#column和#function替换掉了。你会相当熟悉如果已经使用了Swift 2.0的#available来检查iOS特性。正如Swift review官方所说的，它也引入了一条出现#意味着会触发编译器的替代逻辑的规则。
 
 ## 9. 字符串化的selector被弃用
 Swift 2.2以前一个不受欢迎的功能是selector可以被写作字符串，像这样：
 
	navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tap!", target: self, action: "buttonTaped")
 
 这个问题在Swift 2.2中解决了：使用字符串作为selector被弃用了，并且你可以在上面的代码中这么写#selector(buttonTapped)，如果buttonTapped方法不存在的话，你会得到一条编译错误，这又是一个需要在类编译前消除的错误。
 
 ## 10. 编译时Swift 版本检查
 
 Swift 2.2 加入了一个新的编译配置项使得用不同版本Swift写的代码联合编译成一个单独文件变得简单。例如：
 
 ```
 #if swift(>=2.2)
 print("Running Swift 2.2 or later")
 #else
 print("Running Swift 2.1 or earlier")
 #endif
 ```
 
 ## 11. 新的文档关键字：recommended，recommended over，和keyword
 Swift支持MarkDown格式的注释来给你的代码添加额外的信息，所以你可以这么写：
 
 ```
 /**
 Say hello to a specific person
 - parameters:
 - name: The name of the person to greet
 - returns: Absolutely nothing
 - authors:
 Paul Hudson
 Bilbo Baggins
 - bug: This is a deeply dull funtion
 */
 ```
 
 在Swift 2.2中，添加了三个新的关键字recommended,recommendedover和keyword.这几个关键字通过让你来指定哪个在Xcode中匹配的属性和方法应该被返回，从而使得代码补全更有用，但是现在看起来还没作用，所以这也只是一种猜测。
 */


