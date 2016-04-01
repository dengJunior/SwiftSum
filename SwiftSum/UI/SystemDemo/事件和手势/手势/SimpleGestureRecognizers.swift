//
//  SimpleGestureRecognizers.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


class SimpleGestureRecognizers: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    @IBOutlet weak var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet var swipeLeftRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var swipeRightRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var rotateRecognizer: UIRotationGestureRecognizer!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var panRecognizer: UIPanGestureRecognizer!
    
    var imageView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 30))
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addPanGesture()
        
//        self.removeGestureRecognizer(tapRecognizer)
//        self.removeGestureRecognizer(swipeLeftRecognizer)
        self.removeGestureRecognizer(swipeRightRecognizer)
        self.removeGestureRecognizer(rotateRecognizer)
        
        tapRecognizer.delegate = nil
        rotateRecognizer.delegate = nil
        swipeLeftRecognizer.delegate = nil
        swipeRightRecognizer.delegate = nil
        
        
        self.addSubview(imageView)
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
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
    
    // MARK: - Action
    
    @IBAction func takeLeftSwipeRecognitionEnabledFrom(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.addGestureRecognizer(swipeLeftRecognizer)
        } else {
            self.removeGestureRecognizer(swipeLeftRecognizer)
        }
    }
    
    @IBAction func showGestureForTapRecognizer(sender: UITapGestureRecognizer) {
        print(#function + " " + sender.state.stringValue)
        let location = sender.locationInView(self)
        self.drawImageForGestureRecognizer(sender, centerPoint: location)
        UIView.animateWithDuration(0.5) { 
            self.imageView.alpha = 0.0
        }
    }
    
    @IBAction func showGestureForSwipeRecognizer(sender: UISwipeGestureRecognizer) {
        print(#function + " " + sender.state.stringValue)
        var location = sender.locationInView(self)
        self.drawImageForGestureRecognizer(sender, centerPoint: location)
        
        if sender.direction == UISwipeGestureRecognizerDirection.Left {
            location.x -= 80
        } else {
            location.x += 80
        }
        UIView.animateWithDuration(0.5) {
            self.imageView.alpha = 0.0
            self.imageView.center = location;
        }
    }
    
    @IBAction func showGestureForRotation(sender: UIRotationGestureRecognizer) {
        print(#function + " " + sender.state.stringValue)
        let location = sender.locationInView(self)
        let transform = CGAffineTransformMakeRotation(sender.rotation)
        imageView.transform = transform
        self.drawImageForGestureRecognizer(sender, centerPoint: location)
        
        if sender.state == UIGestureRecognizerState.Ended ||
            sender.state == UIGestureRecognizerState.Cancelled {
            UIView.animateWithDuration(0.5) {
                self.imageView.alpha = 0.0
                self.imageView.transform = CGAffineTransformIdentity
            }
        }
    }
    
    
    func showGestureForPanRecognizer(sender: UIPanGestureRecognizer) -> Void {
        print(#function + " " + sender.state.stringValue)
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
    
    // MARK: - Private
    
    func addPanGesture() {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.showGestureForPanRecognizer))
        pan.delegate = self
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
    
    // MARK: - Public
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        print(#function)
        //禁止在segmentedControl上响应tap手势
        
        /**
         *  在iOS 6.0 或以后版本中，默认控件操作方法防止(prevent)重复手势识别的行为。
         比如，一个按钮的默认操作是一个单击。
         如果你有一个单击手势识别绑定到一个按钮的父视图上，然后用户点击该按钮，
         最后按钮的操作方法接收触摸事件而不是手势识别。
         */
        if touch.view == self.segmentedControl && gestureRecognizer == tapRecognizer {
            //不过return true也不会响应tap事件
            return false
        }
        return true
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function + " " + gestureRecognizer.classNameString)
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function + ",gestureRecognizer=" + gestureRecognizer.classNameString + ",otherGestureRecognizer=" + otherGestureRecognizer.classNameString)
        return false;
    }
    
    //询问是否otherGestureRecognizer手势判断失败，这个手势才开始执行
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function + ",gestureRecognizer=" + gestureRecognizer.classNameString + ",otherGestureRecognizer=" + otherGestureRecognizer.classNameString)
        //swipeLeftRecognizer手势失败后才响应panRecognizer手势
        if gestureRecognizer == panRecognizer && otherGestureRecognizer == swipeLeftRecognizer{
            return true
        }
        
        return false;
    }
    
    //询问是否这个手势是通过otherGestureRecognizer手势的触发才失败
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == panRecognizer && otherGestureRecognizer == swipeLeftRecognizer{
//            return true
//        }
//        print(#function)
//        return true;
//    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, canBePreventedByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function + ",gestureRecognizer=" + gestureRecognizer.classNameString + ",otherGestureRecognizer=" + otherGestureRecognizer.classNameString)
        return false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, canPreventGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function + ",gestureRecognizer=" + gestureRecognizer.classNameString + ",otherGestureRecognizer=" + otherGestureRecognizer.classNameString)
        return false
    }
    
}

extension UIGestureRecognizerState {
    var stringValue: String {
        switch self {
        case UIGestureRecognizerState.Possible:
            return "UIGestureRecognizerState.Possible"
        case UIGestureRecognizerState.Began:
            return "UIGestureRecognizerState.Began"
        case UIGestureRecognizerState.Changed:
            return "UIGestureRecognizerState.Changed"
        case UIGestureRecognizerState.Ended:
            return "UIGestureRecognizerState.Ended"
        case UIGestureRecognizerState.Cancelled:
            return "UIGestureRecognizerState.Cancelled"
        case UIGestureRecognizerState.Failed:
            return "UIGestureRecognizerState.Failed"
//        case UIGestureRecognizerState.Recognized:
//            return "UIGestureRecognizerState.Recognized"
//        default:
//            return "unkonwn"
        }
    }
}


