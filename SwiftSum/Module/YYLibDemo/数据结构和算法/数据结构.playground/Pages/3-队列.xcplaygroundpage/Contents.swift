//: [Previous](@previous)

import Foundation

//用数组实现的队列
class YYQueue<T> {
    private var container = [T]()
    
    var count: Int {
        return container.count
    }
    
    func push(node: T) {
        container.append(node)
    }
    func pop() -> T? {
        return count > 0 ? container.removeFirst() : nil
    }
    func isEmpty() -> Bool {
        return container.isEmpty
    }
    func top() -> T? {
        return container.first
    }
    func bottom() -> T? {
        return container.last
    }
    func clearnup() {
        container.removeAll()
    }
}

//: [Next](@next)
