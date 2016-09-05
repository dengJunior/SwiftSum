//
//  CoreAnimationDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/1.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class CoreAnimationDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addButtonToView(title: "2-寄宿图相关") { [weak self] (button) in
            self?.navigationController?.pushViewController(BackingImageDemo(), animated: true)
        }
        self.addButtonToView(title: "3-图层几何学") { [weak self] (button) in
            self?.navigationController?.pushViewController(LayerGeometryDemo(), animated: true)
        }
        self.addButtonToView(title: "4-视觉效果") { [weak self] (button) in
            self?.navigationController?.pushViewController(VisualEffectsDemo(), animated: true)
        }
    }
}

