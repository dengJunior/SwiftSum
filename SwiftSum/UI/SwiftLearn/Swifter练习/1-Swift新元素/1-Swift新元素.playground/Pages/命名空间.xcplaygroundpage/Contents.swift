//: [Previous](@previous)

import Foundation

/**
 命名空间
 
 在 Swift 中，由于可以使用命名空间了，即使是名字相同的类型，只要是来自不同的命名空间的话，都是可以和平共处的。
 
 和 C# 这样的显式在文件中指定命名空间的做法不同，Swift 的命名空间是基于 module 而不是在代码中显式地指明，每个 module 代表了 Swift 中的一个命名空间。
 
 - 也就是说，同一个 target 里的类型名称还是不能相同的。
 - 在我们进行 app 开发时，默认添加到 app 的主 target 的内容都是处于同一个命名空间中的，
 - 我们可以通过创建 Cocoa (Touch) Framework 的 target 的方法来新建一个 module，这样我们就可以在两个不同的 target 中添加同样名字的类型了
 */

//// MyFramework.swift
//// 这个文件存在于 MyFramework.framework 中
//public class MyClass {
//    public class func hello() {
//        print("hello from framework")
//    }
//}
//
//// MyApp.swift
//// 这个文件存在于 app 的主 target 中
//class MyClass {
//    class func hello() {
//        print("hello from app")
//    }
//}

//在使用时，如果出现可能冲突的时候，我们需要在类型名称前面加上 module 的名字 (也就是 target 的名字)


/**
 使用类型嵌套
 
 另一种策略是使用类型嵌套的方法来指定访问的范围。
 
 常见做法是将名字重复的类型定义到不同的 struct 中，以此避免冲突。
 这样在不使用多个 module 的情况下也能取得隔离同样名字的类型的效果：
 */
struct MyClass1 {
    class Dog {
        class func jiao() {
            print("MyClass1.Dog jiao")
        }
    }
}

struct MyClass2 {
    class Dog {
        class func jiao() {
            print("MyClass2.Dog jiao")
        }
    }
}

//使用时
MyClass1.Dog.jiao()
MyClass2.Dog.jiao()

//“其实不管哪种方式都和传统意义上的命名空间有所不同，把它叫做命名空间，更多的是一种概念上的宣传。不过在实际使用中只要遵守这套规则的话，还是能避免很多不必要的麻烦的，至少唾手可得的是我们不再需要给类名加上各种奇怪的前缀了。”

//: [Next](@next)






























