//: Playground - noun: a place where people can play

import Cocoa

/**
 本页包含内容：
 
 - 实例方法(Instance Methods)
 - 类型方法(Type Methods)
 - 下标语法
 - 下标用法
 - 下标选项
 
 方法是与某些特定类型相关联的函数。
 
 - 实例方法为给定类型的实例封装了具体的任务与功能。
 - 类型方法与类型本身相关联。
 */

// MARK: - ## 实例方法 (Instance Methods)

//### self 属性(The self Property)

//类型的每一个实例都有一个隐含属性叫做self，self完全等同于该实例本身。你可以在一个实例的实例方法中使用这个隐含的self属性来引用当前实例。

// MARK: - ### 在实例方法中修改值类型(Modifying Value Types from Within Instance Methods)

/**
 结构体和枚举是值类型。默认情况下，值类型的属性不能在它的实例方法中被修改。但是，如果你确实需要在某个特定的方法中修改结构体或者枚举的属性，
 
 - 你可以为这个方法选择可变(mutating)行为，然后就可以从其方法内部改变它的属性；
 - 这个方法做的任何改变都会在方法执行结束时写回到原始结构中。
 - 这个方法中还可以给它隐含的self属性赋予一个全新的实例，这个新实例在方法结束时会替换现存实例。
 */
struct Point {
    var x = 0.0, y = 0.0
    
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
    mutating func newInstance() {
        self = Point(x: 8, y: 9)
    }
}

enum TriStateSwitch {
    case Off, Low, Hight
    //枚举的可变方法可以把self设置为同一枚举类型中不同的成员：
    mutating func next() {
        switch self {
        case .Off:
            self = Low
        case .Low:
            self = Hight
        case .Hight:
            self = Off
        }
    }
}
// MARK: - ## 类型方法 (Type Methods)

//在类型方法的方法体（body）中，self指向这个类型本身，而不是类型的某个实例。

// MARK: - # 下标（Subscripts）

//下标 （subscripts）可以定义在类（class）、结构体（structure）和枚举（enumeration）中，是访问集合（collection），列表（list）或序列（sequence）中元素的快捷方式。

//一个类型可以定义多个下标，通过不同索引类型进行重载。下标不限于一维，你可以定义具有多个入参的下标满足自定义类型的需求。
struct TimesTable {
    var multiplier: Int
    
    //语法 类似计算型属性
    subscript(index: Int) -> Int {
        get {
            return multiplier * index
        }
        set {
            //newValue的类型和下标的返回类型相同。
            multiplier = newValue
        }
    }
    
    //下标可以接受任意数量的入参，并且这些入参可以是任意类型。下标的返回值也可以是任意类型。下标可以使用变量参数和可变参数，但不能使用输入输出参数，也不能给参数设置默认值。
    subscript(add1: Int, add2: Int) -> Int {
        //可以省略setter，但不能省略getter
        return multiplier * (add1 + add2)
    }
    
    subscript(str: String) -> String {
        get {
            return "none"
        }
        set(newString) {
            print(newString)
        }
    }
    
}
var threeTimesTable = TimesTable(multiplier: 3)
threeTimesTable[6]//18
threeTimesTable[6] = 2
threeTimesTable[6]//12
print(threeTimesTable[4, 2])//12

threeTimesTable["dd"]//none
threeTimesTable["dd"] = "test"//test
















