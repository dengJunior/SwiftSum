//: Playground - noun: a place where people can play

import Cocoa


// MARK: - 函数式反应型编程 (Functional Reactive Programming ， 缩写为 FRP)

// MARK: - 函数式 - Functional

/**
*  函数式编程是一种编程范型，也就是指导如何编写程序的方法论。
它强调函数必须被当成第一等公民对待，将电脑运算视为数学上的函数计算，
并且避免使用程序状态以及易变对象。
*/
//例如 +1 这样一个简单的操作，传统的做法是这样的：
var foo = 0;
func increment() {
    foo++
}

//函数式的写法是这样的：
func increment(foo: Int) -> Int {
    return foo + 1;
}
//从这个例子中可以看到，函数式编程不依赖于外部的数据，而且也不修改外部数据的值，而是返回一个运算之后的新值


// MARK: - 函数式的特性
/**
*  1.函数是第一等公民
所谓 第一等公民 (first class) ，指的是函数与其他数据类型一样，处于平等地位。
既可以赋值给其他变量，也可以作为参数传入另一个函数，或者作为别的函数的返回值。
*/

//比如我们可以用 map 将数组通过指定的函数映射成另一个数组：
let increments = { return $0 + 1 }
print([1,2,3].map(increments))
/**
*  这里的 increment 便是作为一个函数传入的。这个技术可以让你的函数就像变量一样来使用。
也就是说，你的函数可以像变量一样被创建、修改、传递，返回或是在函数中嵌套其他函数。
*/

/**
*  特性2：数据是不可变的
函数式语言里面的数据是不可修改的，只会返回新的值。
这使得多个线程可以在不用锁的情况下并发地访问数据，因为数据本身并不会发生变化。
*/


/**
*  特性3：函数没有副作用

副作用指的是函数内部与外部互动，产生了函数运算以外的其他结果。
最典型的情况，就是修改全局变量的值：

函数式编程强调函数运算没有副作用，意味着函数要保持独立。
函数的所有功能就是返回一个新值，没有其他行为，尤其是不得修改外部变量的值。
*/
var fo = 0
func add() {
    fo++
}


/**
*  特性4：函数具有确定性

函数的运行不依赖于外部变量和系统状态，只依赖于输入的参数。
任何时候只要输入的参数相同，函数返回的新值总是相同的。
*/

//不确定性的函数示例：
foo = 3
var i = 0
func increment2(value: Int) -> Int {
    return value + i
}

i = 1
increment2(foo)    // 4
i = 2
increment2(foo)    // 5
//可以看到，不确定性函数的运行结果往往与系统状态有关，不同的状态之下，返回值是不一样的。


//确定性的函数示例：
foo = 3
func increment2(value: Int, step: Int) -> Int {
    return value + step;
}
increment2(foo, step: 1)//4
increment2(foo, step: 2)//5
//函数的确定性有利于我们观察和理解程序的行为，因为它所依赖的东西只有参数本身。


// MARK: - 函数式的函数
/**
在函数式编程中，有些函数是抬头不见低头见的常客。在合适的时机利用合适的函数，可以有效地缩短代码，并且让代码更可读。在这里我们提前了解一下他们。
*/

/**
*  1.map
map 可以把一个数组按照一定的规则转换成另一个数组，定义如下：
func map<U>(transform: (T) -> U) -> U[]
下面的表达式更有助于理解：
[ x1, x2, ... , xn].map(f) -> [f(x1), f(x2), ... , f(xn)]
*/
let oldArray = [10, 20, 45, 32]
var newArray = oldArray.map({money in "$\(money)"})
print(newArray)
//如果你觉得 money in 也有点多余的话可以用 $0 ：
newArray = oldArray.map({"\($0)€"})


/**
*  2.filter

方法如其名， filter 起到的就是筛选的功能，参数是一个用来判断是否筛除的筛选闭包，定义如下：
func filter(includeElement: (T) -> Bool) -> [T]
*/
var filteredArray : Array<Int> = []
for money in oldArray {
    if (money > 30) {
        filteredArray += [money]
    }
}
print(filteredArray) // [45, 32]

