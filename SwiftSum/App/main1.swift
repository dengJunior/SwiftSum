//
//  main.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/3/18.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import UIKit

//其实 Swift 的 app 也是需要 main 函数的，只不过默认情况下是 @UIApplicationMain 帮助我们自动生成了而已。和 C 系语言的 main.c 或者 main.m 文件一样，Swift 项目也可以有一个名为 main.swift 特殊的文件。在这个文件中，我们不需要定义作用域，而可以直接书写代码。这个文件中的代码将作为 main 函数来执行。比如我们在删除 @UIApplicationMain 后，在项目中添加一个 main.swift 文件，然后加上这样的代码：

//我们还可以通过将第三个参数替换成自己的 UIApplication 子类，这样我们就可以轻易地做一些控制整个应用行为的事情了。
class MyApplication: UIApplication {
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
        //这样每次发送事件 (比如点击按钮) 时，我们都可以监听到这个事件了。
        //println("Event sent: \(event)");
    }
}

//UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(MyApplication), NSStringFromClass(AppDelegate))

