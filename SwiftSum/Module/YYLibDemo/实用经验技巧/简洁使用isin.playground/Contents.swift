//: Playground - noun: a place where people can play

import UIKit

/**
 大家应该常遇到在table view的delegate里处理若干个cell的问题.
 很多人的条件语句是这样的:
 */

let indexPath = NSIndexPath()

if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 {
    // do something
}

/**
 缺点显而易见, 解决方案
 
 简单处理下,可以将所有可能放到数组或者范围(如果连续)中.然后调用其contains方法用于校验.代码如下:
 */
if (2...8).contains(indexPath.row) {
    
}

/**
 优化
 
 这样虽然解决了前提所述的两个问题,但是写法不够美观,语义不够清晰.
 */
extension Int {
    func isIn(rang: Range) -> Bool {
        return rang.contains(self)
    }
    
//    func isIn(ints: T) -> Bool {
//        return ints.contains(self)
//    }
    
    func isIn(ints: Int...) -> Bool {
        return ints.contains(self)
    }
}
















