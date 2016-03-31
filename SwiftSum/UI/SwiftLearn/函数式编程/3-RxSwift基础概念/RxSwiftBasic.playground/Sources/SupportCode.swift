
import Foundation

import RxSwift

/*:
### SupportCode

在进入正题之前，先看下项目里的 SupportCode.swift ，主要为 playground 提供了便利函数。

example 函数，专门用来写示例代码的，统一输出 log 便于标记浏览，同时还能保持变量不污染全局
*/
public func example(description: String, action: () -> ()) {
    print("\n---\(description) example ---")
    action()
    
}


/*:
delay 函数，通过 dispatch_after 用来演示延时的：
*/
public func delay(delay:Double, closure:() -> ()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

/*:
writeSequeceToConsole 用于输出数据
*/
public func writeSequeceToConsole<O: ObservableType>(name: String, sequence: O)  -> Disposable {
    return sequence.subscribe { e in
        print("Subscription: \(name), event: \(e)")
    }
}

