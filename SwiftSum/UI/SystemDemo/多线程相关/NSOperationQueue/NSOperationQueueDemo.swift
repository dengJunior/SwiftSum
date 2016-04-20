//
//  NSOperationQueueDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - NSBlockOperation
/**
 创建NSBlockOperation对象
 
 NSBlockOperation是另外一个由Foundation框架提供的NSOperation抽象类的实现类，该类的作用是将一个或多个block或闭包封装为一个Operation对象。在第一次创建NSBlockOperation时至少要添加一个block：
 */
class TestBlockOperation {
    
    func start() {
        print("The main thread num is \(NSThread.currentThread())")
        /**
         1.可以直接调用它父类NSOperation的start方法执行任务，这种不放在操作队列中的执行方式都是在当前线程，
         2. 它会等待所有的block都执行完成后才会返回执行完成的状态，所以我们可以用NSBloxkOperation跟踪一组block的执行情况。
         打印如下：
         
         The main thread id is <NSThread: 0x101502e40>{number = 1, name = main}
         Task in first closure. The thread id is <NSThread: 0x101502e40>{number = 1, name = main}
         start finished---------
         */
        createBlockOperationObject().start()
        print("start finished---------")
    }
    
    
    func createBlockOperationObject() -> NSOperation {
        let blockOperation = NSBlockOperation {
            print("Task in first closure. The thread num is \(NSThread.currentThread())")
        }
        
        /**
         *  也可以通过NSBlockOperation对象的方法addExecutionBlock添加其他的block或者说任务：
         */
        blockOperation.addExecutionBlock {
            print("Task in second closure. The thread num is \(NSThread.currentThread())")
        }
        /**有2个任务时候
         The main thread num is <NSThread: 0x7fb0fa403590>{number = 1, name = main}
         Task in first closure. The thread num is <NSThread: 0x7fb0fa403590>{number = 1, name = main}
         Task in second closure. The thread num is <NSThread: 0x7fb0fc80a000>{number = 2, name = (null)}
         start finished---------
         */
        
        blockOperation.addExecutionBlock {
            print("Task in third closure. The thread num is \(NSThread.currentThread())")
        }
        
        /**有3个任务时候
         The main thread num is <NSThread: 0x7fda0ac00e80>{number = 1, name = main}
         Task in first closure. The thread num is <NSThread: 0x7fda0ac00e80>{number = 1, name = main}
         Task in second closure. The thread num is <NSThread: 0x7fda0af60840>{number = 2, name = (null)}
         Task in third closure. The thread num is <NSThread: 0x7fda0ae30fa0>{number = 3, name = (null)}
         start finished---------
         */
        
        /**
         *  通过上面两段代码可以观察到，当NSBlockOperation中只有一个block时，在调用start方法执行任务时不会为其另开线程，而是在当前线程中同步执行，
         只有当NSBlockOperation包含多个block时，才会为其另开二级线程，使任务并发异步执行。
         另外，当NSBlockOperation执行时，它会等待所有的block都执行完成后才会返回执行完成的状态，所以我们可以用NSBloxkOperation跟踪一组block的执行情况。
         */
        
        return blockOperation
    }
    
}

// MARK: - 自定义非并发Operation对象

/// 一个网络请求的例子展示如何创建自定义的Operation对象：
class MyNonConcurrentOperation: NSOperation {
    var url: String?
    
    //1.自定义初始化方法：主要用于在初始化自定义Operation对象时传递必要的参数。
    init(withUrl url: String) {
        self.url = url
    }
    
    //main方法：该方法就是处理主要任务的地方，你需要执行的任务都在这个方法里。
    
    /**
     当我们调用MyNonconcurrentOperation的start方法时，就会执行main方法里的逻辑了，这就是一个简单的非并发自定义Operation对象，
     之所以说它是非并发，因为它一般都在当前线程中执行任务，
     既如果你在主线程中初始化它，调用它的start方法，那么它就在主线程中执行，如果在二级线程中进行这些操作，那么就在二级线程中执行。
     */
    override func main() {
        /*
         注：如果在二级线程中使用非并发自定义Operation对象，那么main方法中的内容应该使用autoreleasepool{}包起来。因为如果在二级线程中，没有主线程的自动释放池，一些资源没法被回收，所以需要加一个自动释放池，如果在主线程中就不需要了。
         */
        
        //1.在任务开始之前。
        if self.cancelled {
            return
        }
        
        guard let urlString = self.url else {
            return
        }
        
        let url = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        //2.任务开始不久，这里刚创建了NSURL和NSURLSession，所以如果判断出任务已被取消，退出。
        if self.cancelled {
            return
        }
        
        let dataTask = session.dataTaskWithURL(url) { (data, response, nserror) in
            //4.网络请求期间。
            if self.cancelled {
                return
            }
            
            if let error = nserror {
                print("出现异常：\(error.localizedDescription)")
            } else {
                do {
                    let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    print(dict)
                } catch {
                    print("出现异常")
                }
            }
        }
        
        //3. 开始请求网络之前
        if self.cancelled {
            return
        }
        
        dataTask.resume()
        sleep(10)
    }
    
