//
//  NewFeatureDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class NewFeatureDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtonToView(title: "iOS7改动") { [unowned self] (button) in
            let vc = iOS7Feature()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
