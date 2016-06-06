//
//  MemoryManageDemo.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/3/25.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import Foundation

// MARK: - 内存管理，WEAK 和 UNOWNED

/**
*  Swift 是自动管理内存的，这也就是说，我们不再需要操心内存的申请和分配。当我们通过初始化创建一个对象时，Swift 会替我们管理和分配内存。而释放的原则遵循了自动引用计数 (ARC) 的规则：当一个对象没有引用的时候，其内存将会被自动回收。这套机制从很大程度上简化了我们的编码，我们只需要保证在合适的时候将引用置空 (比如超过作用域，或者手动设为 nil 等)，就可以确保内存使用不出现问题。

但是，所有的自动引用计数机制都有一个从理论上无法绕过的限制，那就是循环引用 (retain cycle) 的情况
*/

class A1 {
    let b: B1
    //在 A 的初始化方法中，我们生成了一个 B 的实例并将其存储在属性中。然后我们又将 A 的实例赋值给了 b.a。这样 a.b 和 b.a 将在初始化的时候形成一个引用循环。
    init() {
        b = B1()
        b.a = self
    }
    deinit {
        print("A deinit")
    }
}

class B1 {
    var a:A1?
    deinit {
         print("B deinit")
    }
}
func circularReference() {
    var obj: A1? = A1()
    obj = nil
    // 内存没有释放
    //在将 obj 设为 nil 之后，我们在代码里再也拿不到对于这个对象的引用了，所以除非是杀掉整个进程，我们已经永远也无法将它释放了。
}

// MARK: - 在 Swift 里防止循环引用

//一般来说我们习惯希望 "被动" 的一方不要去持有 "主动" 的一方。在这里 b.a 里对 A 的实例的持有是由 A 的方法设定的，我们在之后直接使用的也是 A 的实例，因此认为 b 是被动的一方。可以将上面的 class B 的声明改为：
class B2 {
    weak var a:A1? = nil
    deinit {
        print("B deinit")
    }
}

// MARK: - unowned和weak区别
//unowned 设置以后即使它原来引用的内容已经被释放了，它仍然会保持对被已经释放了的对象的一个 "无效的" 引用，它不能是 Optional 值，也不会被指向 nil。
//weak 则友好一些，在引用的内容被释放后，标记为 weak 的成员将会自动地变成 nil (因此被标记为 @weak 的变量一定需要是 Optional 值)。

//关于两者使用的选择，Apple 给我们的建议是如果能够确定在访问时不会已被释放的话，尽量使用 unowned，如果存在被释放的可能，那就选择用 weak。


/**
*  日常工作中一般使用弱引用的最常见的场景有两个：

1设置 delegate 时
2在 self 属性存储为闭包时，其中拥有对 self 引用时
*/

//比如我们有一个负责网络请求的类，它实现了发送请求以及接收请求结果的任务，其中这个结果是通过实现请求类的 protocol 的方式来实现的

@objc protocol RequestHandler {
    optional func requestFinished()
}

class Requesting {
    //以 weak 的方式持有了 delegate，因为网络请求是一个异步过程，很可能会遇到用户不愿意等待而选择放弃的情况。
    weak var delegate: RequestHandler!
    
    func send() {
        // 发送请求
        // 一般来说会将 req 的引用传递给网络框架
    }
    
    //我们其实是无法保证在拿到返回时作为 delegate 的 RequestManager 对象是一定存在的。因此我们使用了 weak 而非 unowned，并在调用前进行了判断。
    func gotResponse() {
        // 请求返回
        //自判断链接
        delegate?.requestFinished?()
    }
}

class RequestManager: RequestHandler {
    @objc func requestFinished() {
        print("请求完成")
    }
    
    func sendRequest() {
        let req = Requesting()
        req.delegate = self
        req.send()
    }
}


// MARK: - 闭包和循环引用

class Person1 {
    let name: String
    
    //printName 是 self 的属性，会被 self 持有
    lazy var printName: ()->() = {
        
        //而它本身又在闭包内持有 self，这导致了 xiao 的 deinit 在自身超过作用域后还是没有被调用，也就是没有被释放。
        print("The name is \(self.name)")
    }
    
