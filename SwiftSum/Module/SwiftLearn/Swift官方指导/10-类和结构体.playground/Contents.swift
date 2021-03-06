//: Playground - noun: a place where people can play

import Cocoa

/*
本页包含内容：
    
    - 类和结构体对比
    - 结构体和枚举是值类型
    - 类是引用类型
    - 类和结构体的选择
    - 字符串(String)、数组(Array)、和字典(Dictionary)类型的赋值与复制行为
*/
// MARK: - ## 类和结构体对比

/*
Swift 中类和结构体有很多共同点。共同处在于：

- 定义属性用于存储值
- 定义方法用于提供功能
- 定义附属脚本用于访问值
- 定义构造器用于生成初始化值
- 通过扩展以增加默认实现的功能
- 实现协议以提供某种标准功能

与结构体相比，类还有如下的附加功能：

- 继承允许一个类继承另一个类的特征
- 类型转换允许在运行时检查和解释一个类实例的类型
- 析构器允许一个类实例释放任何其所被分配的资源
- 引用计数允许对一个类的多次引用

>注意
结构体总是通过被复制的方式在代码中传递，不使用引用计数。
*/

// MARK: - ### 定义语法

// MARK: - ### 类和结构体实例

//结构体和类都使用构造器语法来生成新的实例。

// MARK: - ### 属性访问

//通过使用点语法（dot syntax），你可以访问实例的属性。

//>注意
//与 Objective-C 语言不同的是，Swift 允许直接设置结构体属性的子属性。上面的最后一个例子，就是直接设置了someVideoMode中resolution属性的width这个子属性，以上操作并不需要重新为整个resolution属性设置新值。

// MARK: - ### 结构体类型的成员逐一构造器（Memberwise Initializers for Structure Types）
    
//所有结构体都有一个自动生成的成员逐一构造器，用于初始化新结构体实例中成员的属性。

//let vga = Resolution(width:640, height: 480)

//与结构体不同，类实例没有默认的成员逐一构造器。

// MARK: - ## 结构体和枚举是值类型

//值类型被赋予给一个变量、常量或者被传递给一个函数的时候，其值会被拷贝。

//<mark>在 Swift 中，所有的基本类型：整数（Integer）、浮点数（floating-point）、布尔值（Boolean）、字符串（string)、数组（array）和字典（dictionary），都是值类型，并且在底层都是以结构体的形式所实现。

//在 Swift 中，所有的结构体和枚举类型都是值类型。

// MARK: - ## 类是引用类型

//与值类型不同，引用类型在被赋予到一个变量、常量或者被传递到一个函数时，其值不会被拷贝。因此，引用的是已存在的实例本身而不是其拷贝。

// MARK: - ### 恒等运算符

//因为类是引用类型，有可能有多个常量和变量在幕后同时引用同一个类实例。

//Swift 内建了两个恒等运算符：等价于（===） 不等价于（!==）

//运用这两个运算符检测两个常量或者变量是否引用同一个实例：

/*
- “===等价于”表示两个类类型（class type）的常量或者变量引用同一个类实例。
- “==等于”表示两个实例的值“相等”或“相同”，判定时要遵照设计者定义的评判标准，因此相对于“相等”来说，这是一种更加合适的叫法。
*/
// MARK: - ### 指针

//如果你有 C，C++ 或者 Objective-C 语言的经验，那么你也许会知道这些语言使用指针来引用内存中的地址。

//<mark>Swift中一个引用某个引用类型实例的常量或者变量，与 C 语言中的指针类似，但是并不直接指向某个内存地址，也不要求你使用星号（*）来表明你在创建一个引用。Swift 中的这些引用与其它的常量或变量的定义方式相同。

// MARK: - ## 字符串(String)、数组(Array)、和字典(Dictionary)类型的赋值与复制行为

//Swift 中，许多基本类型，诸如String，Array和Dictionary类型均以结构体的形式实现。这意味着被赋值给新的常量或变量，或者被传入函数或方法中时，它们的值会被拷贝。

//Objective-C 中NSString，NSArray和NSDictionary类型均以类的形式实现，而并非结构体。它们在被赋值或者被传入函数或方法时，不会发生值拷贝，而是传递现有实例的引用。

//>注意
//以上是对字符串、数组、字典的“拷贝”行为的描述。在你的代码中，拷贝行为看起来似乎总会发生。然而，Swift 在幕后只在绝对必要时才执行实际的拷贝。Swift 管理所有的值拷贝以确保性能最优化，所以你没必要去回避赋值来保证性能最优化。
