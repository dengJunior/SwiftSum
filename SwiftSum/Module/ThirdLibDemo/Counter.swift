//
//  Counter.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/**
 应用状态 (13:50)
 
 我们如何通过这个框架来搭建应用呢？
 首先让我们先看一下应用状态的模样。应用状态实际上是一个数据结构，并且当它从缓存中读取出来的时候，它应该是一个不可修改的结构体，同时也是一个独一无二的状态副本。

 */
struct CounterState: StateType {
    //应用的具体业务逻辑相当简单，就是一个计数变量
    var counter: Int = 0
}

class Counter: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    func newState(state: CounterState) {
        timeLabel.text = "\(state.counter)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterStore.subscribe(self)
    }
    
    
    @IBAction func tapDown(sender: UIButton) {
        counterStore.dispatch(CounterActionDecrease())
    }
    @IBAction func tapUp(sender: UIButton) {
        counterStore.dispatch(CounterActionIncrease())
    }
}
