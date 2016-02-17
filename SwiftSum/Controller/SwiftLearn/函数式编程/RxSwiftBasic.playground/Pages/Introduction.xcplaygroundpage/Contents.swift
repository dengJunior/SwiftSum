//: Playground - noun: a place where people can play

import RxSwift


/*:
### 1.Observable

主要介绍了 Rx 的基础： Observable 。
Observable<Element> 是观察者模式中被观察的对象，
相当于一个事件序列(GeneratorType)，会向订阅者发送新产生的事件信息。
事件信息分为三种：

- .Next(value) 表示新的事件数据。
- .Completed 表示事件序列的完结。
- .Error 同样表示完结，但是代表异常导致的完结。

热信号vs冷信号
信号分两种，热信号在它创建的时候就开始推送事件，
这意味着如果后面有订阅者来的时候，就可能会错过一些事件。
而冷信号则不会，只有在它被订阅的时候，它才会发送事件，
这可以保证后面即使有订阅者中途加入的时候也能收到完整的事件序列。
*/


/*:
#### empty

empty 是一个空的序列，它只发送 .Completed 消息。
*/
example("empty") { () -> () in
    let emptySequence = Observable<Int>.empty()
    _ = emptySequence
        .subscribe { event in
            print(event)
    }
}

/*:
#### never

never 是没有任何元素、也不会发送任何事件的空序列。
*/
example("never") { () -> () in
    let neverSequence = Observable<Int>.never()
    _ = neverSequence
        .subscribe { _ in
            print("This block is never called.")
    }
}

/*:
#### just

just 是只包含一个元素的序列，它会先发送 .Next(value) ，然后发送 .Completed 。
*/
example("just") { () -> () in
    let singleElementSequence = Observable.just(32)
    _ = singleElementSequence
        .subscribe { event in
            print(event)
    }
}

/*:
#### sequenceOf

sequenceOf 可以把一系列元素转换成事件序列。
*/
example("sequenceOf") { () -> () in
    let sequenceOfElements = Observable.of(1,2,4,5,6,1)
    _ = sequenceOfElements
        .subscribe { event in
            print(event)
    }
}

/*:
#### from

from 是通过 toObservable() 方法把 Swift 中的序列 (SequenceType) 转换成事件序列。
*/
example("toObservable") { () -> () in
    let sequenceFromArray = [1,2,3,4].toObservable();
    _ = sequenceFromArray
        .subscribe { event in
            print(event)
    }
}

/*:
#### create

create 可以通过闭包创建序列，通过 .on(e: Event) 添加事件。
*/
example("create") {
    let myJust = { (singleElement: Int) -> Observable<Int> in
        return Observable.create { observer in
            observer.on(.Next(singleElement))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    _ = myJust(5)
        .subscribe { event in
            print(event)
    }
}

/*:
#### generate

generate creates sequence that generates its values and determines when to terminate based on its previous values.
*/
example("generate") { () -> () in
    let generate = Observable.generate(
        initialState: 0,
        condition: { $0 < 3},
        iterate: { $0 + 1})
    
    _ = generate.subscribe { event in
        print(event)
    }
    /**
    *  ---generate example ---
    Next(0)
    Next(1)
    Next(2)
    Completed
    */
}


/*:
#### failWith

failWith 创建一个没有元素的序列，只会发送失败 (.Error) 事件。
*/
example("failWith") { () -> () in
    let error = NSError(domain: "test", code: -1, userInfo: nil)
    let errordSequence = Observable<Int>.error(error)
    _ = errordSequence
        .subscribe { event in
            print(event)
    }
}


/*:
#### deferred

deferred 会等到有订阅者的时候再通过工厂方法创建 Observable 对象，
每个订阅者订阅的对象都是内容相同而完全独立的序列。
*/
example("deferred") { () -> () in
    let deferredSequence: Observable<Int> = Observable.deferred {
        print("creating")
        return Observable.create { observer in
            print("emmiting")
            observer.on(.Next(0))
            observer.on(.Next(1))
            observer.on(.Next(2))
            
            return NopDisposable.instance
        }
    }
    
    _ = deferredSequence
        .subscribe() { event in
            print(event)
    }
    _ = deferredSequence
        .subscribe() { event in
            print(event)
    }
}

/*:
为什么需要 defferd 这样一个奇怪的家伙呢？其实这相当于是一种延时加载，
因为在添加监听的时候数据未必加载完毕
*/
example("TestDeferred") { () -> () in
    var value: String? = nil
    let subscription = Observable<String?>.just(value)
    let defferedSquence = Observable<String?>.deferred {
        return Observable.just(value)
    }
    value = "hello"
    _ = subscription.subscribe { event in
        print(event)//获取到的value是nil
        /**
        *  ---TestDeferred example ---
        Next(nil)
        Completed
        */
    }
    _ = defferedSquence.subscribe { event in
        print(event)//使用 deffered 则可以正常显示想要的数据：
        /**
        *  ---TestDeferred example ---
        Next(Optional("hello"))
        Completed
        */
    }
}








































