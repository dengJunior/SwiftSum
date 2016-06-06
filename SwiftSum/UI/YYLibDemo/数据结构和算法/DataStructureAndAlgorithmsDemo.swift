//
//  DataStructureAndAlgorithmsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/30.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class DataStructureAndAlgorithmsDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButtonToViewWithTitle("排序demo") {  (button) in
            AlgorithmsDemo.launch()
        }
    }
    
    
    
}
