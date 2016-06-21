//
//  NSMachPortDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/*
 使用NSMachPort对象  只能在OS X系统中使用
 
 NSMachPort对象是什么呢？其实就是线程与线程之间通信的桥梁，
 我们创建一个NSMachPort对象，将其添加至主线程的Run Loop中，
 然后我们在二级线程执行的任务中就可以获取并使用该对象向主线程发送消息，
 也就是说这种方式是将NSMachPort对象在不同线程中相互传递从而进行消息传递的。
 */
class NSMachPortDemo: UIViewController, NSMachPortDelegate, NSPortDelegate {

    let printMessageId = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainThreadPort = NSMachPort()
        mainThreadPort.setDelegate(self)
        NSRunLoop.currentRunLoop().addPort(mainThreadPort, forMode: NSDefaultRunLoopMode)
        
        let workerClass = WorkerClass()
        
        /**
         创建二级线程，并让该二级线程执行WorkerClass类中的launchThreadWithPort:方法，
         同时将刚才创建好的端口对象作为参数传给该方法，
         也就是将主线程中的端口对象传到了二级线程中。
         */
        NSThread.detachNewThreadSelector(#selector(WorkerClass.launchThreadWithPort(_:)), toTarget: workerClass, withObject: mainThreadPort)
    }

    // MARK: - NSMachPortDelegate
    
    /**
     通过NSMachPortDelegate的handlePortMessage:方法处理来自二级线程的消息。
     */
    func handleMachMessage(msg: UnsafeMutablePointer<Void>) {
        print("handleMachMessage")
        /*
         通过端口传递的消息可以根据消息编号判断该执行什么样的任务，
         所以该方法中通过NSPortMessage对象获取到消息id然后进行判断并执行相应的任务，
         消息id在二级线程通过端口向主线程发送消息时可以设置。
         */
//        let message = unsafeBitCast(msg, NSMessagePort.self)
//        let messageId = message.msgid
//        
//        if messageId == UInt32(printMessageId) {
//            
//            print("Receive the message that id is 1000 and this is a print task.")
//            
//        } else {
//            
//            // Handle other messages
//            
//        }
        
    }
}



class WorkerClass: NSObject, NSMachPortDelegate {
    func launchThreadWithPort(port: NSMachPort) {
        autoreleasepool { 
            let secondThreadPort = NSMachPort()
            secondThreadPort.setDelegate(self)
            let runloop = NSRunLoop.currentRunLoop()
            runloop.addPort(secondThreadPort, forMode: NSDefaultRunLoopMode)
            //向主线程发送消息
            sendPrintMessage(port, receivePort: secondThreadPort)
            runloop.runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 500))
        }
    }
    
    func sendPrintMessage(sendPort: NSMachPort, receivePort: NSMachPort) {
        /*
         创建NSPortMessage对象，该对象就是端口之间相互传递的介质，初始化方法的第一个参数为主线程的端口对象，也就是发送消息的目标端口，第二个参数是二级线程的端口对象，第三个参数的作用是向主线程发送需要的数据，该参数的类型是AnyObject的数组。
         
         创建完消息对象后，要给该消息设置消息id，以便主线程接收后进行判断，最后通过sendBeforeDate:方法发送消息。
         */
//        let portMessage = NSPortMessage(sendPort: sendPort, receivePort: receivePort, components: nil)
//        portMessage.msgid = UInt32(1000)
//        portMessage.sendBeforeDate(NSDate(timeIntervalSinceNow: 1))
    }
    
    
}

























