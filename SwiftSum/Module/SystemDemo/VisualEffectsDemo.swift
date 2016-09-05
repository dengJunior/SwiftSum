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
    
    @IBOutlet weak var imageViewOrigin: UIImageView!
    @IBOutlet weak var imageViewOriginMasked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadiusDemo()
        borderDemo()
        shadowDemo()
        shadowPathDemo()
        maskDemo()
    }
    
    // MARK: - 1. cornerRadius
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

    // MARK: - 2. border
    /**
     边框是绘制在图层边界里面的，而且在所有子内容之前，也在子图层之前。
     
     仔细观察会发现边框并不会把寄宿图或子图层的形状计算进来，如果图层的子图层超过了边界，或者是寄宿图在透明区域有一个透明蒙板，边框仍然会沿着图层的边界绘制出来
     */
    func borderDemo() {
        layerView1.layer.borderWidth = 5
        
        layerView2.layer.borderWidth = 5
        layerView2.layer.borderColor = UIColor.orangeColor().CGColor
    }
    
    // MARK: - 3. shadow
    /**
     给shadowOpacity属性一个大于默认值（也就是0）的值(在0.0（不可见）和1.0（完全不透明）之间的浮点数)，阴影就可以显示在任意图层之下。
     
     和图层边框不同，图层的阴影继承自内容的外形，而不是根据边界和角半径来确定。
     为了计算出阴影的形状，Core Animation会将寄宿图（包括子视图，如果有的话）考虑在内，然后通过这些来完美搭配图层形状从而创建一个阴影
     
     
     当阴影和裁剪扯上关系的时候就有一个头疼的限制：阴影通常就是在Layer的边界之外，如果你开启了masksToBounds属性，所有从图层中突出来的内容都会被才剪掉。
     maskToBounds属性裁剪掉了阴影和内容，可以用一个额外的视图来解决阴影裁切的问题
     */
    func shadowDemo() {
        layerView1.layer.shadowOpacity = 0.5
        
        //shadowOffset属性控制着阴影的方向和距离。它是一个CGSize的值，宽度控制这阴影横向的位移，高度控制着纵向的位移。shadowOffset的默认值是 {0, -3}，意即阴影相对于Y轴有3个点的向上位移。
        layerView1.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        
        //shadowRadius属性控制着阴影的模糊度，当它的值是0的时候，阴影就和视图一样有一个非常确定的边界线。当值越来越大的时候，边界线看上去就会越来越模糊和自然。苹果自家的应用设计更偏向于自然的阴影，所以一个非零值再合适不过了。
        layerView1.layer.shadowRadius = 5
        
        layerView2.layer.shadowOpacity = 0.5
        layerView2.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layerView2.layer.shadowRadius = 5
    }
    
    // MARK: - 5. shadowPath
    
    /**
     我们已经知道图层阴影并不总是方的，而是从图层内容的形状继承而来。
     这看上去不错，但是实时计算阴影也是一个非常消耗资源的，尤其是图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。
     如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个shadowPath来提高性能。
     */
    func shadowPathDemo() {
        //create a square shadow
        let squarePath = CGPathCreateMutable()
        CGPathAddRect(squarePath, nil, layerView2.bounds)
        layerView2.layer.shadowPath = squarePath
    }
    
    // MARK: - 6. mask 图层蒙板
    
    /**
     *  使用一个32位有alpha通道的png图片通常是创建一个无矩形视图最方便的方法，你可以给它指定一个透明蒙板来实现。但是这个方法不能让你以编码的方式动态地生成蒙板，也不能让子图层或子视图裁剪成同样的形状。
     
     CALayer有一个属性叫做mask可以解决这个问题。这个属性本身就是个CALayer类型，有和其他图层一样的绘制和布局属性。它类似于一个子图层，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子图层。不同于那些绘制在父图层中的子图层，mask图层定义了父图层的部分可见区域。
     
     如果mask图层比父图层要小，只有在mask图层里面的内容才是它关心的，除此以外的一切都会被隐藏起来。
     */
    func maskDemo() {
        let maskLayer = CALayer()
        maskLayer.frame = imageViewOrigin.bounds
        maskLayer.contents = UIImage(named: "talk")?.CGImage
        
        imageViewOriginMasked.image = imageViewOrigin.image
        imageViewOriginMasked.layer.mask = maskLayer
    }
    
}


























