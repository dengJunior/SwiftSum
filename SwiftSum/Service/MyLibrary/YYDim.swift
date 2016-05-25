//
//  YYDim.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

struct YYDimOpitions: OptionSetType {
    var rawValue = 0  // 因为RawRepresentable的要求
    
    static var Dim = YYHudOpitions(rawValue: 1 << 0)//蒙版效果，黑色透明背景，否则为透明
    static var Modal = YYHudOpitions(rawValue: 1 << 1)//模态显示
    static var DismissTaped = YYHudOpitions(rawValue: 1 << 1)//点击空白地方自动消失
}

// MARK: - 一些通用的动画
enum YYDimAnimationType {
    case None
    case Fade
    case Zoom
}

extension YYDim {
    func showWithView(view: UIView, options: YYDimOpitions, animationType: YYHudAnimationType, animations: () -> Void, completion: ((Bool) -> Void)?) {
        
    }
}

class YYDim: UIView {
    
    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    weak var showView: UIView?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        self.frame = UIScreen.mainScreen().bounds
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
        self.frame = UIScreen.mainScreen().bounds
    }
    
    // MARK: - Private
    
    func _private() -> Void {
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
    
}