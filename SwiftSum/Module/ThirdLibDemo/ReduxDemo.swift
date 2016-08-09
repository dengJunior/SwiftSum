//
//  ReduxDemo.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ReduxDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonToView(title: "Redux架构写的计数器") {  (button) in
            let vc = Counter()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.addButtonToView(title: "组件模式写的TodoList") {  (button) in
            let vc = TodoListDemo()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}