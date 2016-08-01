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
            //            let vc = XibDemo.newInstanceFromStoryboard("YYLibDemo", storyboardId: "XibDemo", isInitial: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
