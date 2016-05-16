//
//  ViewController+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UIViewController {
    func extendedLayoutNone() {
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
    }
}

// MARK: - ChildVC相关
extension UIViewController {
    func addChildViewControllerWithFillViewConstraint(childController: UIViewController) {
        //addChildViewController会自动调用willMoveToParentViewController
        self.addChildViewController(childController)
        self.view.addSubview(childController.view)
        childController.didMoveToParentViewController(self)
        childController.view.addConstraintFillParent()
    }
    func addChildViewControllerWithView(childController: UIViewController) {
        self.addChildViewController(childController)
        self.view.addSubview(childController.view)
        childController.view.frame = self.view.frame
        childController.didMoveToParentViewController(self)
    }
}

// MARK: - 初始化相关
extension UIViewController {
    // MARK: - 根据类名从storyboard中返回对应ViewController
    static func newInstanceFromStoryboard(isInitial: Bool = true) -> UIViewController? {
        return newInstanceFromStoryboard(self.classNameString, isInitial: isInitial)
    }
    
    static func newInstanceFromStoryboard(storyboardName: String, isInitial: Bool = true) -> UIViewController? {
        return newInstanceFromStoryboard(storyboardName, storyboardId: self.classNameString, isInitial: isInitial)
    }
    
    static func newInstanceFromStoryboard(storyboardName: String, storyboardId: String) -> UIViewController? {
        return newInstanceFromStoryboard(storyboardName, storyboardId: storyboardId, isInitial: false)
    }
    
    static func newInstanceFromStoryboard(storyboardName: String, storyboardId: String, isInitial: Bool) -> UIViewController? {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        return isInitial ? storyboard.instantiateInitialViewController() : storyboard.instantiateViewControllerWithIdentifier(storyboardId)
    }
}


// MARK: - 快速添加一个按钮
class YYButton: UIButton {
    var action: ((button: UIButton)->Void)! = nil
}
extension UIViewController {
    func addButtonToView(title: String, frame: CGRect, action: (button: UIButton)->Void) -> YYButton {
        let button = YYButton.init(type: UIButtonType.System)
        button.action = action
        button.frame = frame
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(UIViewController._yyButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    func _yyButtonClicked(button: YYButton) {
        if let action = button.action {
            action(button: button);
        }
    }
}
















