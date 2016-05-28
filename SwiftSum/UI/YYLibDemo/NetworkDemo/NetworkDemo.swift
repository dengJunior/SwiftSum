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

        YYApi.requestGoodDesignRecommends{  recommends in
            print(recommends);
        }
        self.addButtonToViewWithTitle("Get 请求") { [unowned self] (button) in
            if let vc = PhotoCollectionViewController.newInstanceFromStoryboard("GooglyPuff", isInitial: true) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

  
}