//用 filter 可以这样实现：
filteredArray = oldArray.filter({
    return $0 > 30
});
print(filteredArray)


/**
*  3.reduce
reduce 函数解决了把数组中的值整合到某个独立对象的问题。定义如下：
func reduce<U>(initial: U, combine: (U, T) -> U) -> U
*/
var sum = oldArray.reduce(0, combine: {$0 + $1})//// 0+10+20+45+32 = 107
sum = oldArray.reduce(5, combine: {$0 * $1})// 5*10*20*45*32 = 1440000
sum = oldArray.reduce(0, combine: +)// 0+10+20+45+32 = 107
print(sum)


// MARK: - 函数式和指令式的比较
/**
对于开发者们来说，大家最熟悉的编程范例之一应该是指令式编程。
指令式编程是一种描述计算机所需作出的行为的编程范型。
*/

//需要将数组中的元素乘以2，然后取出大于10的结果。
let source = [1, 3, 5, 7, 9]
var result = [Int]()
for i in source {
    let timesTwo = i * 2
    if timesTwo > 10 {
        result.append(timesTwo)
    }
}
print(result)  // [14, 18]

//函数式编程的写法如下：
result = source
    .map{ $0 * 2 }
    .filter{ $0 > 10 }

/**
 *  在指令式编程里，我们给计算机下发了如下指令：
 
 遍历数组中的所有元素
 在遍历中取出元素并乘以2
 比较一下看看是否大于10
 如果大于10则将它存到 result 数组中
 */
 
 /**
 *  在函数式编程中，我们则是这样解决问题：
 
 将数组元素中的每个元素乘以2
 在结果中选出大于10的元素
 */
 
 /**
 *  指令式编程通过下达指令完成任务，侧重于具体流程以及状态变化；
 而函数式编程则专注于结果，以及为了得到结果需要做哪些转换。
 */

// MARK: - 反应型 - Reactive

/**
*  在日常开发中，我们经常需要监听某个属性，并且针对该属性的变化做一些处理。比如以下几个场景：

- 用户在输入邮箱的时候，监测输入的内容并在界面上提示是否符合邮箱规范。
- 用户在修改用户名之后，所有显示用户名的界面都要改为新的用户名。

外部输入信号的变化、事件的发生，这些都是典型的外部环境变化。
根据外部环境的变化进行响应处理，直观上来讲像是一种自然地反应。
我们可以将这种自动对变化作出响应的能力称为反应能力 (Reactive) 。

那么什么是反应型编程呢？

Reactive programming is programming with asynchronous data streams.
反应型编程是异步数据流的编程。
对于移动端来说，异步数据流的概念并不陌生，变量、点击事件、属性、缓存，这些就可以成为数据流。
*/

/**
*  我们可以通过一些简单的 ASCII 字符来演示如何将事件转换成数据流：

--a---b-c---d---X---|-->

a, b, c, d 是具体的值，代表了某个事件
X 表示发生了一个错误
| 是这个流已经结束了的标记
----------> 是时间轴


比如我们要统计用户点击鼠标的次数，那么可以这样：

clickStream: ---c----c--c----c------c-->
vvvvv map(c becomes 1) vvvv
---1----1--1----1------1-->
vvvvvvvvv scan(+) vvvvvvvvv
counterStream: ---1----2--3----4------5-->

反应型编程就是基于这些数据流的编程。而函数式编程则相当于提供了一个工具箱，可以方便的对数据流进行合并、创建和过滤等操作。

*/

// MARK: - Swift

/**
*  Swift 本身并不是一门函数式语言，不过它有一些函数式的方法和特性，这让人不禁产生了使用 Swift 进行函数式编程的遐想。

和 Objective-C 相比， Swift 更接近于函数式，它支持以下特性：
-map reduce 等函数式函数
-函数是一等公民
-模式匹配

但是和真正的函数式语言相比， Swift 还差很多：
-没有 flatmap（现在有了）
-无法迅速取出 head 和 tail
-没有 foldLeft
…
*/


















