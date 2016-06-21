//
//  DeliveryTouchesDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 五、调节触摸到视图的传递(Regulating the Delivery of Touches to Views)

/*
 1. 窗口首先把触摸发送给触摸发生的视图上关联的任何手势识别器，而不是先发送给视图对象自身。
 
 */
class DeliveryTouchesDemo: UIView, UIGestureRecognizerDelegate {

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    var imageView: UIImageView = {
        let imagView =  UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
        return imagView
    }()
    
    init() {
        super.init(frame: CGRectZero)
        self.setContext()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContext() {
        self.addPanGesture()
        self.addTapGesture()
        self.addSubview(imageView)
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.showGestureForTapRecognizer))
        tap.delegate = self
        tap.numberOfTapsRequired = 2
        tap.delaysTouchesBegan = false
        tap.delaysTouchesEnded = true
        tap.cancelsTouchesInView = true
        self.tapRecognizer = tap
        self.addGestureRecognizer(tapRecognizer)
    }
    
    /**1.默认情况
     pan.delaysTouchesBegan = false
     pan.delaysTouchesEnded = true
     pan.cancelsTouchesInView = true

     touchesBegan(_:withEvent:)
     touchesMoved(_:withEvent:)
     showGestureForPanRecognizer----UIGestureRecognizerState.Began
     touchesCancelled(_:withEvent:)
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     showGestureForPanRecognizer----UIGestureRecognizerState.Ended

     
     3.关闭cancelsTouchesInView
     pan.delaysTouchesBegan = false
     pan.delaysTouchesEnded = true
     pan.cancelsTouchesInView = false
     
     touchesBegan(_:withEvent:)
     touchesMoved(_:withEvent:)
     touchesMoved(_:withEvent:)
     touchesMoved(_:withEvent:)
     showGestureForPanRecognizer----UIGestureRecognizerState.Began
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     touchesMoved(_:withEvent:)
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     touchesMoved(_:withEvent:)
     showGestureForPanRecognizer----UIGestureRecognizerState.Changed
     touchesMoved(_:withEvent:)
     showGestureForPanRecognizer----UIGestureRecognizerState.Ended
     touchesEnded(_:withEvent:)

     */
    func addPanGesture() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.showGestureForPanRecognizer))
        pan.delegate = self
        pan.delaysTouchesBegan = false
        pan.delaysTouchesEnded = true
        pan.cancelsTouchesInView = false
        self.panRecognizer = pan
        self.addGestureRecognizer(panRecognizer)
    }
    
    func drawImageForGestureRecognizer(recognizer: UIGestureRecognizer, centerPoint: CGPoint) -> Void {
        var imageName = "rotation.png"
        if recognizer.isKindOfClass(UITapGestureRecognizer) {
            imageName = "tap.png"
        } else if recognizer.isKindOfClass(UIRotationGestureRecognizer) {
            imageName = "rotation.png"
        } else if recognizer.isKindOfClass(UISwipeGestureRecognizer) {
            imageName = "swipe.png"
        }
        imageView.image = UIImage.init(named: imageName)
        imageView.center = centerPoint
        imageView.alpha = 1.0
    }
    
    @IBAction func showGestureForTapRecognizer(sender: UITapGestureRecognizer) {
        print(#function + "----" + sender.state.stringValue)
        let location = sender.locationInView(self)
        self.drawImageForGestureRecognizer(sender, centerPoint: location)
        UIView.animateWithDuration(0.5) {
            self.imageView.alpha = 0.0
        }
    }
    
    @IBAction func showGestureForPanRecognizer(sender: UIPanGestureRecognizer) -> Void {
        print(#function + "----" + sender.state.stringValue)
        let location = sender.locationInView(self)
        self.drawImageForGestureRecognizer(sender, centerPoint: location)
        
        if sender.state == UIGestureRecognizerState.Ended ||
            sender.state == UIGestureRecognizerState.Cancelled {
            UIView.animateWithDuration(0.5) {
                self.imageView.alpha = 0.0
                self.imageView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(#function)
    }
}
