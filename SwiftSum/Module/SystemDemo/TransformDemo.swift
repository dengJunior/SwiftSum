//
//  TransformDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class TransformDemo: UIViewController {

    @IBOutlet weak var imageViewRotateY: UIImageView!
    var imageViewRotateY2: UIImageView!
    
    @IBOutlet weak var containerViewSublayerTransform: UIView!
    @IBOutlet weak var imageViewSublayerTransform1: UIImageView!
    @IBOutlet weak var imageViewSublayerTransform2: UIImageView!
    
    @IBOutlet weak var imageViewDoubSided1: UIImageView!
    @IBOutlet weak var imageViewDoubSided2: UIImageView!
    
    @IBOutlet weak var flatView1: UIView!
    @IBOutlet weak var flatView2: UIView!
    
    @IBOutlet weak var flatView3: UIView!
    @IBOutlet weak var flatView4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        threeDDemo()
        sublayerTransformDemo()
        doubleSidedDemo()
        flatLayerDemo()
    }


    // MARK: - 2. 3D变换
    
    /**
     CG的前缀告诉我们，CGAffineTransform类型属于Core Graphics框架，Core Graphics实际上是一个严格意义上的2D绘图API，并且CGAffineTransform仅仅对2D变换有效。
     
     在第三章中，我们提到了zPosition属性，可以用来让图层靠近或者远离相机（用户视角），transform属性（CATransform3D类型）可以真正做到这点，即让图层在3D空间内移动或者旋转。
     
     和CGAffineTransform类似，CATransform3D也是一个矩阵，但是和2x3的矩阵不同，CATransform3D是一个可以在3维空间内做变换的4x4的矩阵
     */
    func threeDDemo() {
        /**
         绕Z轴的旋转等同于之前二维空间的仿射旋转，但是绕X轴和Y轴的旋转就突破了屏幕的二维空间，并且在用户视角看来发生了倾斜。
         */
        
        //绕Y轴旋转图层45
        let transform = CATransform3DMakeRotation(CGFloat(M_PI_4), 0, 1, 0)
        imageViewRotateY.layer.transform = transform
        
        /**
         CATransform3D的透视效果通过一个矩阵中一个很简单的元素来控制：m34。
         用于按比例缩放X和Y的值来计算到底要离视角多远。
         
         m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了。
         */
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500 //通常500-1000就已经很好了，但对于特定的图层有时候更小或者更大的值会看起来更舒服，减少距离的值会增强透视效果
        perspective = CATransform3DRotate(perspective, CGFloat(M_PI_4), 0, 1, 0)
        
        //注意，这里用约束的话，可能看不到效果
        let imageView = UIImageView(frame: imageViewRotateY.frame)
        imageView.image = imageViewRotateY.image
        view.addSubview(imageView)
        
        imageView.frame.origin.x += 140
        imageView.layer.transform = perspective
        
        imageViewRotateY2 = imageView
    }
    
    // MARK: - sublayerTransform
    /**
     如果有多个视图或者图层，每个都做3D变换，那就需要分别设置相同的m34值，并且确保在变换之前都在屏幕中央共享同一个position，如果用一个函数封装这些操作的确会更加方便，但仍然有限制（例如，你不能在Interface Builder中摆放视图），这里有一个更好的方法。
     
     CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
     
     相较而言，通过在一个地方设置透视变换会很方便，同时它会带来另一个显著的优势：灭点被设置在容器图层的中点，从而不需要再对子图层分别设置了。这意味着你可以随意使用position和frame来放置子图层，而不需要把它们放置在屏幕中点，然后为了保证统一的灭点用变换来做平移。
     */
    func sublayerTransformDemo() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500
        containerViewSublayerTransform.layer.sublayerTransform = perspective
        
        
        let transform1 = CATransform3DMakeRotation(CGFloat(M_PI_4), 0, 1, 0)
        imageViewSublayerTransform1.layer.transform = transform1
        
        let transform2 = CATransform3DMakeRotation(-CGFloat(M_PI_4), 0, 1, 0)
        imageViewSublayerTransform2.layer.transform = transform2
    }
    
    // MARK: - doubleSided
    /**
     图层是双面绘制的，反面显示的是正面的一个镜像图片。
     CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。结果是完全没有东西
     */
    func doubleSidedDemo() {
        let transform1 = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
        imageViewDoubSided1.layer.transform = transform1
        
        imageViewDoubSided2.layer.transform = transform1
        imageViewDoubSided2.layer.doubleSided = false
    }
    
    // MARK: - 扁平化图层
    
    /**
     如果内部图层相对外部图层做了相反的变换（这里是绕Z轴的旋转），那么按照逻辑这两个变换将被相互抵消。
     
     3D情况下再试一次。修改代码，让内外两个视图绕Y轴旋转而不是Z轴，再加上透视效果，以便我们观察。注意不能用sublayerTransform属性，因为内部的图层并不直接是容器图层的子图层
     
     绕Y轴做相反旋转的结果不如预期那样
     这是由于尽管Core Animation图层存在于3D空间之内，但它们并不都存在同一个3D空间。每个图层的3D场景其实是扁平化的，当你从正面观察一个图层，看到的实际上由子图层创建的想象出来的3D场景，但当你倾斜这个图层，你会发现实际上这个3D场景仅仅是被绘制在图层的表面。
     
     类似的，当你在玩一个3D游戏，实际上仅仅是把屏幕做了一次倾斜，或许在游戏中可以看见有一面墙在你面前，但是倾斜屏幕并不能够看见墙里面的东西。所有场景里面绘制的东西并不会随着你观察它的角度改变而发生变化；图层也是同样的道理。
     CALayer有一个叫做CATransformLayer的子类来解决这个问题。
     */
    func flatLayerDemo() {
        let rotateZ45 = CATransform3DMakeRotation(CGFloat(M_PI_4), 0, 0, 1)
        let rotateZ45N = CATransform3DMakeRotation(-CGFloat(M_PI_4), 0, 0, 1)
        flatView1.layer.transform = rotateZ45
        flatView2.layer.transform = rotateZ45N
        
        var rotateY45 = CATransform3DIdentity
        rotateY45.m34 = -1.0 / 500
        rotateY45 = CATransform3DRotate(rotateY45, CGFloat(M_PI_4), 0, 1, 0)
        
        var rotateY45N = CATransform3DIdentity
        rotateY45N.m34 = -1.0 / 500
        rotateY45N = CATransform3DRotate(rotateY45N, -CGFloat(M_PI_4), 0, 1, 0)
        
        flatView3.layer.transform = rotateY45
        flatView4.layer.transform = rotateY45N
    }
}


























