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
        self.addSubview(imageView)
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
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
        let location = sender.locationInView(self)
        self.drawImageForGestureRecognizer(sender, centerPoint: location)
        UIView.animateWithDuration(0.5) { 
            self.imageView.alpha = 0.0
        }
    }
    
    @IBAction func showGestureForSwipeRecognizer(sender: UISwipeGestureRecognizer) {
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
        //禁止在segmentedControl上响应tap手势
        if touch.view == self.segmentedControl && gestureRecognizer == tapRecognizer {
            return false
        }
        return true
    }
    
    
}
