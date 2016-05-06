//
//  YYPercentTransition.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYPercentTransition: UIPercentDrivenInteractiveTransition {
    
    var transtionContext: UIViewControllerContextTransitioning? = nil
    
    var viewWidth: CGFloat {
        guard let transitionContainerView = transtionContext?.containerView() else {
            return 0
        }
        return transitionContainerView.bounds.width
    }
    
    var viewHeight: CGFloat {
        guard let transitionContainerView = transtionContext?.containerView() else {
            return 0
        }
        return transitionContainerView.bounds.height
    }
    //设置百分比
    var percent = CGFloat(0) {
        didSet {
            self.updateInteractiveTransition(percent)
        }
    }
    
    func finish() {
        if percent >= 0.3 {
            self.finishInteractiveTransition()
        } else {
            self.cancelInteractiveTransition()
        }
    }
    
    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transtionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
}
