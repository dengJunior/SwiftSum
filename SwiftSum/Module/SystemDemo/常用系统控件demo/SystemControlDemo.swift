//
//  SystemControlDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class SystemControlDemo: YYBaseDemoController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = [
            LibDemoInfo(title: "TableViewController", desc: "图片混合blendModes", controllerName: "TableViewController"),
            LibDemoInfo(title: "CollectionViewDemo", desc: "CollectionViewDemo", controllerName: "CollectionViewDemo"),
            LibDemoInfo(title: "UIImagePickerControllerDemo", desc: "UIImagePickerControllerDemo", controllerName: "UIImagePickerControllerDemo"),
        ]
    }



}
