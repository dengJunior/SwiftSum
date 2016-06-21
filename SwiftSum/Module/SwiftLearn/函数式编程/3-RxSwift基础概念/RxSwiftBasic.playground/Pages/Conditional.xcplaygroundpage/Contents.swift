//: [Previous](@previous)

import Foundation

/*:
### Conditional

我们可以对多个事件序列做一些复杂的逻辑判断。
*/

/*:
#### takeUntil

takeUntil 其实就是 take ，它会在终于等到那个事件之后触发 .Completed 事件。
*/
example("takeUntil") { () -> () in
    let originalSequence = PublishSubject<Int>()
    let whenThisSendNextWorldStops = PublishSubject<Int>()
    _ = originalSequence
        .takeUntil(whenThisSendNextWorldStops)
        .subscribe {
            print($0)
    }
    
    originalSequence.on(.Next(1))
    originalSequence.on(.Next(2))
    originalSequence.on(.Next(3))
    originalSequence.on(.Next(4))
    
    whenThisSendNextWorldStops.on(.Next(1))
    
    originalSequence.on(.Next(5))
    /**
    ---takeUntil example ---
    Next(1)
    Next(2)
    Next(3)
    Next(4)
    Completed
    */
}


/*:
#### takeWhile

takeWhile 则是可以通过状态语句判断是否继续 take 。
*/
example("takeWhile") { () -> () in
    let sequenceOfInts = PublishSubject<Int>()
    _ = sequenceOfInts
        .takeWhile { int in
            int < 4
        }
        .subscribe {
            print($0)
    }
    
    sequenceOfInts.on(.Next(1))
    sequenceOfInts.on(.Next(2))
    sequenceOfInts.on(.Next(4))//不满足就终止了，发送Completed，不会再判断后面的情况
    sequenceOfInts.on(.Next(3))
    sequenceOfInts.on(.Next(5))
    /**
    ---takeWhile example ---
    Next(1)
    Next(2)
    Completed
    */
}

//: [Next](@next)
