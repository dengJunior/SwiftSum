//
//  NavigationDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class NavigationDemo: UIViewController {
    
    let navigationDelegate = YYNavigationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var buttonCount = 1;
        
        buttonCount += 1
        self.addButtonToView("仿系统push动画", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            let vc = TableViewController1()
            // 设置动画代理 
            //self.navigationController?.delegate = strongReferenceDelegate 解决了弱引用的问题，这行代码应该放在哪里执行呢？
            /**
             *  很多人喜欢在viewDidLoad()做一些配置工作，但在这里设置无法保证是有效的，因为这时候控制器可能尚未进入 NavigationController 的控制器栈，self.navigationController返回的可能是 nil；
             */
            self.navigationController?.delegate = self.navigationDelegate
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        buttonCount += 1
        self.addButtonToView("替换系统pop交互动画", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            let vc = PopViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
