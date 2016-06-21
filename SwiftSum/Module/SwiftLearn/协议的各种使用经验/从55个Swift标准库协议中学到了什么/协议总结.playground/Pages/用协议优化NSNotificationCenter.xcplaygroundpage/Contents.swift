//: [Previous](@previous)

import Foundation

/*
 NSNotificationCenter存在的问题
 
 1. 通知没有统一的命名格式
 2. 通知名称可能冲突
 3. 通知的名称是字符串
 
 利用protocol的解决方案
 
 我们通过设计一个protocol来解决上面提到的问题。通过枚举统一通知名称
 */

protocol YYNotificationNameType {
    associatedtype Notification: RawRepresentable
    
    static func postNotification(notification: Notification, object: AnyObject?, userInfo: [String : AnyObject]?)
    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification, object: AnyObject?)
    static func removeObserver(observer: AnyObject, notification: Notification?, object: AnyObject?)
}

extension YYNotificationNameType where Notification.RawValue == String {
    
    // MARK: - 避免通知名称冲突
    
    //给这个协议加一个拓展方法来生成唯一的通知名称。因为这个方法只需要内部知道，所以标记为private。
    //但是会对系统协议产生影响，看情况是否需要
    private static func notificationName(notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    // MARK: - 协议的默认实现方法
    static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName(notification), object: object, userInfo: userInfo)
    }
    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification, object: AnyObject? = nil) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: notificationName(notification), object: object)
    }
    static func removeObserver(observer: AnyObject, notification: Notification? = nil, object: AnyObject? = nil) {
        if let notification = notification {
            NSNotificationCenter.defaultCenter().removeObserver(observer, name: notificationName(notification), object: object)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
}

// MARK: - 通过枚举统一通知名称
struct Test: YYNotificationNameType {
    enum Notification: String {
        case makeCoffee
    }
}

class NotificationSystem: YYNotificationNameType {
    
    class Test: YYNotificationNameType {
        enum Notification: String {
            case makeCoffee
        }
    }
    
    enum Notification: String {
        case UIApplicationWillEnterForegroundNotification
    }
}

//使用
Test.postNotification(.makeCoffee)//Test.makeCoffee
//Test.addObserver(self, selector: Selector, notification: .makeCoffee)
//Test.removeObserver(self)

NotificationSystem.postNotification(.UIApplicationWillEnterForegroundNotification)

//Test.makeCoffee
NotificationSystem.Test.postNotification(.makeCoffee)

//: [Next](@next)
