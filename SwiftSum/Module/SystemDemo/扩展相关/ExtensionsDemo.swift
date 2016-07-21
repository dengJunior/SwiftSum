//
//  ExtensionsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ExtensionsDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonToView(title: "Today扩展") { [unowned self] (button) in
            let vc = TodayDemo()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


}
