
//
//  JSExportMethodProtocol.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import JavaScriptCore

/**
 *  JSExport协议
 
 借助JSExport协议也可以在JavaScript上使用自定义对象。在JSExport协议中声明的实例方法、类方法，不论属性，都能自动与JavaScrip交互。
 */
protocol JSExportProtocol: JSExport {
    //测试几种参数的情况
    func test0()
    func test1(para: String)
    func test2(para: String, _ para2: String)
}

class JSBridgeManager {
    static func addMethod(name: String, toJSContext context: JSContext, methodObject: JSExportProtocol) {
        if let methodName = name.componentsSeparatedByString(".").first {
            context.setObject(methodObject, forKeyedSubscript: methodName)
        }
    }
    static func removeMethod(name: String, fromJSContext context: JSContext) {
        if let methodName = name.componentsSeparatedByString(".").first {
            context.setObject(nil, forKeyedSubscript: methodName)
        }
    }
}








