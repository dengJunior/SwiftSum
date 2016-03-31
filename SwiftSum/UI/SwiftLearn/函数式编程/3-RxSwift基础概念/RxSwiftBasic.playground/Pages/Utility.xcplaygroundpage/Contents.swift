//: [Previous](@previous)

import Foundation

/*:
### Utility

这里列举了针对事件序列的一些方法。
*/

/*:
#### subscribe

subscribe 在前面已经接触过了，有新的事件就会触发。
*/
example("subscribe") { () -> () in
    let sequenceOfInts = PublishSubject<Int>()
    _ = sequenceOfInts
        .subscribe {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
    /**
    ---subscribe example ---
    Next(1)
    Completed
    */
}


/*:
#### subscribeNext

subscribeNext 也是订阅，但是只订阅 .Next 事件。
*/
example("subscribeNext") { () -> () in
    let sequenceOfInts = PublishSubject<Int>()
    _ = sequenceOfInts
        .subscribeNext {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
    /**
    ---subscribeNext example ---
    1
    */
}

/*:
#### subscribeCompleted

subscribeCompleted 是只订阅 .Completed 完成事件。
*/
example("subscribeCompleted") { () -> () in
    let sequenceOfInts = PublishSubject<Int>()
    _ = sequenceOfInts
        .subscribeCompleted {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
    /**
    --- subscribeCompleted example ---
    ()
    */
}


/*:
#### subscribeError

subscribeError 只订阅 .Error 失败事件。
*/
example("subscribeCompleted") { () -> () in
    let sequenceOfInts = PublishSubject<Int>()
    _ = sequenceOfInts
        .subscribeError {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Error(NSError(domain: "Examples", code: -1, userInfo: nil)))
    sequenceOfInts.on(.Completed)
    /**
    ---subscribeCompleted example ---
    Error Domain=Examples Code=-1 "(null)"
    */
}


/*:
#### doOn

doOn 可以监听事件，并且在事件发生之前调用。
*/
example("doOn") { () -> () in
    let sequenceOfInts = PublishSubject<Int>()
    _ = sequenceOfInts.doOn() {
        print("Intercepted event \($0)")
        }
        .subscribe {
            print($0)
    }
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Completed)
    /**
    ---doOn example ---
    Intercepted event Next(1)
    Next(1)
    Intercepted event Completed
    Completed
    */
}

//: [Next](@next)
