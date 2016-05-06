//
//  YYPresentationController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/*
 对于内置过渡和自定义过渡，UIKit创建过渡协调器对象帮助需要执行的额外动画。
 除了视图控制器present和dismiss，当界面发生旋转或视图控制器的frame改变时会发生过渡。
 所有这些过渡代表视图层级有变化。过渡协调器总是跟踪这些变化同时渲染内容。
 访问过渡协调器，获取受影响的视图控制器的 transitionCoordinator 属性的对象。过渡协调器只存在过渡过程中。
 */
class YYPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    let CornerRadius: CGFloat = 16
    
    // 被添加动画效果的view，在presentedViewController的基础上添加了其他效果
    var presentationWrapperView: UIView? = nil
    var dimView: UIView? = nil// alpha为0.5的黑色蒙版
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        /**
         *  想要完成gif中第三个例子的效果，我们还需要使用UIModalPresentationStyle.Custom来代替.FullScreen。
         因为后者会移除fromViewController，这显然不符合需求。
         
         当present的方式为.Custom时，我们还可以使用UIPresentationController更加彻底的控制转场动画的效果。一个 presentation controller具备以下几个功能：
         
         1. 设置presentedViewController的视图大小
         2. 添加自定义视图来改变presentedView的外观
         3. 为任何自定义的视图提供转场动画效果
         4. 根据size class进行响应式布局
         
         您可以认为，. FullScreen以及其他present风格都是swift为我们实现提供好的，它们是.Custom的特例。而.Custom允许我们更加自由的定义转场动画效果。
         */
        presentedViewController.modalPresentationStyle = .Custom
    }
    
    override func presentedView() -> UIView? {
        return presentationWrapperView
    }
    
    func clearUp() {
        presentationWrapperView = nil
        dimView = nil
    }
}

// MARK: - 两组对应的方法，实现自定义presentation
extension YYPresentationController {
    /**
     UIPresentationController提供了四个函数来定义present和dismiss动画开始前后的操作：
     
     1. presentationTransitionWillBegin: present将要执行时
     2. presentationTransitionDidEnd：present执行结束后
     3. dismissalTransitionWillBegin：dismiss将要执行时
     4. dismissalTransitionDidEnd：dismiss执行结束后
     */
    override func presentationTransitionWillBegin() {
        // 添加阴影效果
        let presentationWrapperView = UIView(frame: self.frameOfPresentedViewInContainerView())
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowRadius = 13
        presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6)
        /// 在重写父类的presentedView方法中，返回了self.presentationWrappingView，这个方法表示需要添加动画效果的视图
        /// 这里对self.presentationWrappingView赋值，从后面的代码可以看到这个视图处于视图层级的最上层
        self.presentationWrapperView = presentationWrapperView
        
        let presentationRoundedCornerView = UIView(frame: UIEdgeInsetsInsetRect(presentationWrapperView.bounds, UIEdgeInsetsMake(0, 0, -CornerRadius, 0))) // 添加圆角效果
        presentationRoundedCornerView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth];
        presentationRoundedCornerView.layer.cornerRadius = CornerRadius
        presentationRoundedCornerView.layer.masksToBounds = true
        
        let presentedViewControllerWrapperView = UIView(frame: UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, CornerRadius, 0))) // 添加圆角效果
        presentedViewControllerWrapperView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth];
        
        guard let presentedViewControllerView = super.presentedView() else {
            return
        }
        presentedViewControllerView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
        
        // 视图层级关系如下：
        // presentationWrapperView              <- 添加阴影效果
        //   |- presentationRoundedCornerView   <- 添加圆角效果 (masksToBounds)
        //        |- presentedViewControllerWrapperView
        //             |- presentedViewControllerView (presentedViewController.view)
        presentedViewControllerWrapperView.addSubview(presentedViewControllerView)
        presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
        presentationWrapperView.addSubview(presentationRoundedCornerView)
        
        /// 深色的一层覆盖视图，让背景看上去比较暗
        let dimmingView = UIView(frame: (self.containerView?.bounds)!)
        dimmingView.backgroundColor = UIColor.blackColor()
        dimmingView.opaque = false
        dimmingView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimView)))
        self.dimView = dimmingView
        self.containerView?.addSubview(dimmingView)
        
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        dimView?.alpha = 0
        transitionCoordinator?.animateAlongsideTransition({ (context) in
            self.dimView?.alpha = 0.5
            }, completion: { (viewControllerTransitionCoordinatorContext) in
                
        })
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        /// 如果present没有完成，把dimmingView和wrappingView都清空，这些临时视图用不到了
        if !completed {
            clearUp()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        /// dismiss开始时，让dimmingView完全透明，这个动画和animator中的动画同时发生
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ (viewControllerTransitionCoordinatorContext) in
            self.dimView?.alpha = 0
            }, completion: { (viewControllerTransitionCoordinatorContext) in
                
        })
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            /// dismiss结束时，把dimmingView和wrappingView都清空，这些临时视图用不到了
            clearUp()
        }
    }
    
    func didTapDimView() {
        self.presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Autolayout
extension YYPresentationController {
    /**
     当一个容器ViewController的ChildViewController的这个值改变时，UIKit会调用preferredContentSizeDidChangeForChildContentContainer这个方法告诉当前容器ViewController。
     我们可以在这个方法里根据新的Size对界面进行调整。
     */
    override func preferredContentSizeDidChangeForChildContentContainer(container: UIContentContainer) {
        super.preferredContentSizeDidChangeForChildContentContainer(container)
        
        if let container = container as? UIViewController where container == self.presentedViewController {
            self.containerView?.setNeedsLayout()
        }
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let container = container as? UIViewController where container == self.presentedViewController {
            return container.preferredContentSize
        } else {
            return super.sizeForChildContentContainer(container, withParentContainerSize: parentSize)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let containerViewBounds = self.containerView?.bounds
        let presentedViewContentSize = self.sizeForChildContentContainer(self.presentedViewController, withParentContainerSize: (containerViewBounds?.size)!)
        let presentedViewControllerFrame = CGRectMake(containerViewBounds!.origin.x, CGRectGetMaxY(containerViewBounds!) - presentedViewContentSize.height, (containerViewBounds?.size.width)!, presentedViewContentSize.height)
        return presentedViewControllerFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimView?.frame = (self.containerView?.bounds)!
        presentationWrapperView?.frame = self.frameOfPresentedViewInContainerView()
    }
}

// MARK: -  实现协议UIViewControllerTransitioningDelegate
extension YYPresentationController {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYPresentationAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYPresentationAnimator()
    }
}































