//
//  ThirdLibDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/2/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ThirdLibDemo: YYBaseDemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataArray = [
            LibDemoInfo(title: "ReduxDemo", desc: "ReduxDemo", controllerName: "ReduxDemo"),
            LibDemoInfo(title: "RxSwiftDemo", desc: "RxSwiftDemo", controllerName: "RxSwiftDemo"),
        ]
    }
}
