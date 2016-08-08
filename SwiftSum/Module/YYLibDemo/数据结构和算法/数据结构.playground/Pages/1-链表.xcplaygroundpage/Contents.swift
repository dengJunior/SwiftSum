//: Playground - noun: a place where people can play

import UIKit

class YYNode<T> {
    var next: YYNode? = nil
    var prev: YYNode? = nil
    var value: T?
    
    init(value: T) {
        self.value = value
    }
    
    func unbind() {
        next = nil
        prev = nil
    }
    func cleanup() {
        unbind()
        value = nil
    }
}

class YYList<T where T: Comparable> {
    var head: YYNode<T>?
    var tail: YYNode<T>?
    var length: Int = 0
    
    func insertHead(value: T) {
        let node = YYNode(value: value)
        insertNodeHead(node)
    }
    func insertTail(value: T) {
        let node = YYNode(value: value)
        insertNodeTail(node)
    }
    func search(value: T) -> YYNode<T>? {
        var temp = head
        while (temp != nil) {
            if value == temp!.value {
                return temp
            }
            temp = temp?.next
        }
        return nil
    }
    func delete(value: T) -> Bool {
        if let node = search(value) {
            deleteNode(node)
        }
        return false
    }
    
    func insertNodeHead(node: YYNode<T>) {
        node.unbind()
        if length == 0 {
            head = node
            tail = node
        } else {
            node.next = head
            head?.prev = node
            head = node
        }
        length += 1
    }
    func insertNodeTail(node: YYNode<T>) {
        node.unbind()
        if length == 0 {
            head = node
            tail = node
        } else {
            node.prev = tail
            tail?.next = node
            tail = node
        }
        length += 1
    }
    
    func deleteNode(node: YYNode<T>) {
        if node === head {
            head = head?.next
        } else if node === tail {
            tail = tail?.prev
        } else {
            node.prev?.next = node.next
            node.next?.prev = node.prev
        }
        node.unbind()
        length -= 1
    }
}




