//
//  YYInteractivityTransition.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/*
 交互式动画是在非交互式动画的基础上实现的，我们需要创建一个继承自UIPercentDrivenInteractiveTransition类型的子类，并且在动画代理中返回这个类型的实例对象。
 */
class YYInteractivityTransition: UIPercentDrivenInteractiveTransition {
    var transtionContext: UIViewControllerContextTransitioning? = nil
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer
    var edge: UIRectEdge
    
    init(gestureRecognizer: UIScreenEdgePanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        assert(edge == .Top || edge == .Bottom || edge == .Left || edge == .Right,
               "edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        super.init()
        self.gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate))
    }
    
    /// 当手势有滑动时触发这个函数
    func gestureRecognizeDidUpdate(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Began:
            break
        case .Changed:
            //手势滑动，更新百分比
            self.updateInteractiveTransition(self.percentForGesture(gestureRecognizer))
        case .Ended:
            if self.percentForGesture(gestureRecognizer) >= 0.5 {
                self.finishInteractiveTransition()
            } else {
                // 滑动结束，判断是否超过一半，如果是则完成剩下的动画，否则取消动画
                self.cancelInteractiveTransition()
            }
        default:
            self.cancelInteractiveTransition()
        }
    }
    
    /**
     用于根据计算动画完成的百分比
     
     :param: gesture 当前的滑动手势，通过这个手势获取滑动的位移
     :returns: 返回动画完成的百分比
     */
    private func percentForGesture(gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat  {
        guard let transitionContainerView = transtionContext?.containerView() else {
            return 0
        }
        let location = gestureRecognizer.locationInView(transitionContainerView)
        let viewWidth = transitionContainerView.bounds.width
        let viewHeight = transitionContainerView.bounds.height
        
        switch edge {
        case UIRectEdge.Top:
            return (location.y)/viewHeight
        case UIRectEdge.Left:
            return (location.x)/viewWidth
        case UIRectEdge.Bottom:
            return (viewHeight - location.y)/viewHeight
        case UIRectEdge.Right:
            return (viewWidth - location.x)/viewWidth
        default :
            return 0
        }
    }
    
    // MARK: - Override
    
    override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transtionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
}
























