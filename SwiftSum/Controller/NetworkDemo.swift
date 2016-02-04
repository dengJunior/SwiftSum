//
//  NetworkDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 16/2/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class NetworkDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        MllApi.getRecommend {  recommends in
            print(recommends);
        }
    }

  
}
