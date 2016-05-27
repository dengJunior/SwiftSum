//
//  URLSessionGuideDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/26.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class URLSessionGuideDemo: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButtonToViewWithTitle("深入理解GCDdemo") { [unowned self] (button) in
            if let vc = PhotoCollectionViewController.newInstanceFromStoryboard("GooglyPuff", isInitial: true) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
