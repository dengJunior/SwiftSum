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

// MARK: - 显示和隐藏动画
enum YYHudAnimationType {
    case None
    case Fade
    case Zoom
}

// MARK: - Public Class Method
extension YYHud {
    static func show(inView superView: UIView? = nil, text: String? = nil) {
        self.sharedInstance.show(inView: superView, text: text)
    }
    static func showSuccess(inView superView: UIView? = nil, text: String? = nil) {
        self.sharedInstance.showSuccess(inView: superView, text: text)
    }
    static func showError(inView superView: UIView? = nil, text: String? = nil) {
        self.sharedInstance.showError(inView: superView, text: text)
    }
    static func showTip(inView superView: UIView? = nil, text: String) {
        self.sharedInstance.showTip(inView: superView, text: text)
    }
}

// MARK: - Public Instance Method
extension YYHud {
    func show(inView superView: UIView? = nil, text: String? = nil) {
        show(inView: superview, text: text, image: nil, isTip: false)
    }
    func showSuccess(inView superView: UIView? = nil, text: String? = nil) {
        show(inView: superview, text: text, image: nil, isTip: false)
    }
    func showError(inView superView: UIView? = nil, text: String? = nil) {
        show(inView: superview, text: text, image: nil, isTip: false)
    }
    func showTip(inView superView: UIView? = nil, text: String) {
        show(inView: superview, text: text, image: nil, isTip: true)
    }
    
    func show(inView superView: UIView?, text: String?, image: UIImage?, isTip: Bool, animationType: YYHudAnimationType? = nil, options: YYHudOpitions? = nil) {
        
    }
}

class YYHud: UIView {
    // MARK: - Const
    
    let YYHudRadius = 5
    let YYHudDuration = 1.8
    
    let YYHudImageContainerMarginTopDefault = 15
    let YYHudImageContainerMarginTopWithText = 10
    
    // MARK: - Property
    @IBOutlet weak var hudContainer: UIView!
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var imageContainerMarginTop: NSLayoutConstraint!
    
    // MARK: - 自定义配置
    var hudBackgroundColor: UIColor! {
        didSet {
            hudContainer.backgroundColor = hudBackgroundColor
        }
    }
    var hudForegroundColor: UIColor! {
        didSet {
            self.backgroundColor = hudBackgroundColor
        }
    }
    var textColor: UIColor! {
        didSet {
            textLabel.textColor = textColor
        }
    }
    var textFont: UIFont! {
        didSet {
            textLabel.font = textFont
        }
    }
    static func config() {
        
    }
    
    static let sharedInstance = YYHud()
    
    var isModalAlert = true {
        didSet {
            self.userInteractionEnabled = isModalAlert
        }
    }
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        
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




























