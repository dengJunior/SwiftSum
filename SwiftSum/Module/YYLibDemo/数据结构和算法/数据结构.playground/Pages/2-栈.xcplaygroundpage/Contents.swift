//: [Previous](@previous)

import Foundation

//用数组实现的栈
class YYStack<T> {
    private var container = [T]()
    
    var count: Int {
        return container.count
    }
    
    func push(node: T) {
        container.append(node)
    }
    func pop() -> T? {
        return count > 0 ? container.removeLast() : nil
    }
    func isEmpty() -> Bool {
        return container.isEmpty
    }
    func top() -> T? {
        return container.last
    }
    func bottom() -> T? {
        return container.first
    }
    func clearnup() {
        container.removeAll()
    }
}

//: [Next](@next)
