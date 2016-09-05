//
//  BackingImageDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/1.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class BackingImageDemo: UIViewController {
    @IBOutlet weak var layerView: UIView!
    
    @IBOutlet weak var coneView: UIView!
    @IBOutlet weak var shipView: UIView!
    @IBOutlet weak var iglooView: UIView!
    @IBOutlet weak var anchorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "contentsRect")!
        layerView.layer.contentsGravity = kCAGravityResizeAspect
        layerView.layer.contents = image.CGImage
        layerView.layer.contentsScale = image.scale
        
        addSpriteImage(image, contentsRect: CGRect(x: 0, y: 0, width: 0.5, height: 0.5), to: coneView.layer)
        addSpriteImage(image, contentsRect: CGRect(x: 0.5, y: 0, width: 0.5, height: 0.5), to: shipView.layer)
        addSpriteImage(image, contentsRect: CGRect(x: 0, y: 0.5, width: 0.5, height: 0.5), to: iglooView.layer)
        addSpriteImage(image, contentsRect: CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5), to: anchorView.layer)
        
        
        addLayer()
    }
    
    // MARK: - CALayer的contentsRect属性允许我们在图层边框里显示寄宿图的一个子域
    func addSpriteImage(image: UIImage, contentsRect: CGRect, to layer: CALayer) {
        layer.contents = image.CGImage
        layer.contentsRect = contentsRect
        layer.contentsGravity = kCAGravityResizeAspect
    }
    
    func addLayer() {
        let blueLayer = CALayer()
        blueLayer.frame = CGRect(x: 50, y: 380, width: 100, height: 100)
        blueLayer.backgroundColor = UIColor.blueColor().CGColor
        
        //ensure that layer backing image uses correct scale
        blueLayer.contentsScale = UIScreen.mainScreen().scale
        view.layer.addSublayer(blueLayer)
        blueLayer.delegate = self
        
        //force layer to redraw
        //不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者。
        blueLayer.display()
        
        //尽管我们没有用masksToBounds属性，绘制的那个圆仍然沿边界被裁剪了。这是因为当你使用CALayerDelegate绘制寄宿图的时候，并没有对超出边界外的内容提供绘制支持。
    }
    
    // MARK: - 实现CALayerDelegate
    /**
     给contents赋CGImage的值不是唯一的设置寄宿图的方法。
     我们也可以直接用Core Graphics直接绘制寄宿图。
     通过CALayerDelegate实现
     */
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        //draw a thick red circle
        CGContextSetLineWidth(ctx, 10)
        CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor)
        CGContextStrokeEllipseInRect(ctx, layer.bounds)
    }
}




