    // MARK: - 响应取消事件
    /**
     一般情况下，当Operation对象开始执行时，就会一直执行任务，不会中断执行，但是有时需要在任务执行一半时终止任务，这时就需要Operation对象有响应任务终止命令的能力。理论上，在Operation对象执行任务的任何时间点都可以调用NSOperation类的cancel方法终止任务
     
     *  我们只有在整个任务逻辑代码中尽可以细的去判断cancelled属性，才可以达到较为实时的终止效果。上面代码中我分别在四个地方判断了cancelled属性：
     */
}

// MARK: - 自定义并发Operation对象

class MyConcurrentOperation: NSOperation {
    var url: String?
    private var ifFinished = false
    private var ifExecuting = false
    
    /*
     由于NSOperation的finished、executing、concurrent这三个属性都是只读的，我们无法重写它们的setter方法，所以我们只能靠新建的私有属性去重写它们的getter方法。
     为了自定义的Operation对象更像原生的NSOperation子类，我们需要通过willChangeValueForKey和didChangeValueForKey方法手动为ifFinished和ifExecuting这两个属性生成KVO通知，将keyPath设置为原生的finished和executing。
     */
    override var concurrent: Bool {
        return true
    }
    override var finished: Bool {
        return ifFinished
    }
    override var executing: Bool {
        return ifExecuting
    }
    
    init(withUrl url: String) {
        self.url = url
    }
    
    override func start() {
        //- 在start方法开始之初就要判断一下Operation对象是否被终止任务。
        if self.cancelled {
            willChangeValueForKey("finished")
            ifFinished = true
            didChangeValueForKey("finished")
            return
        } else {
            willChangeValueForKey("executing")
            ifExecuting = true
            didChangeValueForKey("executing")
        }
    }
    
    override func main() {
        // - main方法中的内容要放在autoreleasepool中，解决在二级线程中的内存释放问题。
        autoreleasepool { 
            guard let urlString = self.url else {
                return
            }
            
            let url = NSURL(string: urlString)!
            let session = NSURLSession.sharedSession()
            
            //2.任务开始不久，这里刚创建了NSURL和NSURLSession，所以如果判断出任务已被取消，退出。
            if self.cancelled {
                completeOperation()
                return
            }
            
            let dataTask = session.dataTaskWithURL(url) { (data, response, nserror) in
                //4.网络请求期间。
                if self.cancelled {
                    self.completeOperation()
                    return
                }
                
                if let error = nserror {
                    print("出现异常：\(error.localizedDescription)")
                    self.completeOperation()
                } else {
                    do {
                        let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        print(dict)
                        self.completeOperation()
                    } catch {
                        print("出现异常")
                    }
                }
            }
            
            //3. 开始请求网络之前
            if self.cancelled {
                completeOperation()
                return
            }
            
            dataTask.resume()
        }
    }
    
    //- 如果判断出Operation对象的任务已经被终止，要及时修改ifFinished和ifExecuting属性。
    func completeOperation() {
        willChangeValueForKey("finished")
        willChangeValueForKey("executing")
        ifFinished = true
        ifExecuting = false
        didChangeValueForKey("finished")
        didChangeValueForKey("executing")
    }
}

// MARK: - 测试自定义并发Operation对象

class TestMyConcurrentOperation: NSObject {
    private var myContext = 0
    let concurrentOperation = MyConcurrentOperation(withUrl: "http://www.baidu.com/s?wd=ios")
    
    func launch() {
        concurrentOperation.addObserver(self, forKeyPath: "finished", options: .New, context: &myContext)
        concurrentOperation.addObserver(self, forKeyPath: "executing", options: .New, context: &myContext)
        concurrentOperation.start()
        sleep(5)
        
        print(concurrentOperation.executing)
        print(concurrentOperation.finished)
        print(concurrentOperation.concurrent)
        
        sleep(5)
    }
    
    deinit {
        concurrentOperation.removeObserver(self, forKeyPath: "finished")
        concurrentOperation.removeObserver(self, forKeyPath: "executing")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let change = change where context == &myContext {
            if keyPath == "finished" {
                print("Finish status has been changed, The new value is \(change[NSKeyValueChangeNewKey]!)")
            } else if keyPath == "executing" {
                print("Executing status has been changed, The new value is \(change[NSKeyValueChangeNewKey]!)")
            }
        }
    }
    
}



















