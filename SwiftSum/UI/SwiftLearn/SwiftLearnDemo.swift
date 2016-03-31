//
//  SwiftLearnDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

typealias DataResultBlock = (result: String, data: AnyObject!, errorMsg: String?) -> Void

protocol Api {
    func get(name: String)
    func get(name: String, dict: [String: AnyObject])
}

extension Api {
    func get(name: String, dict: [String: AnyObject]) {
        print(name, dict)
    }
    func get(name: String) {
        self.get(name, dict: ["key":"value"])
    }
}

class SwiftLearnDemo: YYBaseDemoController, Api {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataArray = [
            LibDemoInfo(title: "TheBasicsDemo", desc: "基础部分", controllerName: "TheBasicsDemo"),
        ]
        
        self.get("hello")
    }
    
    
}


