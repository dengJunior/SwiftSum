//
//  IsIn.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


func testtt() {
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
    if [2,4,6,9].contains(indexPath.row) {
        // do something
    }
    
    // 匹配运算符
    if 2...8 ~= indexPath.row {
        
    }
    
    //优化后
    if indexPath.row.isIn(0...5) {
        
    }
    
    if indexPath.row.isIn([2,4,8]) {
        
    }
    
    if indexPath.row.isIn(2,4,8) {
        
    }
    
    
}


/**
 优化
 
 这样虽然解决了前提所述的两个问题,但是写法不够美观,语义不够清晰.
 */
extension Int {
    func isIn(rang: Range<Int>) -> Bool {
        return rang.contains(self)
    }
    
    func isIn(ints: [Int]) -> Bool {
        return ints.contains(self)
    }
    
    //使用可变参数函数来避免必须将参数放入数组
    func isIn(ints: Int...) -> Bool {
        return ints.contains(self)
    }
}

/**
 这样实现了美观简洁地使用,但是还不够通用.比如UInt,Float等可以支持Range或数组的类型却无法使用.如果要更加通用,必须研究下contains函数,其定义如下:
 */
extension Equatable {
    func isIn(collection: Self...) -> Bool {
        return collection.contains(self)
    }
}












