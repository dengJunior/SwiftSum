//: [Previous](@previous)

import UIKit

// MARK: - 如何在 Swift 中高效地使用 Method Swizzling

/**
 Method Swizzling 在 Objective-C 或其他语言中是一种很有名的技术，用来支持动态方法派发。
 Method Swizzling 通过改变特定 selector（方法）与实际实现之间的映射，在 runtime 时将一个方法的实现替换成其它方法的实现。
 
 Swift 关于方法派发是使用静态方法的，但有些情形可能需要用到 Method Swizzling。

 在 Swift 中对一个来自基本框架（Foundation、UIKit 等）的类使用 Method Swizzling 与 Objective-C 没什么区别。
 */

//继承自基本框架或 Objective-C 桥接类的方式
extension UIViewController {
    /**
     1. 与 Objective-C 的第一个不同之处就是 swizzling 不在 load 方法里执行。
     
     加载一个类的定义时，会调用 load 方法，因此这地方适合执行 Method Swizzling 。
     
     但是 load 方法只在 Objective-C 里有，而且不能在 Swift 里重载，不管怎么试都会报编译错误。接下来执行 swizzle 最好的地方就是 initialize 了，这是调用你的类中第一个方法前的地方。
     
     所有对修改方法执行的操作放在 dispatch_once 中,这是为了确保这个过程只执行一次。
     
     这些都是你要知道的关于继承自基本框架或 Objective-C 桥接类的。如果你要在纯 Swift 类中正确使用 Method Swizzling 的话，就需要将下面这些注意事项记在心上。
     */
    public override static func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // 确保不是子类
        if self !== UIViewController.self {
            return
        }
        
        //在这个例子中，应用中的每个 UIViewController 都会执行额外的操作，而原始的 viewWillAppear 方法会被保护起来不执行，这种情形只能通过 Method Swizzling 来实现。
        
        dispatch_once(&Static.token) {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.newViewWillAppear(_:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    // MARK: - Method Swizzling
    
    func newViewWillAppear(animated: Bool) {
        self.newViewWillAppear(animated)
        if let name = self.nibName {
            print("viewWillAppear: \(name)")
        } else {
            print("viewWillAppear: \(self)")
        }
    }
}



// MARK: - Swift 自定义类中使用 Method Swizzling
/*
 要在 Swift 自定义类中使用 Method Swizzling 有两个必要条件：
 
 1. 包含 swizzle 方法的类需要继承自 NSObject
 2. 需要 swizzle 的方法必须有动态属性（dynamic attribute）
 
 更多关于为什么必须需要这些可以在苹果的[文档](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html#//apple_ref/doc/uid/TP40014216-CH4-XID_38)里查看：
 
 需要动态派发
 
 - 当 @objc 属性将你的 Swift API 暴露给 Objective-C runtime 时，不能确保属性、方法、初始器的动态派发。
    - Swift 编译器可能为了优化你的代码，而绕过 Objective-C runtime。
 
 - 当你指定一个成员变量 为 dynamic 时，访问该变量就总会动态派发了。
    - 因为在变量定义时指定 dynamic 后，会使用 Objective-C runtime 来派发。
 
 动态派发是必须的。但是，你必须使用 dynamic 修饰才能知道在运行时 API 的实现被替换了。
 
 举个例子，你可以在 Objective-C runtime 使用 method_exchangeImplementations 方法来交换两个方法的实现。
 假如 Swift 编译器将方法的实现内联（inline）了或者访问去虚拟化（devirtualize）了，这个交换过来的新的实现就无效了。
 
 说白了，如果你想要替换的方法没有声明为 dynamic 的话，就不能 swizzle。
 */
class TestSwizzling: NSObject {
    dynamic func methodOne() -> Int {
        return 1
    }
    
}

extension TestSwizzling {
    override static func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // 只执行一次
        dispatch_once(&Static.token)
        {
            let originalSelector = #selector(TestSwizzling.methodOne);
            let swizzledSelector = #selector(TestSwizzling.methodTwo);
            
            let originalMethod = class_getInstanceMethod(self, originalSelector);
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
    
    dynamic func methodTwo()->Int{
        // swizzling 后, 该方法就不会递归调用
        return methodTwo()+1
    }
}

var c = TestSwizzling()
print(c.methodOne())  //2
print(c.methodTwo())  //1

/**
 结束语
 
 正如你看到的，在 Swift 中还是可以使用 Method Swizzling 的，只是我的意见是，绝大部分时候不应该出现在实际的产品代码里。如果你想通过 swizzling 快速解决问题的话，那更好的办法就是想出一个更好的架构，重构你的代码。
 */

//: [Next](@next)
