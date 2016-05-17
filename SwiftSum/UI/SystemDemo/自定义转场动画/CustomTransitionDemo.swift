//
//  CustomTransitionDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class CustomTransitionDemo: UIViewController {

    //触发动画的手势
    lazy var interactiveTransitionRecognizer: UIScreenEdgePanGestureRecognizer = {
       let gesture = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(CustomTransitionDemo.interactiveTransitionRecognizerAction))
        gesture.edges = .Right
        return gesture
    }()
    
    //交互动画代理
    lazy var customTransitionDelegate: YYInteractivityTransitionDelegate = YYInteractivityTransitionDelegate()
    
    //iOS 8的改进：UIPresentationController 动画
    lazy var customPresentationSecondViewController: CustomPresentationSecondViewController = {
        let customPresentationSecondViewController = CustomPresentationSecondViewController()
        return customPresentationSecondViewController
    }()
    
    var customPresentationController: YYPresentationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addInteractiveGesture()
        
        let customPresentationController = YYPresentationController(presentedViewController: self.customPresentationSecondViewController, presentingViewController: self)
        customPresentationSecondViewController.transitioningDelegate = customPresentationController
        self.customPresentationController = customPresentationController
        
        
        var buttonCount = 2;
        
        self.addButtonToView("自定义present动画", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            let vc = PresentDemo()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        buttonCount += 1
        
        self.addButtonToView("自定义Navigation动画", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            let vc = NavigationDemo()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        buttonCount += 1
        self.addButtonToView("转场协调器动画", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            
            self.presentViewController(self.customPresentationSecondViewController, animated: true, completion: {
                
            })
        }
    }
}

// MARK: - 实现UIViewControllerTransitioningDelegate协议
extension CustomTransitionDemo: UIViewControllerTransitioningDelegate {
    
    /**
     需要提供present和dismiss时的animator，
     有时候一个animator可以同时在present和dismiss时用
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //如果该方法返回nil，UIKit执行没有交互的动画。
        return YYPresentationAnimator()
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //如果该方法返回nil，UIKit执行没有交互的动画。
        return YYPresentationAnimator()
    }
}

// MARK: - 滑动交互手势
extension CustomTransitionDemo {
    
    func addInteractiveGesture() {
        self.view.addGestureRecognizer(interactiveTransitionRecognizer)
    }
    
    /**
     这个函数可以在按钮点击时触发，也可以在手势滑动时被触发，通过sender的类型来判断具体是那种情况
     如果是通过滑动手势触发，则需要设置customTransitionDelegate的gestureRecognizer属性
     
     :param: sender 事件的发送者，可能是button，也有可能是手势
     */
    func animationButtonDidClicked(sender: AnyObject) {
        if sender.isKindOfClass(UIGestureRecognizer) {
            customTransitionDelegate.gestureRecognizer = interactiveTransitionRecognizer
        }
        else {
            customTransitionDelegate.gestureRecognizer = nil
        }
        /// 设置targetEdge为右边，也就是检测从右边向左滑动的手势
        customTransitionDelegate.targetEdge = .Right
        let vc = TableViewController1()
        vc.modalPresentationStyle = .FullScreen
        // 设置动画代理，这里的代理就是这个类自己
        vc.transitioningDelegate = self.customTransitionDelegate
        self.presentViewController(vc, animated: true, completion: {
            
        })
    }
    
    func interactiveTransitionRecognizerAction(sender: UIScreenEdgePanGestureRecognizer) {
        /**
         *  在开始触发手势时，调用animationButtonDidClicked方法，只会调用一次
         */
        if sender.state == .Began {
            self.animationButtonDidClicked(sender)
        }
    }
}

























