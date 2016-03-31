//
//  EnumerationsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/16.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit


/**
 *  在 C 语言中枚举指定相关名称为一组整型值。
 Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。
 如果一个值（被认为是“原始”值）被提供给每个枚举成员，则该值可以是一个字符串，一个字符，或是一个整型值或浮点值。
 */
 
// MARK: - 在 Swift 中，枚举类型是一等（first-class）类型。它们采用了很多传统上只被类（class）所支持的特征，

class EnumerationsDemo: YYBaseDemoController {
    
    // MARK: - Swift 的枚举成员在被创建时不会被赋予一个默认的整数值。
    enum CompassPoint {
        case North         //case关键词表明新的一行成员值将被定义。
        case South, East    //多个成员值可以出现在同一行上，用逗号隔开：
        case West
    }
    
    // MARK: - 关联值（Associated Values）
    //一个枚举的成员可以声明它们存储不同类型的关联值。
    
    /**
    定义一个名为Barcode的枚举类型，它的一个成员值是具有(Int，Int，Int，Int)类型关联值的UPCA，或者是具有String类型关联值的QRCode。
    */
    enum Barcode {
        case UPCA(Int, Int, Int, Int)
        case QRCode(String)
    }
    
    func enumerationsDemo() {
        var point = CompassPoint.North
        print("\(point)")  //(Enum Value)
        
        point = .South  //被声明为一个CompassPoint，你可以使用更短的点（.）语法将其设置为另一个CompassPoint的值：
        
        
        
        let directionToHead = CompassPoint.South
        
        // MARK: - 在判断一个枚举类型的值时，switch语句必须穷举所有情况。
        switch directionToHead {
        case .North:
            print("Lots of planets have a north")
        case .South:
            print("Watch out for penguins")
        case .East:
            print("Where the sun rises")
        case .West:
            print("Where the skies are blue")
        }
        // 输出 "Watch out for penguins”
        
        
        var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)

    }
}
