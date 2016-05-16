//
//  YYTransitionAnimator.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

enum TabDirection {
    case Left, Right
}

enum ModalOperation {
    case Present, Dismiss
}

enum YYTransitionType {
    case Navigation(UINavigationControllerOperation)
    case Tab(TabDirection)
    case Modal(ModalOperation)
}

//容器类 VC 的转场里 fromView 和 toView 是 containerView 的子层次的视图，<mark>而 Modal 转场里 presentingView 与 containerView 是同层次的视图，只有 presentedView 是 containerView 的子层次视图。

/**
 - 容器 VC 的转场结束后 fromView 会被主动移出视图结构，这是可预见的结果，我们也可以在转场结束前手动移除；
 - 而 Modal 转场中，presentation 结束后 presentingView(fromView) 并未主动被从视图结构中移除。
 - 准确来说，在我们可自定义的两种模式里，UIModalPresentationCustom 模式(以下简称 Custom 模式)下 Modal 转场结束时 fromView 并未从视图结构中移除；
 - UIModalPresentationFullScreen 模式(以下简称 FullScreen 模式)的 Modal 转场结束后 fromView 依然主动被从视图结构中移除了。
 
 <mark>这种差异导致在处理 dismissal 转场的时候很容易出现问题，没有意识到这个不同点的话出错时就会毫无头绪。
 
 来看看 dismissal 转场时的场景：
 
 1. FullScreen 模式：
 - presentation 结束后，presentingView 被主动移出视图结构，不过，在 dismissal 转场中希望其出现在屏幕上并且在对其添加动画怎么办呢？
 - 实际上，你按照容器类 VC 转场里动画控制器里那样做也没有问题，就是将其加入 containerView 并添加动画。
 - 不用担心，转场结束后，UIKit 会自动将其恢复到原来的位置。虽然背后的机制不一样，但这个模式下的 Modal 转场和容器类 VC 的转场的动画控制器的代码可以通用，你不必记住背后的差异。
 2. Custom 模式：
 - presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。
 - <mark>如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。
 */

//通用
class YYTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitionType: YYTransitionType
    init(transitionType: YYTransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            containerView = transitionContext.containerView(),
            fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else{
                return
        }
        
        /*
         prsenting时，fromVC是要弹的那个
         dismiss时，fromVC是被弹出的那个
         */
        let fromView = fromVC.view
        let toView = toVC.view
        
        var width = containerView.frame.width
        var fromViewAnimatedTransform = CGAffineTransformIdentity
        var toViewInitialTransform = CGAffineTransformIdentity
        
        switch transitionType {
        case .Navigation(let operation):
            width = operation == .Push ? width : -width
            fromViewAnimatedTransform = CGAffineTransformMakeTranslation(-width, 0)
            toViewInitialTransform = CGAffineTransformMakeTranslation(width, 0)
            containerView.addSubview(toView)
        case .Tab(let direction):
            width = direction == .Left ? width : -width
            fromViewAnimatedTransform = CGAffineTransformMakeTranslation(width, 0)
            toViewInitialTransform = CGAffineTransformMakeTranslation(-width, 0)
            containerView.addSubview(toView)
        case .Modal(let operation):
            let height = containerView.frame.height
            fromViewAnimatedTransform = CGAffineTransformMakeTranslation(0, operation == .Present ? 0 : height)
            toViewInitialTransform = CGAffineTransformMakeTranslation(0, operation == .Present ? height : 0)
            if operation == .Present {
                containerView.addSubview(toView)
            }
        }
        toView.transform = toViewInitialTransform
        
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromView.transform = fromViewAnimatedTransform
            toView.transform = CGAffineTransformIdentity
        }) { (_) in
            fromView.transform = CGAffineTransformIdentity
            toView.transform = CGAffineTransformIdentity
            
            let wasCancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}


/*
 下面这段被注释的代码是使用 Core Animation 来实现转场，在非交互转场时没有问题，在交互转场下会有点瑕疵，要达到完美要麻烦一点。
 
 交互转场必须用 UIView Animtion API 才能实现完美的控制，其实并不是 Core Animation 做不到，
 毕竟 UIView Animation 是基于 Core Animation 的，那为什么苹果的工程师在 WWDC 上说必须使用前者呢。
 因为使用 Core Animation 来实现成本高啊，在转场中做到与 UIView Animation 同样的事情配置麻烦些，估计很多人都不会配置，
 而且在交互转场中会比较麻烦，本来转场 API 已经分裂得够复杂了，老老实实用高级 API 吧。
 
 上面说的 UIView Animation API 指的是带 completion 闭包的 API，使用 Core Animation 来实现这个闭包需要配置
 CATransaction，这就是麻烦的地方，还是用高级的 API 吧。
 
 在自定义的容器控制器转场中，交互部分需要我们自己动手实现控制动画的进度，此时 使用 Core Animation 或 UIView Animation
 区别不大，重点在于在手势中如何控制动画。
 */

//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        guard let containerView = transitionContext.containerView(), fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else{
//            return
//        }
//
//        let fromView = fromVC.view
//        let toView = toVC.view
//
//        var translation = containerView.frame.width
//        var toViewTransform = CATransform3DIdentity
//        var fromViewTransform = CATransform3DIdentity
//
//        switch transitionType{
//        case .NavigationTransition(let operation):
//            translation = operation == .Push ? translation : -translation
//            toViewTransform = CATransform3DMakeTranslation(translation, 0, 0)
//            fromViewTransform = CATransform3DMakeTranslation(-translation, 0, 0)
//        case .TabTransition(let direction):
//            translation = direction == .Left ? translation : -translation
//            fromViewTransform = CATransform3DMakeTranslation(translation, 0, 0)
//            toViewTransform = CATransform3DMakeTranslation(-translation, 0, 0)
//        case .ModalTransition(let operation):
//            translation =  containerView.frame.height
//            toViewTransform = CATransform3DMakeTranslation(0, (operation == .Presentation ? translation : 0), 0)
//            fromViewTransform = CATransform3DMakeTranslation(0, (operation == .Presentation ? 0 : translation), 0)
//        }
//
//        switch transitionType{
//        case .ModalTransition(let operation):
//            switch operation{
//            case .Presentation: containerView.addSubview(toView)
//                //在 dismissal 转场中，不要添加 toView，否则黑屏
//            case .Dismissal: break
//            }
//        default: containerView.addSubview(toView)
//        }
//
//        let duration = transitionDuration(transitionContext)
//        CATransaction.setCompletionBlock({
//            fromView.layer.transform = CATransform3DIdentity
//            toView.layer.transform = CATransform3DIdentity
//
//            let isCancelled = transitionContext.transitionWasCancelled()
//            transitionContext.completeTransition(!isCancelled)
//        })
//
//        CATransaction.setAnimationDuration(duration)
//        CATransaction.begin()
//
//        let toViewAnimation = CABasicAnimation(keyPath: "transform")
//        toViewAnimation.fromValue = NSValue.init(CATransform3D: toViewTransform)
//        toViewAnimation.toValue = NSValue.init(CATransform3D: CATransform3DIdentity)
//        toViewAnimation.duration = duration
//        toView.layer.addAnimation(toViewAnimation, forKey: "move")
//
//        let fromViewAnimation = CABasicAnimation(keyPath: "transform")
//        fromViewAnimation.fromValue = NSValue.init(CATransform3D: CATransform3DIdentity)
//        fromViewAnimation.toValue = NSValue.init(CATransform3D: fromViewTransform)
//        fromViewAnimation.duration = duration
//        fromView.layer.addAnimation(fromViewAnimation, forKey: "move")
//
//        CATransaction.commit()
//    }






























