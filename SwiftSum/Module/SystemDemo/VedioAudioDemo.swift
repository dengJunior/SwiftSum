//
//  VedioAudioDemo.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class VedioAudioDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addButtonToView(title: "dd") { [weak self] (button) in
            if self {
                
            }
        }
    }


}
