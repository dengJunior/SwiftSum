//: [Previous](@previous)

import Foundation

class AVLNode<T> {
    var parent: AVLNode? = nil
    var leftChild: AVLNode? = nil
    var rightChild: AVLNode? = nil
    
    var frequence = 1
    //以此节点为根的树的高度
    //目的是维护插入和删除过程中的旋转算法。
    var subtreeHeight = 0
    var value: T?
    
    init(value: T) {
        self.value = value
    }
    func cleanup() {
        parent = nil
        leftChild = nil
        rightChild = nil
        value = nil
        frequence = 0
    }
}

class AVLTree<T where T: Comparable> {
    var root: AVLNode<T>?
    var nodeNum = 0
    
    func height() -> Int {
        return 0
    }
    func search(value: T) -> AVLNode<T>? {
        return nil
    }
    func insert(value: T) {
    }
    func delete(value: T) {
    }
    
    //这里规定，一棵空树的高度为-1，只有一个根节点的树的高度为0，以后每多一层高度加1。
    private func subTreeHeight(node: AVLNode<T>?) -> Int {
        return node != nil ? node!.subtreeHeight : -1
    }
    private func maxValue(left: AVLNode<T>, rigth: AVLNode<T>) -> T? {
        return left.value > rigth.value ? left.value : rigth.value
    }
}

//: [Next](@next)
