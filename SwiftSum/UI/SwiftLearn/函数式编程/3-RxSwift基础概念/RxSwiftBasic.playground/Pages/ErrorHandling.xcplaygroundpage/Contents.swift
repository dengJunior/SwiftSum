//: [Previous](@previous)

import Foundation

/*:
### Error Handling

在事件序列中，遇到异常也是很正常的事情，有以下几种处理异常的手段。
*/

/*:
#### catchError

catchError 可以捕获异常事件，并且在后面无缝接上另一段事件序列，丝毫没有异常的痕迹。
*/
example("catchError 1") { () -> () in
    let sequenceThatFails = PublishSubject<Int>()
    let recoverySequece = Observable.of(100, 200, 300, 400)
    
    _ = sequenceThatFails
        .catchError { error in
            return recoverySequece
        }
        .subscribe() {
            print($0)
    }
    
    sequenceThatFails.on(.Next(1))
    sequenceThatFails.on(.Next(2))
    sequenceThatFails.on(.Next(3))
    sequenceThatFails.on(.Next(4))
    sequenceThatFails.on(.Error(NSError(domain: "Test", code: 0, userInfo: nil)))
    /**
    ---catchError 1 example ---
    Next(1)
    Next(2)
    Next(3)
    Next(4)
    Next(100)
    Next(200)
    Next(300)
    Next(400)
    Completed
    */
}

example("catchError 2") {
    let sequenceThatFails = PublishSubject<Int>()
    
    _ = sequenceThatFails
        .catchErrorJustReturn(100)
        .subscribe {
            print($0)
    }
    
    sequenceThatFails.on(.Next(1))
    sequenceThatFails.on(.Next(2))
    sequenceThatFails.on(.Next(3))
    sequenceThatFails.on(.Next(4))
    sequenceThatFails.on(.Error(NSError(domain: "Test", code: 0, userInfo: nil)))
}


/*:
#### retry

retry 顾名思义，就是在出现异常的时候会再去从头订阅事件序列，妄图通过『从头再来』解决异常。
*/
example("retry") { () -> () in
    var count = 1 // bad practice, only for example purposes
    let funnyLookingSequence = Observable<Int>.create { observer in
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        observer.on(.Next(0))
        observer.on(.Next(1))
        observer.on(.Next(2))
        if count < 2 {
            observer.on(.Error(error))
            count += 1
        }
        observer.on(.Next(3))
        observer.on(.Next(4))
        observer.on(.Next(5))
        observer.on(.Completed)
        
        return NopDisposable.instance
    }
    
    _ = funnyLookingSequence
        .retry()
        .subscribe {
            print($0)
    }
    /**
    ---retry example ---
    Next(0)
    Next(1)
    Next(2)
    Next(0)
    Next(1)
    Next(2)
    Next(3)
    Next(4)
    Next(5)
    Completed
    */
}


//: [Next](@next)
