//: Playground - noun: a place where people can play

import UIKit


/**
 本页包含内容：
 
 - 表示并抛出错误
 - 处理错误
 - 指定清理操作
 
 >注意
 Swift 中的错误处理涉及到错误处理模式，这会用到 Cocoa 和 Objective-C 中的NSError。
 */

// MARK: - ## 表示并抛出错误

//在 Swift 中，错误用符合ErrorType协议的类型的值来表示。这个空协议表明该类型可以用于错误处理。

enum VendingMachineError: ErrorType {
    case InvalidSelection                    //选择无效
    case InsufficientFunds(coinsNeeded: Int) //金额不足
    case OutOfStock                          //缺货
}

// MARK: - ## 处理错误
/**
 某个错误被抛出时，附近的某部分代码必须负责处理这个错误，Swift 中有4种处理错误的方式。
 
 1. 把函数抛出的错误传递给调用此函数的代码、
 2. 用do-catch语句处理错误、
 3. 将错误作为可选类型处理、
 4. 断言此错误根本不会发生。
 
 当一个函数抛出一个错误时，你的程序流程会发生改变，所以重要的是你能迅速识别代码中会抛出错误的地方。为了标识出这些地方，在调用一个能抛出错误的函数、方法或者构造器之前，加上try关键字，或者try?或try!这种变体。
 
 >注意
 Swift和其他语言中（包括 Objective-C ）的异常处理不同的是，Swift 中的错误处理并不涉及解除调用栈，这是一个计算代价高昂的过程。就此而言，throw语句的性能特性是可以和return语句相媲美的。
 */

struct Item {
    var price: Int
    var count: Int
}
class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    
    func vend(itemNamed name: String) throws {
        guard var item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        item.count -= 1
        inventory[name] = item
        dispenseSnack(name)
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

// MARK: - ### 用 throwing 函数传递错误

/**
 只有 throwing 函数可以传递错误。任何在某个非 throwing 函数内部抛出的错误只能在函数内部处理。
 */
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    
    //因为vend(itemNamed:)方法会传递出它抛出的任何错误，在你的代码中调用此方法的地方，必须要么直接处理这些错误——使用do-catch语句，try?或try!；要么继续将这些错误传递下去。
    try vendingMachine.vend(itemNamed: snackName)
    //所以在调用的它时候在它前面加了try关键字。
}

// MARK: - ### 用 Do-Catch 处理错误

 /*
 下面是do-catch语句的一般形式：
 do {
 try expression
 statements
 } catch pattern 1 {
 statements
 } catch pattern 2 where condition {
 statements
 }
 */

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8

do {
    try buyFavoriteSnack("Alick", vendingMachine: vendingMachine)
    //如果错误被抛出，相应的执行会马上转移到catch子句中，并判断这个错误是否要被继续传递下去。如果没有错误抛出，do子句中余下的语句就会被执行。
    print("no error")
} catch VendingMachineError.InvalidSelection {
    print("InvalidSelection")
}
//catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
//    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
//}
catch {
    //如果一条catch子句没有指定匹配模式，那么这条子句可以匹配任何错误，并且把错误绑定到一个名字为error的局部常量。
    print(error) //InsufficientFunds(4)
}
/**
 *  catch子句不必将do子句中的代码所抛出的每一个可能的错误都作处理。如果所有catch子句都未处理错误，错误就会传递到周围的作用域。
 
 然而，错误还是必须要被某个周围的作用域处理的——要么是一个外围的do-catch错误处理语句，要么是一个 throwing 函数的内部。
 */

// MARK: - ### 将错误转换成可选值

//可以使用try?通过将错误转换成一个可选值来处理错误。如果在评估try?表达式时一个错误被抛出，那么表达式的值就是nil。

//如果你想对所有的错误都采用同样的方式来处理，用try?就可以让你写出简洁的错误处理代码。
let ret1 = try? buyFavoriteSnack("Alick", vendingMachine: vendingMachine)

//上面那句 类似如下操作
let ret: Void?
do {
    ret = try buyFavoriteSnack("Alick", vendingMachine: vendingMachine)
} catch {
    ret = nil
}

// MARK: - ### 禁用错误传递

//有时你知道某个 throwing 函数实际上在运行时是不会抛出错误的，在这种情况下，你可以在表达式前面写try!来禁用错误传递，这会把调用包装在一个断言不会有错误抛出的运行时断言中。如果实际上抛出了错误，你会得到一个运行时错误。

//例如，下面的代码使用了loadImage(_:)函数，该函数从给定的路径加载图片资源，如果图片无法载入则抛出一个错误。在这种情况下，因为图片是和应用绑定的，运行时不会有错误抛出，所以适合禁用错误传递：

//let photo = try! loadImage("./Resources/John Appleseed.jpg")

// MARK: - ## 指定清理操作

/*
 可以使用defer语句在即将离开当前代码块时执行一系列语句。
 
 该语句让你能执行一些必要的清理工作，不管是以何种方式离开当前代码块的——无论是由于抛出错误而离开，还是由于诸如return或者break的语句。
 */

//defer单词的意思是推迟，延迟，当程序遇到defer语句并不会马上执行，而是在这个作用域内执行完其他语句再执行defer语句（此处前提是defer之前的程序未抛出异常，异常后面的语句是不会执行的）。此外，当一个作用域内有多条defer语句时，执行的顺序是自下而上调用的。

func deferTest() {
    //defer语句将代码的执行延迟到当前的作用域退出之前。该语句由defer关键字和要被延迟执行的语句组成。
    print("begin")
    
    //defer语句在即将离开当前代码块时执行一系列语句
    defer {
        print("1") //执行先于 1.2
        
        //延迟执行的语句不能包含任何控制转移语句，例如break或是return语句，或是抛出一个错误。
        //break
        
        defer { print("1.1") }
        defer { print("1.2") }//执行先于 1.1
    }
    
    defer {
        print("2")//执行先于 2.1
        
        if NSURL(string: "ss") != nil {
            defer { print("2.1") } //执行先于 2.3,因为if代码块释放导致
        } else {
            defer { print("2.2") } //不执行
        }
        defer { print("2.3") }
    }
    
    if NSURL(string: "ss") != nil {
        defer { print("3") } //最先执行，因为defer的当前代码块是if，释放的最早
    } else {
        defer { print("4") } //不执行
    }
    
    print("end")
    defer { print("5") }
}

deferTest()
/**
 begin
 3
 end
 5
 2
 2.1
 2.3
 1
 1.2
 1.1
 */






