//: [Previous](@previous)

import UIKit

// MARK: - 多元组 (Tuple)

//多元组是我们的新朋友，多尝试使用这个新特性吧，会让生活轻松不少～
//比如交换输入，普通程序员亘古以来可能都是这么写的

func swapMe<T>(inout a: T, inout b: T) {
    let temp = a
    a = b
    b = temp
}
//但是要是使用多元组的话，我们可以不使用额外空间就完成交换，一下子就达到了文艺程序员的写法：

func swapMeBetter<T>(inout a: T, inout b: T) {
    (a,b) = (b,a)
}

//“在 Objective-C 版本的 Cocoa API 中有不少需要传递指针来获取值的地方，这一般是由于在 Objective-C 中返回值只能有一个所造成的妥协。比如 CGRect 有一个辅助方法叫做 CGRectDivide，它用来将一个 CGRect 在一定位置切分成两个区域。具体定义和用法如下：

/*
 CGRectDivide(CGRect rect, CGRect *slice, CGRect *remainder,
 CGFloat amount, CGRectEdge edge)
 
 CGRect rect = CGRectMake(0, 0, 100, 100);
 CGRect small;
 CGRect large;
 CGRectDivide(rect, &small, &large, 20, CGRectMinXEdge);
 */

//上面的代码将 {0,0,100,100} 的 rect 分割为两部分，分别是 {0,0,20,100} 的 small 和 {20,0,80,100} 的 large。
//由于 C 系语言的单一返回，我们不得不通过传入指针的方式让方法来填充需要的部分，可以说使用起来既不直观，又很麻烦。”

extension CGRect {
    //在Swift中如下，“非常简单并且易于理解了：”
    func divide(atDistance: CGFloat, fromEdge: CGRectEdge) -> (slice: CGRect, remainder: CGRect) {
        return (CGRectZero, CGRectZero)
    }
}

let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let (small, large) = rect.divide(20, fromEdge: .MinXEdge)

//: [Next](@next)
