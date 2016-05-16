//
//  YYHud.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 显示配置
struct YYHudOpitions: OptionSetType {
    var rawValue = 0  // 因为RawRepresentable的要求
    
    static var Dim = YYHudOpitions(rawValue: 1 << 0)//灰色模板
    static var Modal = YYHudOpitions(rawValue: 1 << 1)//模态显示
}

// MARK: - 一些通用的动画
enum YYHudAnimationType {
    case None
    case Fade
    case Zoom
}

// MARK: - Public Class Method
extension YYHud {
    /**
     显示加载框
     
     - parameter superView: superView
     - parameter text:      text
     - parameter options:   默认模态显示，设置nil为非模态
     
     - returns: YYHud
     */
    static func showLoading(inView superView: UIView? = nil, text: String? = nil, options: YYHudOpitions? = [.Modal]) -> YYHud {
        let finalOption = options ?? []
        return sharedInstance.showLoading(inView: superView, text: text, options: finalOption)
    }
    static func showSuccess(inView superView: UIView? = nil, text: String? = nil) -> YYHud {
        return sharedInstance.showSuccess(inView: superView, text: text)
    }
    static func showError(inView superView: UIView? = nil, text: String? = nil) -> YYHud {
        return sharedInstance.showError(inView: superView, text: text)
    }
    static func showInfo(inView superView: UIView? = nil, text: String? = nil) -> YYHud {
        return sharedInstance.showInfo(inView: superView, text: text)
    }
    static func showTip(inView superView: UIView? = nil, text: String) -> YYHud {
        return sharedInstance.showTip(inView: superView, text: text)
    }
    
    static func dismiss() {
        sharedInstance.dismiss()
    }
    
    static func config() {
        
    }
}

class YYHud: UIView {
    // MARK: - Const
    
    let YYHudRadius = CGFloat(5)
    let YYHudAnimationDuration = 0.3
    
    static let YYHudDuration = 2.0
    let YYHudDurationForever = -1.0
    
    let YYHudImageContainerHeight = CGFloat(50)
    let YYHudImageContainerMarginTopDefault = CGFloat(15)
    let YYHudImageContainerMarginTopWithText = CGFloat(10)
    
    // MARK: - Property
    @IBOutlet weak var hudContainer: UIView!
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var imageContainerMarginTop: NSLayoutConstraint!
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint!
    
    // MARK: - 自定义配置，默认值取自xib中的设置
    var hudBackgroundColor: UIColor! { didSet { hudContainer.backgroundColor = hudBackgroundColor } }
    var textColor: UIColor! { didSet { textLabel.textColor = textColor } }
    var textFont: UIFont! { didSet { textLabel.font = textFont } }
    
    var options: YYHudOpitions = [] {
        didSet {
            self.backgroundColor = options.contains(.Dim) ? UIColor.grayColor() : UIColor.clearColor()
            self.isModalAlert = options.contains(.Modal)
        }
    }
    
    static let sharedInstance = YYHud.newInstanceFromXib()
    static func newInstanceFromXib() -> YYHud {
        let view = NSBundle.mainBundle().loadNibNamed(self.classNameString, owner: nil, options: nil).first as? YYHud
        return view!
    }
    
    var isModalAlert = true { didSet { self.userInteractionEnabled = isModalAlert } }
    var isShowing: Bool = false
    var dismissTimer: NSTimer?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        hudBackgroundColor = hudContainer.backgroundColor
        textColor = textLabel.textColor
        textFont = textLabel.font
        hudContainer.layer.cornerRadius = YYHudRadius
        self.frame = UIScreen.mainScreen().bounds
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
    }
    
    // MARK: - Private
    
    func _private() -> Void {
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    

}


// MARK: - Show
extension YYHud {
    var imageSucess: UIImage? { return UIImage(named: "YYHudSucess") }
    var imageError: UIImage? { return UIImage(named: "YYHudError") }
    var imageInfo: UIImage? { return UIImage(named: "YYHudInfo") }
    var superViewDefault: UIView { return UIApplication.sharedApplication().keyWindow! }
    
    func showLoading(inView superView: UIView?, text: String?, options: YYHudOpitions) -> YYHud {
        return show(inView: superview, text: text, duration: YYHudDurationForever, options: options)
    }
    func showSuccess(inView superView: UIView?, text: String?) -> YYHud {
        return show(inView: superview, text: text, image: imageSucess)
    }
    func showError(inView superView: UIView?, text: String?) -> YYHud {
        return show(inView: superview, text: text, image: imageError)
    }
    func showInfo(inView superView: UIView?, text: String?) -> YYHud {
        return show(inView: superview, text: text, image: imageInfo)
    }
    func showTip(inView superView: UIView?, text: String) -> YYHud {
        return show(inView: superview, text: text, isTip: true)
    }
    
    func show(inView superView: UIView?, text: String?, image: UIImage? = nil, isTip: Bool = false, duration:Double = YYHud.YYHudDuration, animationType: YYHudAnimationType = .Fade, options: YYHudOpitions = []) -> YYHud {
        isShowing = true
        dispatch_async(dispatch_get_main_queue()) {
            self.options = options
            if self.superview != nil {
                self.bringSubviewToFront(self)
            } else {
                let finalSuperView = superView ?? self.superViewDefault
                finalSuperView.addSubview(self)
            }
            
            self.textLabel.text = text
            self.imageView.image = image
            
            //只显示提示文字
            if isTip {
                self.imageView.image = nil
                self.indicatorView.stopAnimating()
            } else {
                //显示自定义图片，或者默认的转圈
                image != nil ? self.indicatorView.stopAnimating() : self.indicatorView.startAnimating()
                self.indicatorView.hidden = image != nil
                
                //没有文字显示正中间
                self.imageContainerMarginTop.constant = text != nil ? self.YYHudImageContainerMarginTopWithText : self.YYHudImageContainerMarginTopDefault
            }
            self.imageContainer.hidden = isTip
            self.imageContainerHeight.constant = isTip ? 0 : self.YYHudImageContainerHeight
            
            self.showAnimation(animationType)
        }
        
        refreshDismissTime(duration)
        return self
    }
    
    func showAnimation(type: YYHudAnimationType) {
        UIView.animateWithDuration(YYHudAnimationDuration, delay: 0, options: [.CurveEaseIn], animations: {
            self.hudContainer.transform = CGAffineTransformIdentity
            self.hudContainer.alpha = 1
            }) { (_) in
                
        }
    }
    
    func dismiss() {
        if !self.isShowing {
            return
        }
        dispatch_async(dispatch_get_main_queue()) { 
            UIView.animateWithDuration(self.YYHudAnimationDuration, delay: 0, options: [.CurveEaseOut], animations: {
                self.hudContainer.transform = CGAffineTransformIdentity
                self.hudContainer.alpha = 0;
            }) { (_) in
                self.indicatorView.stopAnimating()
                self.removeFromSuperview()
                self.isShowing = false
            }
        }
    }
    
    func refreshDismissTime(duration: Double) {
        if let timer = dismissTimer {
            timer.invalidate()
            dismissTimer = nil
        }
        
        if (duration != YYHudDurationForever) {
            dismissTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        }
    }
}


























