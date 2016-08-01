//
//  XibDemoView.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class XibDemoView: YYXibView {

    @IBOutlet weak var title: UILabel!
    @IBAction func dianWo(sender: UIButton) {
        title.text = "xib模块化设计 demo"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.text = "XibDemoView"
    }
}
