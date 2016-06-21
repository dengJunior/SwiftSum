//: Playground - noun: a place where people can play

import UIKit


/**
 本页包含内容：
 
 - 定义一个基类（Base class）
 - 子类生成（Subclassing）
 - 重写（Overriding）
 - 防止重写（Preventing Overrides）
 - 析构过程原理
 - 析构器实践
 
 ## 定义一个基类（Base class）
 不继承于其它类的类，称之为基类（base class）。
 
 >注意
 Swift 中的类并不是从一个通用的基类继承而来。如果你不为你定义的类指定一个超类的话，这个类就自动成为基类。
 
 ## 子类生成（Subclassing）
 
 ## 重写（Overriding）
 
 子类可以为继承来的实例方法（instance method），类方法（class method），实例属性（instance property），或下标（subscript）提供自己定制的实现（implementation）。我们把这种行为叫重写（overriding）。
 
 ### 重写属性的 Getters 和 Setters
 
 子类并不知道继承来的属性是存储型的还是计算型的，它只知道继承来的属性会有一个名字和类型。
 
 你可以将一个继承来的只读属性重写为一个读写属性，但是，你不可以将一个继承来的读写属性重写为一个只读属性。
 
 >注意
 如果你在重写属性中提供了 setter，那么你也一定要提供 getter。

 
 ### 重写属性观察器（Property Observer）
 
 >注意
 你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了。
 
 ### 防止重写
 
 你可以通过把方法，属性或下标标记为final来防止它们被重写，
 
 你可以通过在关键字class前添加final修饰符（final class）来将整个类标记为 final 的。这样的类是不可被继承的，试图继承这样的类会导致编译报错。
 
 ## 析构过程原理
 
 析构器只适用于类类型，当一个类的实例被释放之前，析构器会被立即调用。析构器用关键字deinit来标示，类似于构造器要用init来标示。
 
 每个类最多只能有一个析构器，而且析构器不带任何参数，如下所示：
 
 deinit {
 // 执行析构过程
 }
 
 析构器是在实例释放发生前被自动调用。你不能主动调用析构器。子类继承了父类的析构器，并且在子类析构器实现的最后，父类的析构器会被自动调用。即使子类没有提供自己的析构器，父类的析构器也同样会被调用。
 */

class Animal {
    var name: String? {
        return "Animal name"
    }
    final var name2: String?
    
    func eat() {
        
    }
    final func eat2() {
        
    }
    
    
    deinit {
        print("Animal")
    }
}

//Dog类不可被继承
final class Dog: Animal {
    //子类并不知道继承来的属性是存储型的还是计算型的，它只知道继承来的属性会有一个名字和类型。
//    重写父类计算属性为存储属性
    override var name: String? {
        get {
            //不想在重写版本中的 getter 里修改继承来的属性值
            return super.name
        }
        //如果你在重写属性中提供了 setter，那么你也一定要提供 getter。
        set {
            //不加下面那句的话，name不会被设置
            self.name = newValue
            //setter 中就可以观察到任何值变化了
        }
    }
    
    //析构器是在实例释放发生前被自动调用。你不能主动调用析构器。
    deinit {
        print("Dog")
        //在子类析构器实现的最后，父类的析构器会被自动调用。
    }
}
let dog = Dog()
dog.name = "xx"
print(dog.name)

















