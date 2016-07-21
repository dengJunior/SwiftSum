//
//  URLSessionGuideDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class URLSessionGuideDemo: UIViewController {
    
    let sessionDemo = NSURLSessionDemo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButtonToView(title: "测试https认证") { [unowned self] (button) in
            self.sessionDemo.httpsTask()
        }
    }
}
