//
//  TypeIntroduction.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/4/1.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import Foundation

// MARK: - 值类型和引用类型

//Swift 的类型分为值类型和引用类型两种，值类型在传递和赋值时将进行复制，而引用类型则只会使用引用对象的一个 "指向"。

//Swift中除了class和闭包为引用类型。 
//其他都是值类型， struct，enum，和所有的内建类型都是值类型，不仅包括了传统意义像 Int，Bool 这些，甚至连 String，Array 以及 Dictionary 都是值类型的。


// MARK: 使用值类型有什么好处

func fun() {
    
    //只在第一句 a 初始化赋值时发生了内存分配，而之后的 b，c 甚至传递到 test 方法内的 arr，和最开始的 a 在物理内存上都是同一个东西。
    let a = [1,2,3]
    let b = a
    let c = b
    
    //而且这个 a 还只在栈空间上，于是这个过程对于数组来说，只发生了指针移动，而完全没有堆内存的分配和释放的问题，这样的运行效率可以说极高。
    test(a)
    
    //值类型被复制的时机是值类型的内容发生改变时，比如下面在 d 中又加入了一个数，此时值复制就是必须的了：
    var d = a
    d.append(12)// 此时 a 和 d 的内存地址不再相同
    
}
func test(arr: [Int]) {
    for i in arr {
        print(i)
    }
}

//虽然将数组和字典设计为值类型最大的考虑是为了线程安全，但是这样的设计在存储的元素或条目数量较少时，给我们带来了另一个优点，那就是非常高效，因为 "一旦赋值就不太会变化" 这种使用情景在 Cocoa 框架中是占有绝大多数的，这有效减少了内存的分配和回收。

//但是在少数情况下，我们显然也可能会在数组或者字典中存储非常多的东西，并且还要对其中的内容进行添加或者删除。在这时，Swift 内建的值类型的容器类型在每次操作时都需要复制一遍，即使是存储的都是引用类型，在复制时我们还是需要存储大量的引用，这个开销就变得不容忽视了。幸好我们还有 Cocoa 中的引用类型的容器类来对应这种情况，那就是 NSMutableArray 和 NSMutableDictionary。

// MARK: - 总结
//在使用数组合字典时的最佳实践应该是，按照具体的数据规模和操作特点来决定到时是使用值类型的容器还是引用类型的容器：在需要处理大量数据并且频繁操作 (增减) 其中元素时，选择 NSMutableArray 和 NSMutableDictionary 会更好，而对于容器内条目小而容器本身数目多的情况，应该使用 Swift 语言内建的 Array 和 Dictionary。
