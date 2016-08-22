//
//  UsefulExperienceDemo.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class UsefulExperienceDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonToView(title: "xib模块化设计") {  (button) in
            let vc = XibDemo(nibName: "XibDemo", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.addButtonToView(title: "UINavigationBar逐渐显示和隐藏") {  (button) in
            let vc = NavigationBarHideDemo()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
