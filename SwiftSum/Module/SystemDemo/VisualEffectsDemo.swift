//
//  VisualEffectsDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/5.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class VisualEffectsDemo: UIViewController {

    @IBOutlet weak var layerView1: UIView!
    @IBOutlet weak var layerView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadiusDemo()
        borderDemo()
    }
    
    // MARK: - cornerRadius
    /**
     默认情况下，cornerRadius这个曲率值只影响背景颜色而不影响背景图片或是子图层。
     不过，如果把masksToBounds设置成YES的话，图层里面的所有东西都会被截取。
     */
    func cornerRadiusDemo() {
        layerView1.layer.cornerRadius = 20
        
        layerView2.layer.cornerRadius = 20
        //enable clipping on the second layer
        layerView2.layer.masksToBounds = true
    }

    // MARK: - border
    /**
     边框是绘制在图层边界里面的，而且在所有子内容之前，也在子图层之前。
     
     仔细观察会发现边框并不会把寄宿图或子图层的形状计算进来，如果图层的子图层超过了边界，或者是寄宿图在透明区域有一个透明蒙板，边框仍然会沿着图层的边界绘制出来
     */
    func borderDemo() {
        layerView1.layer.borderWidth = 5
        
        layerView2.layer.borderWidth = 5
        layerView2.layer.borderColor = UIColor.orangeColor().CGColor
    }
}
