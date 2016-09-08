//
//  CubeView.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

// MARK: - 固体对象
class CubeView: YYXibView {

    @IBOutlet var faces: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        resolveEvent()
    }

    func setupUI() {
        up1()
    }
    
    /*
     正面1朝上的立方体
     注意，这里每个face里面的label如果设置了和view等边的约束，结果会显示不对
     */
    func up1() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500
        
        /**
         绕Y轴旋转45度，并且绕X轴旋转45度。现在从另一个角度去观察立方体，就能看出它的真实面貌
         */
        perspective = CATransform3DRotate(perspective, -CGFloat(M_PI_4), 1, 0, 0)
        perspective = CATransform3DRotate(perspective, -CGFloat(M_PI_4), 0, 1, 0)
        self.layer.sublayerTransform = perspective
        
        /*
         CATransform3D CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloat tz)
         tx：X轴偏移位置，往下为正数。
         ty：Y轴偏移位置，往右为正数。
         tz：Z轴偏移位置，往外为正数。
         */
        
        //add cube face 1
        var transform = CATransform3DMakeTranslation(0, 0, 100)
        addFace(0, transform: transform)
        
        //add cube face 2
        transform = CATransform3DMakeTranslation(100, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0)
        addFace(1, transform: transform)
        
        //add cube face 3
        transform = CATransform3DMakeTranslation(0, -100, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 1, 0, 0)
        addFace(2, transform: transform)
        
        //add cube face 4
        transform = CATransform3DMakeTranslation(0, 100, 0)
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 1, 0, 0)
        addFace(3, transform: transform)
        
        //add cube face 5
        transform = CATransform3DMakeTranslation(-100, 0, 0)
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 0, 1, 0)
        addFace(4, transform: transform)
        
        //add cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -100)
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0)
        addFace(5, transform: transform)
    }
    
    func addFace(index: Int, transform: CATransform3D) {
        let face = faces[index]
        face.layer.doubleSided = false
        addSubview(face)
        let containerSize = bounds.size
        //center the face view within the container
        face.center = CGPoint(x: containerSize.width/2, y: containerSize.height/2)
        face.layer.transform = transform
    }
    
    // MARK: - 光亮和阴影
    
    /**
     Core Animation可以用3D显示图层，但是它对光线并没有概念。如果想让立方体看起来更加真实，需要自己做一个阴影效果。你可以通过改变每个面的背景颜色或者直接用带光亮效果的图片来调整。
     
     如果需要动态地创建光线效果，你可以根据每个视图的方向应用不同的alpha值做出半透明的阴影图层，但为了计算阴影图层的不透明度，你需要得到每个面的正太向量（垂直于表面的向量），然后根据一个想象的光源计算出两个向量叉乘结果。叉乘代表了光源和图层之间的角度，从而决定了它有多大程度上的光亮。
     */
    func appleyLightingToFace(face: CALayer) {
        //add lighting layer
        let layer = CALayer()
        layer.frame = face.bounds
        face.addSublayer(layer)
        
    }
    
    // MARK: - 点击事件
    /**
     你应该能注意到现在可以在第三个表面的顶部看见按钮了，点击它，什么都没发生，为什么呢？
     
     这并不是因为iOS在3D场景下正确地处理响应事件，实际上是可以做到的。问题在于视图顺序。在第三章中我们简要提到过，点击事件的处理由视图在父视图中的顺序决定的，并不是3D空间中的Z轴顺序。
     当给立方体添加视图的时候，我们实际上是按照一个顺序添加，所以按照视图/图层顺序来说，4，5，6在3的前面。
     
     
     你也许认为把doubleSided设置成NO可以解决这个问题，因为它不再渲染视图后面的内容，但实际上并不起作用。因为背对相机而隐藏的视图仍然会响应点击事件（这和通过设置hidden属性或者设置alpha为0而隐藏的视图不同，那两种方式将不会响应事件）。所以即使禁止了双面渲染仍然不能解决这个问题（虽然由于性能问题，还是需要把它设置成NO）。
     
     解决：
     1. 把除了表面3的其他视图userInteractionEnabled属性都设置成NO来禁止事件传递。
     2. 或者简单通过代码把视图3覆盖在视图6上。
     */
    func resolveEvent() {
        for i in 3..<faces.count {
            faces[i].userInteractionEnabled = false
        }
    }

}



























