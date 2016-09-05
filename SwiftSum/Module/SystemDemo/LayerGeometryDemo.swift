//
//  LayerGeometryDemo.swift
//  SwiftSum
//
//  Created by yangyuan on 2016/9/2.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class LayerGeometryDemo: UIViewController {
    var hourHand: UIImageView!
    var miniteHand: UIImageView!
    var secondHande: UIImageView!
    weak var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //anchorPointDemo()
        geometryFlippedDemo()
    }
    
    func anchorPointDemo() {
        /*
         也许在图片末尾添加一个透明空间也是个解决方案，但这样会让图片变大，也会消耗更多的内存，这样并不优雅。
         
         更好的方案是使用anchorPoint属性
         */
        hourHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        miniteHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        secondHande.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        timer = NSTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        //set initial hand positions
        tick()
    }
    
    // MARK: - 模拟闹钟的demo演示修改anchorPoint
    func tick() {
        //convert time to hours, minutes and seconds
        let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierBuddhist)!
        let units: NSCalendarUnit = [.Hour, .Minute, .Second]
        let components = calender.components(units, fromDate: NSDate())
        
        //calculate hour hand angle //calculate minute hand angle
        let hoursAngle = CGFloat((Double(components.hour)/12.0) * M_PI * 2.0)
        let minsAngle = CGFloat((Double(components.minute)/60.0) * M_PI * 2.0)
        let secseAngle = CGFloat((Double(components.second)/60.0) * M_PI * 2.0)
        
        hourHand.transform = CGAffineTransformMakeRotation(hoursAngle)
        miniteHand.transform = CGAffineTransformMakeRotation(minsAngle)
        secondHande.transform = CGAffineTransformMakeRotation(secseAngle)
    }
    
    
    @IBOutlet weak var geometryFlippedView: UIView!
    @IBOutlet weak var geometryFlippedView2: UIView!
    @IBOutlet weak var geometryFlippedView2Label: UILabel!
    
    /**
     翻转的几何结构
     
     常规说来，在iOS上，一个图层的position位于父图层的左上角，但是在Mac OS上，通常是位于左下角。Core Animation可以通过geometryFlipped属性来适配这两种情况，它决定了一个图层的坐标是否相对于父图层垂直翻转，是一个BOOL类型。在iOS上通过设置它为YES意味着它的子图层将会被垂直翻转，也就是将会沿着底部排版而不是通常的顶部（它的所有子图层也同理，除非把它们的geometryFlipped属性也设为YES）。

     */
    func geometryFlippedDemo() {
        geometryFlippedView.layer.geometryFlipped = true
        geometryFlippedView2.layer.geometryFlipped = true
        geometryFlippedView2Label.layer.geometryFlipped = true
    }
    
    // MARK: - hitTesting
    /**
     第一章“图层树”证实了最好使用图层相关视图，而不是创建独立的图层关系。其中一个原因就是要处理额外复杂的触摸事件。
     CALayer并不关心任何响应链事件，所以不能直接处理触摸事件或者手势。但是它有一系列的方法帮你处理事件：-containsPoint:和-hitTest:。
     */
    func hitTestingDemo() {
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let point = touches.first?.locationInView(view) else {
            return
        }
        
        var title = ""
        
        // MARK: - hitTest
        let layer = view.layer.hitTest(point)
        /**
         注意当调用图层的-hitTest:方法时，测算的顺序严格依赖于图层树当中的图层顺序（和UIView处理事件类似）。之前提到的zPosition属性可以明显改变屏幕上图层的顺序，但不能改变事件传递的顺序。
         
         这意味着如果改变了图层的z轴顺序，你会发现将不能够检测到最前方的视图点击事件，这是因为被另一个图层遮盖住了，虽然它的zPosition值较小，但是在图层树中的顺序靠前。我们将在第五章详细讨论这个问题。
         */
        
        if layer != nil && layer! == geometryFlippedView.layer {
            title = "Inside geometryFlippedView Layer"
        } else {
            title = "Outside geometryFlippedView Layer"
        }
        
        // MARK: containsPoint
        //convert point to the white layer's coordinates
        let layerPoint = geometryFlippedView.layer.convertPoint(point, fromLayer: view.layer)
        //get layer using containsPoint:
        if geometryFlippedView.layer.containsPoint(layerPoint) {
            title = "Inside geometryFlippedView Layer"
        } else {
            title = "Outside geometryFlippedView Layer"
        }
        
        let alert = UIAlertController(title: title, message: title, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
































