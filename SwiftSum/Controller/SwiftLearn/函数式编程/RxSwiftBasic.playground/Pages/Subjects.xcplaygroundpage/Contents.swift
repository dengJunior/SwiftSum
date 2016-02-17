//: [Previous](@previous)

import Foundation

/*:
### 2.Subject

Subject 可以看做是一种代理和桥梁。它既是订阅者又是订阅源，
这意味着它既可以订阅其他 Observable 对象，同时又可以对它的订阅者们发送事件。

Observable像是一个水管，会源源不断的有水冒出来。
Subject就像一个水龙头，它可以套在水管上，接受Observable上面的事件。
但是作为水龙头，它下面还可以被别的observer给subscribe了。
*/

/*:
#### PublishSubject

PublishSubject 会发送订阅者从订阅之后的事件序列。
它仅仅会发送observer订阅之后的事件，也就是说如果sequence上有.Next 的到来，
但是这个时候某个observer还没有subscribe它，这个observer就收不到这条信息，
它只会收到它订阅之后发生的事件。
*/
example("PublishSubject") { () -> () in
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    writeSequeceToConsole("1", sequence: subject).addDisposableTo(disposeBag)
    subject.on(.Next("a"))
    subject.on(.Next("b"))
    
    writeSequeceToConsole("2", sequence: subject).addDisposableTo(disposeBag)
    subject.on(.Next("c"))
    subject.on(.Next("d"))
    
    /**
    *  ---PublishSubject example ---
    Subscription: 1, event: Next(a)
    Subscription: 1, event: Next(b)
    Subscription: 1, event: Next(c)
    Subscription: 2, event: Next(c)
    Subscription: 1, event: Next(d)
    Subscription: 2, event: Next(d)
    */
}

/*:
#### ReplaySubject

ReplaySubject 在新的订阅对象订阅的时候会补发所有已经发送过的数据队列，
bufferSize 是缓冲区的大小，决定了补发队列的最大值。
如果 bufferSize 是1，那么新的订阅者出现的时候就会补发上一个事件，如果是2，则补两个，以此类推。
*/
example("ReplaySubject") { () -> () in
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    writeSequeceToConsole("1", sequence: subject).addDisposableTo(disposeBag)
    subject.on(.Next("a"))
    subject.on(.Next("b"))
    subject.on(.Next("b1"))
    writeSequeceToConsole("2", sequence: subject).addDisposableTo(disposeBag)
    subject.on(.Next("c"))
    subject.on(.Next("d"))
    /**
    *  ---ReplaySubject example ---
    Subscription: 1, event: Next(a)
    Subscription: 1, event: Next(b)
    Subscription: 2, event: Next(b)//补了一个b，如果上面的bufferSize=2，那么还会补a
    Subscription: 1, event: Next(c)
    Subscription: 2, event: Next(c)
    Subscription: 1, event: Next(d)
    Subscription: 2, event: Next(d)
    */
}

/*:
#### BehaviorSubject

当有observer在订阅一个BehaviorSubject的时候，它首先将会收到Observable上最近发送一个信号（或者是默认值），接着才会收到Observable上会发送的序列。
*/
example("BehaviorSubject") { () -> () in
    let disposeBag = DisposeBag()
    let subject = BehaviorSubject(value: "z")
    writeSequeceToConsole("1", sequence: subject).addDisposableTo(disposeBag)
    subject.on(.Next("a"))
    subject.on(.Next("b"))
    writeSequeceToConsole("2", sequence: subject).addDisposableTo(disposeBag)
    subject.on(.Next("c"))
    subject.on(.Completed)
    /**
    *  ---BehaviorSubject example ---
    Subscription: 1, event: Next(z)
    Subscription: 1, event: Next(a)
    Subscription: 1, event: Next(b)
    Subscription: 2, event: Next(b)
    Subscription: 1, event: Next(c)
    Subscription: 2, event: Next(c)
    Subscription: 1, event: Completed
    Subscription: 2, event: Completed
    */
}

/*:
#### Variable

Variable 是基于 BehaviorSubject 的一层封装，它的优势是：不会被显式终结。
即：不会收到 .Completed 和 .Error 这类的终结事件，
它会主动在析构的时候发送 .Complete 。
*/
example("Variable") { () -> () in
    let disposeBag = DisposeBag()
    let variable = Variable("z")
    writeSequeceToConsole("1", sequence: variable.asObservable()).addDisposableTo(disposeBag)
    variable.value = "a"
    variable.value = "b"
    variable.value = "b1"
    writeSequeceToConsole("2", sequence: variable.asObservable()).addDisposableTo(disposeBag)
    variable.value = "c"
    /**
    ---Variable example ---
    Subscription: 1, event: Next(z)
    Subscription: 1, event: Next(a)
    Subscription: 1, event: Next(b)
    Subscription: 1, event: Next(b1)
    Subscription: 2, event: Next(b1)
    Subscription: 1, event: Next(c)
    Subscription: 2, event: Next(c)
    Subscription: 1, event: Completed
    Subscription: 2, event: Completed
    */
}
//: [Next](@next)