    //正确版
    lazy var printName2: ()->() = {
        [weak self] in
        
        //如果我们可以确定在整个过程中 self 不会被释放的话，我们可以将上面的 weak 改为 unowned，这样就不再需要 strongSelf 的判断。
        if let strongSelf = self {
            print("The name is \(strongSelf.name)")
        }
        
    }
    
    //unowned版
    lazy var printName3: ()->() = {
        [unowned self] in
        
        //如果在过程中 self 被释放了而 printName 这个闭包没有被释放的话 (比如 生成 Person 后，某个外部变量持有了 printName，随后这个 Person 对象被释放了，但是 printName 已然存在并可能被调用)，使用 unowned 将造成崩溃。
        print("The name is \(self.name)")
        
    }
    
// MARK:  如果有多个需要标注的元素的话，在同一个中括号内用逗号隔开
        // 标注后
//    { [unowned self, weak someObject] (number: Int) -> Bool in
//            //...
//            return true
//    }
    
    init(personName: String) {
        name = personName
    }
    
    deinit {
        print("Person deinit \(self.name)")
    }
}

func blockRef() {
    let xiao:Person1 = Person1(personName: "xiao")
    xiao.printName()
}



// MARK: - AUTORELEASEPOOL

//autorelease，它会将接受该消息的对象放到一个预先建立的自动释放池 (auto release pool) 中，并在 自动释放池收到 drain 消息时将这些对象的引用计数减一，然后将它们从池子中移除 (这一过程形象地称为“抽干池子”)。

//在 app 中，整个主线程其实是跑在一个自动释放池里的，并且在每个主 Runloop 结束时进行 drain 操作。这是一种必要的延迟释放的方式，因为我们有时候需要确保在方法内部初始化的生成的对象在被返回后别人还能使用，而不是立即被释放掉。

//而在 Swift 项目中，因为有了 @UIApplicationMain，我们不再需要 main 文件和 main 函数，所以原来的整个程序的自动释放池就不存在了。即使我们使用 main.swift 来作为程序的入口时，也是不需要自己再添加自动释放池的。
func autoReleaseDemo() {
    let path = NSBundle.mainBundle().pathForResource("big", ofType: "jpg");
    
    //错误版本
    for _ in 1...1000 {
        //let data = NSData.dataWithContentsOfFile(path, options: nil, error: nil)
        //dataWithContentsOfFile 返回的是 autorelease 的对象，因为我们一直处在循环中，因此它们将一直没有机会被释放。如果数量太多而且数据太大的时候，很容易因为内存不足而崩溃。
        
        NSThread.sleepForTimeInterval(0.5)
    }
    
    //在面对这种情况的时候，正确的处理方法是在其中加入一个自动释放池，这样我们就可以在循环进行到某个特定的时候施放内存，保证不会因为内存不足而导致应用崩溃。
    //Swift 中我们也是能使用 autoreleasepool func autoreleasepool(code: () -> ())
    //正确版本
    for i in 1...1000 {
        
        //这样改动以后，内存分配就没有什么忧虑了：
        autoreleasepool {
            //let data = NSData.dataWithContentsOfFile(path, options: nil, error: nil)
            
            NSThread.sleepForTimeInterval(0.5)
        }
    }
    //这里我们每一次循环都生成了一个自动释放池，虽然可以保证内存使用达到最小，但是释放过于频繁也会带来潜在的性能忧虑。一个折衷的方法是将循环分隔开加入自动释放池，比如每 10 次循环对应一次自动释放，这样能减少带来的性能损失。
    
    
    //其实对于这个特定的例子，我们并不一定需要加入自动释放。在 Swift 中更提倡的是用初始化方法而不是用像上面那样的类方法来生成对象，
    //而且在 Swift 1.1 中，因为加入了可以返回 nil 的初始化方法，像上面例子中那样的工厂方法都已经从 API 中删除了。
    
    //正确版本
    for i in 1...1000 {
        //使用初始化方法的话，我们就不需要面临自动释放的问题了，每次在超过作用域后，自动内存管理都将为我们处理好内存相关的事情。
        _ = NSData(contentsOfFile: path!)
        NSThread.sleepForTimeInterval(0.5)
    }
}







