//: [Previous](@previous)

import Foundation

/**
 Swift 里可以将方法进行柯里化 (Currying)，也就是把接受多个参数的方法进行一些变形，使其更加灵活的方法。
 */

//用来量产 Int -> Int 函数
func addTo(adder: Int) -> Int -> Int {
    return { num in return num + adder}
}

let addTwo = addTo(2)//Int -> Int
print(addTwo(6))//8

//柯里化就是这样量产相似函数的好途径

/**
 举一个实际应用时候的例子，在 Selector 一节中，我们提到了在 Swift 中 Selector 只能使用字符串在生成。
 
 这面临一个很严重的问题，就是难以重构，并且无法在编译期间进行检查，其实这是十分危险的行为。
 但是 target-action 又是 Cocoa 中如此重要的一种设计模式，无论如何我们都想安全地使用的话，应该怎么办呢？
 一种可能的解决方式就是利用方法的柯里化。
 Ole Begemann 在这篇帖子里提到了一种很好封装，这为我们如何借助柯里化，安全地改造和利用 target-action 提供了不少思路。”
 */

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performAction() {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside, ValueChanged
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    
    func setTarget<T: AnyObject>(target: T, action: (T) -> () -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControllEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}

//使用
class MyViewController {
    let button = Control()
    
    func viewDidLoad() {
        button.setTarget(self, action: MyViewController.onButtonTap, controlEvent: .TouchUpInside)
    }
    
    func onButtonTap() {
        print("Button was tapped")
    }
}




//: [Next](@next)












