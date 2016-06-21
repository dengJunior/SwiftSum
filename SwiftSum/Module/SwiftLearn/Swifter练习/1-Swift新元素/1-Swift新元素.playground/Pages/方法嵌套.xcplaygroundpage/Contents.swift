//: [Previous](@previous)

import Foundation

/*
 方法嵌套
 
 方法终于成为了一等公民，也就是说，我们可以将方法当作变量或者参数来使用了。更进一步地，我们甚至可以在一个方法中定义新的方法，这给代码结构层次和访问级别的控制带来了新的选择。
 
 想想看有多少次我们因为一个方法主体内容过长，而不得不将它重构为好几个小的功能块的方法，然后在原来的主体方法中去调用这些小方法。这些具体负责一个个小功能块的方法也许一辈子就被调用这么一次，但是却不得不存在于整个类型的作用域中。
 
 举个例子，我们在写一个网络请求的类 Request 时，可能面临着将请求的参数编码到 url 里的任务。因为输入的参数可能包括单个的值，字典，或者是数组，因此为了结构漂亮和保持方法短小，我们可能将情况分开，写出这样的代码：
 */
func appendQuery(url: String, key: String, value: AnyObject) -> String {
    /**
     这三个方法都只会在第一个方法中被调用，它们其实和 Request 没有直接的关系，所以将它们放到 appendQuery 中去会是一个更好的组织形式：”
     */
    func appendQueryDictionary(url: String, key: String, value: [String: AnyObject]) -> String {
        return ""
    }
    func appendQueryArray(url: String, key: String, value: [AnyObject]) -> String {
        return ""
    }
    func appendQuerySingle(url: String, key: String, value: AnyObject) -> String {
        return ""
    }
    
    
    if let dictionary = value as? [String: AnyObject] {
        return appendQueryDictionary(url, key: key, value: dictionary)
    } else if let array = value as? [AnyObject] {
        return appendQueryArray(url, key: key, value: array)
    } else {
         return appendQuerySingle(url, key: key, value: value)
    }
}

/**
 事实上后三个方法都只会在第一个方法中被调用，它们其实和 Request 没有直接的关系，所以将它们放到 appendQuery 中去会是一个更好的组织形式：”
 */
func appendQueryDictionary2(url: String, key: String, value: [String: AnyObject]) -> String {
    return ""
}
func appendQueryArray2(url: String, key: String, value: [AnyObject]) -> String {
    return ""
}
func appendQuerySingle2(url: String, key: String, value: AnyObject) -> String {
    return ""
}


//: [Next](@next)
