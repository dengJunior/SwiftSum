//: Playground - noun: a place where people can play

import UIKit

/**
 # 聊一聊单子（Monad）
 
 - [参考链接](http://swift.gg/2015/10/30/lets-talk-about-monads/)
 - [原文链接](http://alisoftware.github.io/swift/2015/10/17/lets-talk-about-monads/)
 */



/**
 单子，即 Monad：一个函数式编程的术语
 
 ## 什么是函子（Functors）和单子
 
 map和flatMap对于Array和Optional来说有着相似的作用，甚至连函数签名都十分相似。
 
 实际上这并不是一个特例：很多类型都有类似map和flatMap的方法，而这些方法都有那种类型的签名。这是一种十分常见的模式，这种模式的名字叫做单子。
 
 你可能之前在网上看过单子这个术语(也可能叫做函子)，还看过尝试解释该术语的各种比喻。但是大部分比喻都让它更加复杂难懂。
 
 **事实上，单子和函子是非常简单的概念。**它可以最终归结为：
 
 - 一个函子是一种表示为Type<T>的类型，它：
	- 封装了另一种类型（类似于封装了某个T类型的Array<T>或Optional<T>）
	- 有一个具有(T->U) -> Type<U>签名的map方法
 
 - 一个单子是一种类型，它：
	- 是一个函子（所以它封装了一个T类型，拥有一个map方法）
	- 还有一个具有(T->Type<U>) -> Type<U>签名的flatMap方法
 
 这就是对单子和函子所需要了解的一切！一个单子就是一种带有flatMap方法的类型，一个函子就是一种带有一个map方法的类型。很简单，不是么？
 
 ## 各种类型的单子
 你已经学过两种既是函子又是单子的类型，它们是：Array<T>和Optional<T>。当然，这样的类型还有很多。
 
 实际上这些类型的方法会有其他的名字，不限于map和flatMap。例如一个Promise也是一个单子，而它的相对应的map和flatMap方法叫做then。
 
 仔细看一下Promise<T>的then方法签名，思考一下：它拿到未来返回的值T，进行处理，然后要么返回一个新类型U，要么返回一个封装了这个新类型的、新的Promise<U>… 没错，我们又一次得到了相同的方法签名，所以Promise实际上也是一个单子！
 
 有很多类型都符合单子的定义。比如Result，Signal，… 你还可以想到更多（如果需要的话你甚至可以创建你自己的单子）。
 看出相似性了吗？（为方便对比加了空格）
 
 ```
 // Array, Optional, Promise, Result 都是函子
 anArray     .map( transform: T ->          U  ) ->    Array<U>
 anOptional     .map( transform: T ->          U  ) -> Optional<U>
 aPromise     .then( transform: T ->          U  ) ->  Promise<U>
 aResult     .map( transform: T ->          U  ) ->   Result<U>
 
 // Array, Optional, Promise, Result 都是单子
 anArray .flatMap( transform: T ->    Array<U> ) ->    Array<U>
 anOptional .flatMap( transform: T -> Optional<U> ) -> Optional<U>
 aPromise    .then( transform: T ->  Promise<U> ) ->  Promise<U>
 aResult .flatMap( transform: T ->   Result<U> ) ->   Result<U>
 ```
 
 ## 把map()和flatMap()级联起来
 通常你还可以把这两个方法级联，这会使它们更加强大。
 
 例如，最开始你有一个Array<T>，通过使用map来对它做转换操作，得到一个Array<U>，然后对这个Array<U>再级联上一个map，对它做另一个转换操作将其转换成一个Array<Z>，等等。
 
 这会让你的代码看起来就像是在生产线上一样：把一个初始值拿来，让他经过一系列的黑盒子处理，然后得到一个最终的结果。这时你就可以说你实际上是在做函数式编程了！
 */

/**
 下面是一个示范如何将map和flatMap的调用级联起来去做多次转换的例子。我们从一个字符串开始，把它按单词分开，然后依次做如下转换：
 
 1. 统计每个单词的字符个数，做计数
 2. 把每个计数转换成一个相对应的单词
 3. 给每个结果加个后缀
 4. 对每个字符串结果做%转义
 5. 把每个字符串结果转换成一个NSURL
 */

let formatter = NSNumberFormatter()
formatter.numberStyle = .SpellOutStyle
let string = "This is Functional Programming"
let translateUrls = string
    // Split the characters into words
    .characters.split(" ")
    // Count the number of characters on each word
    .map{ $0.count }
    .flatMap{ (n: Int) -> String? in formatter.stringFromNumber(n) }
    // add " letters" suffix
    .map{ "\($0) letters" }
    .flatMap{ $0.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet()) }
    .flatMap{ NSURL(string: "https://translate.google.com/#auto/fr/\($0)") }

/**
 [
     https://translate.google.com/#auto/fr/four%20letters,
     https://translate.google.com/#auto/fr/two%20letters,
     https://translate.google.com/#auto/fr/ten%20letters,
     https://translate.google.com/#auto/fr/eleven%20letters
 ]
 */
print(translateUrls)

/**
 上面这段代码可能需要你研究一会儿，尝试去理解每一个中间阶段的map和flatMap的签名是什么，并搞清楚每一步都发生了什么事。
 
 但无论如何，你能看出来对于描述一系列处理流程来说，这是一种很好的方式。这种方式可以被看做是一条生产线，从原材料开始，然后对它做多种转换，最终在生产线的尽头拿到成品。
 */


 /*
 ## 结论
 尽管看起来很吓人，但monad很简单。
 
 但实际上，你怎么叫它们都没关系。只要你知道如果你想把一种封装类型转换成另一种，而某些类型的map和flatMap方法着实能帮到你，这就够了。
 */
