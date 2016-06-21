//
//  GestureDemoChild.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class GestureDemoChild: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTestView()
    }

    func addTestView() {
        let view = DeliveryTouchesDemo()
        view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(-10)
        })
    }

}
