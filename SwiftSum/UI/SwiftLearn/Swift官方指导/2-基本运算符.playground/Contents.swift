//: Playground - noun: a place where people can play

import UIKit


// MARK: - 赋值运算符

//与 C 语言和 Objective-C 不同，Swift 的赋值操作并不返回任何值。所以以下代码是错误的：

//if x = y {
//    // 此句错误, 因为 x = y 并不返回任何值
//}


// MARK: -  算术运算符

//与 C 语言和 Objective-C 不同的是，Swift 默认情况下不允许在数值运算中出现溢出情况。但是你可以使用 Swift 的溢出运算符来实现溢出运算（如 a &+ b）。

//加法运算符也可用于 String 的拼接：

let add = "hello, " + "world"  // 等于 "hello, world"

// MARK: -  求余运算符

//在对负数 b 求余时，b 的符号会被忽略。这意味着 a % b 和 a % -b 的结果是相同的。

let yu = 9 % -4 // 1

// MARK: - 浮点数求余计算

let yu2 = 8 % 2.5   // 等于 0.5
//这个例子中，8 除以 2.5 等于 3 余 0.5，所以结果是一个 Double 型的值为 0.5。

// MARK: -  自增和自减运算

//一样

// MARK: -  一元负号运算符

//一样

// MARK: -  组合赋值运算符

//复合赋值运算没有返回值 ‌

// MARK: -  比较运算符（Comparison Operators）

//Swift 也提供恒等（===）和不恒等（!==）这两个比较符来判断两个对象是否引用同一个对象实例。更多细节在类与结构。

// MARK: - 元组比较

//当元组中的值可以比较时，你也可以使用这些运算符来比较它们的大小。例如，因为 Int 和 String 类型的值可以比较，所以类型为 (Int, String) 的元组也可以被比较。<mark>相反，Bool 不能被比较，也意味着存有布尔类型的元组不能被比较。

//比较元组大小会按照从左到右、逐值比较的方式，直到发现有两个值不等时停止。如果所有的值都相等，那么这一对元组我们就称它们是相等的。例如：

(1, "zebra") < (2, "apple")   // true，因为 1 小于 2
(3, "apple") < (3, "bird")    // true，因为 3 等于 3，但是 apple 小于 bird
(4, "dog") == (4, "dog")      // true，因为 4 等于 4，dog 等于 dog

//>注意： Swift 标准库只能比较七个以内元素的元组比较函数。如果你的元组元素超过七个时，你需要自己实现比较运算符。

// MARK: -  三目运算符（Ternary Conditional Operator）

//一样

// MARK: -  空合运算符（Nil Coalescing Operator）

//空合运算符（a ?? b）将对可选类型 a 进行空判断，如果 a 包含一个值就进行解封，否则就返回一个默认值 b。

//表达式 a 必须是 Optional 类型。<mark>默认值 b 的类型必须要和 a 存储值的类型保持一致。

//空合运算符是对以下代码的简短表达方法：a != nil ? a! : b

//>注意： 如果 a 为非空值（non-nil），那么值 b 将不会被计算。这也就是所谓的短路求值。

// MARK: -  区间运算符（Range Operators）

// MARK: - # 闭区间运算符‌

for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}

// MARK: - # 半开区间运算符


// MARK: -  逻辑运算（Logical Operators）

//- 逻辑非（!a）
//- 逻辑与（a && b）
//- 逻辑或（a || b）
//
//>注意： Swift 逻辑操作符 && 和 || 是左结合的，这意味着拥有多元逻辑操作符的复合表达式优先计算最左边的子表达式。

// MARK: -  使用括号来明确优先级

//一样

