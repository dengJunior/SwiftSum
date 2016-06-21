//
//  YYOverlayPresentationController.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - ## iOS 8的改进：UIPresentationController

@available(iOS 8.0, *)
class YYOverlayPresentationController: UIPresentationController {
    //OverlayPresentationController类接手了 dimmingView 的工作
    let dimmingView = UIView()
    
    //iOS 8 扩充了转场环境协议，可以通过viewForKey:方便获取转场的视图，而该方法在 Modal 转场中获取的是presentedView()返回的视图。
    override func presentedView() -> UIView? {
        return super.presentedView()
    }
    
    //决定 presentingView 是否在 presentation 转场结束后被移除
    override func shouldRemovePresentersView() -> Bool {
        return super.shouldRemovePresentersView()
    }
    
    //Presentation 转场开始前该方法被调用。
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        containerView.addSubview(dimmingView)
        
        let dimmingViewInitailWidth = containerView.frame.width*2 / 3
        let dimmingViewInitailHeight = containerView.frame.height*2 / 3
        
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.center = containerView.center
        dimmingView.bounds = CGRect(x: 0, y: 0, width: dimmingViewInitailWidth , height: dimmingViewInitailHeight)
        
        //使用 transitionCoordinator 与转场动画并行执行 dimmingView 的动画。
        //转场协调器(Transition Coordinator)将在这里派上用场。该对象可通过 UIViewController 的transitionCoordinator()方法获取，这是 iOS 7 为自定义转场新增的 API，该方法只在控制器处于转场过程中才返回一个与当前转场有关的有效对象，其他时候返回 nil。
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
            self.dimmingView.bounds = containerView.bounds
            }, completion: nil)
    }
    
    //Dismissal 转场开始前该方法被调用。添加了 dimmingView 消失的动画，在上一节中并没有添加这个动画，
    //实际上由于 presentedView 的形变动画，这个动画根本不会被注意到，此处只为示范。
    override func dismissalTransitionWillBegin() {
        /**
         //与动画控制器中的转场动画同步，执行其他动画
         animateAlongsideTransition:completion:
         
         //与动画控制器中的转场动画同步，在指定的视图内执行动画
         animateAlongsideTransitionInView:animation:completion:
         */
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
            self.dimmingView.alpha = 0
            }, completion: nil)
    }
    
    //iOS 8 带来了适应性布局，<UIContentContainer>协议用于响应视图尺寸变化和屏幕旋转事件
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            return
        }
        dimmingView.center = containerView.center
        dimmingView.bounds = containerView.bounds
        let width = containerView.frame.width*2 / 3
        let height = containerView.frame.height*2 / 3
        presentedView()?.center = containerView.center
        presentedView()?.bounds = CGRect(x: 0, y: 0, width: width, height: height)
    }
}

/**
 iOS 8 针对分辨率日益分裂的 iOS 设备带来了新的适应性布局方案，以往有些专为在 iPad 上设计的控制器也能在 iPhone 上使用了，一个大变化是在视图控制器的(模态)显示过程，包括转场过程，引入了UIPresentationController类，该类接管了 UIViewController 的显示过程，为其提供转场和视图管理支持。
 
 在 iOS 8.0 以上的系统里，你可以在 presentation 转场结束后打印视图控制器的结构，会发现 presentedVC 是由一个UIPresentationController对象来显示的，查看视图结构也能看到 presentedView 是 UIView 私有子类的UITtansitionView的子视图，这就是前面 containerView 的真面目
 
 当 UIViewController 的modalPresentationStyle属性为.Custom时(不支持.FullScreen)，我们有机会通过控制器的转场代理提供UIPresentationController的子类对 Modal 转场进行进一步的定制。
 
 实际上该类也可以在.FullScreen模式下使用，但是会丢失由该类负责的动画，保险起见还是遵循官方的建议，只在.Custom模式下使用该类。
 
 UIPresentationController类主要给 Modal 转场带来了以下几点变化：
 
 1. 定制 presentedView 的外观：设定 presentedView 的尺寸以及在 containerView 中添加自定义视图并为这些视图添加动画；
 2. 可以选择是否移除 presentingView；
 3. 可以在不需要动画控制器的情况下单独工作；
 4. iOS 8 中的适应性布局。
 */























