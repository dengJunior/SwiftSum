//: [Previous](@previous)

import Foundation

//栈有两种是实现结构，一种是顺序存储结构，也就是利用数组实现，一种是链式存储结构，可以用单链表实现。
class Stack<T> {
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

class TreeNode<T> {
    var parent: TreeNode? = nil
    var leftChild: TreeNode? = nil
    var rightChild: TreeNode? = nil
    
    var frequence = 1
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

//二叉查找树（二叉排序树）：binary search tree 在二叉树中，如果左子树的数据都小于根节点的数据，右子树的数据都不小于根节点的数据，每棵子树也满足这个要求，这样的二叉树就称为二叉查找树。
class BinaryTree<T where T: Comparable> {
    var root: TreeNode<T>?
    var nodeNum = 0
    
    func insert(value: T) {
        insert(value, under: root)
    }
    
    func find(value: T) -> TreeNode<T>? {
        var currentNode = root
        while currentNode != nil {
            if value == currentNode?.value {
                return currentNode
            }
            if value < currentNode?.value {
                currentNode = currentNode?.leftChild
            } else {
                currentNode = currentNode?.rightChild
            }
        }
        return nil
    }
    
    func delete(value: T) {
        var currentNode = root
        while currentNode != nil {
            if value == currentNode?.value {
                //如果是叶子节点的话，直接删除就可以了
                if currentNode?.leftChild == nil && currentNode?.rightChild == nil {
                    if currentNode === currentNode?.parent?.leftChild {
                        currentNode?.parent?.leftChild = nil
                    } else {
                        currentNode?.parent?.rightChild = nil
                    }
                    currentNode?.cleanup()
                } else {
                    /**
                     *  删除有两个儿子的节点会比较复杂一些。
                     一般的删除策略是用其右子树最小的数据代替该节点的数据并递归的删除掉右子树中最小数据的节点。
                     因为右子树中数据最小的节点肯定没有左儿子，所以删除的时候容易一些。
                     */
                    if currentNode?.leftChild != nil && currentNode?.rightChild != nil {
                        var minNode = currentNode?.rightChild
                        repeat {
                            if minNode?.leftChild != nil {
                                minNode = minNode?.leftChild
                            } else {
                                break
                            }
                        }
                        currentNode?.value = minNode!.value
                        currentNode?.frequence = minNode!.frequence
                        minNode?.parent?.leftChild = nil
                        minNode?.cleanup()
                    } else {
                        //如果只有一个孩子的话，就让它的父亲指向它的儿子，然后删除这个节点。
                        if currentNode?.leftChild != nil {
                            currentNode?.parent?.leftChild = currentNode?.leftChild
                        } else {
                            currentNode?.parent?.rightChild = currentNode?.rightChild
                        }
                        currentNode?.cleanup()
                    }
                }
                nodeNum -= 1
                return
            }
            if value < currentNode?.value {
                currentNode = currentNode?.leftChild
            } else {
                currentNode = currentNode?.rightChild
            }
        }
    }
    
    //中序遍历,输出这个二叉查找树的有序序列。
    func travel() {
        //递归实现
        travel(root)
        
        /*
         中序遍历的非递归实现
         根据中序遍历的顺序，先访问左子树，再访问根节点，后访问右子树，而对于每个子树来说，又按照同样的访问顺序进行遍历
         非递归的实现思路如下：对于任一节点P，
         
         1）若P的左孩子不为空，则将P入栈并将P的左孩子置为当前节点，然后再对当前节点进行相同的处理；
         2）若P的左孩子为空，则输出P节点，而后将P的右孩子置为当前节点，看其是否为空；
         3）若不为空，则重复1）和2）的操作；
         4）若为空，则执行出栈操作，输出栈顶节点，并将出栈的节点的右孩子置为当前节点，看起是否为空，重复3）和4）的操作；
         5）直到当前节点P为NULL并且栈为空，则遍历结束。
         */
        let nodeStack = Stack<TreeNode<T>>()
        var currentNode = root
        while currentNode != nil {
            //如果Cur左孩子不为空，则将其入栈，并置其左孩子为当前节点
            if let leftChild = currentNode?.leftChild {
                nodeStack.push(leftChild)
                currentNode = leftChild
                continue
            } else {
                //如果pCur的左孩子为空，则输出pCur节点，并将其右孩子设为当前节点，看其是否为空
                print(currentNode?.value)
                currentNode = currentNode?.rightChild
                
                //如果为空，且栈不空，则将栈顶节点出栈，并输出该节点，
                //同时将它的右孩子设为当前节点，继续判断，直到当前节点不为空
                while currentNode == nil && !nodeStack.isEmpty() {
                    let parentNode = nodeStack.pop()!
                    print(parentNode.value)
                    currentNode = parentNode.rightChild
                }
            }
        }
    }
    
    //中序遍历的递归实现
    func travel(node: TreeNode<T>?) {
        if node != nil {
            travel(node?.leftChild) //先遍历左子树
            print(node?.value)      //输出根节点
            travel(node?.rightChild)//再遍历右子树
        }
    }
    
    func height() {
        
    }
    
    private func insert(value: T, under parentNode: TreeNode<T>?) {
        defer {
            nodeNum += 1
        }
        //如果根节点为空，就此节点作为根节点
        if root == nil {
            root = TreeNode(value: value)
            return
        }
        
        //为待插入的元素查找最终插入位置的父节点
        var finalParentNode = parentNode
        var currentNode = parentNode
        repeat {
            finalParentNode = currentNode
            //如果相等,就把频率加1
            if value == currentNode?.value {
                currentNode?.frequence += 1
                return
            }
            
            if value < currentNode?.value {
                currentNode = currentNode?.leftChild
            } else {
                currentNode = currentNode?.rightChild
            }
        } while (currentNode != nil)
        
        let node = TreeNode(value: value)
        node.parent = finalParentNode
        if value < finalParentNode?.value {
            finalParentNode?.leftChild = node
        } else {
            finalParentNode?.rightChild = node
        }
    }
    
    
    
}

//: [Next](@next)












