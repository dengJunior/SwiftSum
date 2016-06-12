//
//  ViewController+YYKit.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func extendedLayoutNone() {
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - ChildVC相关
    public func addChildViewController(childController: UIViewController, toSubView: Bool = false, fillSuperViewConstraint: Bool = false) {
        self.addChildViewController(childController)
        if toSubView {
            self.view.addSubview(childController.view)
            childController.view.frame = self.view.frame
            
            if fillSuperViewConstraint {
                childController.view.addConstraintFillSuperView()
            }
        }
        childController.didMoveToParentViewController(self)
    }
}


// MARK: - 初始化相关
extension UIViewController {
    // MARK: - 根据类名从storyboard中返回对应ViewController
    public static func newInstanceFromStoryboard(storyboardName: String? = nil, storyboardId: String? = nil, isInitial: Bool = false) -> UIViewController? {
        let classNameString = self.classNameString
        let storyboard = UIStoryboard.init(name: storyboardName ?? classNameString, bundle: nil)
        
        return isInitial ? storyboard.instantiateInitialViewController() : storyboard.instantiateViewControllerWithIdentifier(storyboardId ?? classNameString)
    }
}


// MARK: - 快速添加一个按钮
class YYButton: UIButton {
    var action: ((button: UIButton)->Void)! = nil
}

var AssociatedObjectHandle: UInt8 = 0

extension UIViewController {
    public var buttonCount: Int {
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int
            return value ?? 0 //初始化为0
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addButtonToViewWithTitle(title: String, action: (button: UIButton)->Void) -> UIButton {
        buttonCount += 1
        return addButtonToView(title, frame: CGRect(x: 0, y: 40*buttonCount, width: 320, height: 40), action: action)
    }
    public func addButtonToView(title: String, frame: CGRect, action: (button: UIButton)->Void) -> UIButton {
        let button = YYButton.init(type: UIButtonType.System)
        button.action = action
        button.frame = frame
        button.contentHorizontalAlignment = .Center
        button.setTitle(title, forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(UIViewController._yyButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        return button
    }
    
    func _yyButtonClicked(button: YYButton) {
        if let action = button.action {
            action(button: button);
        }
    }
}
















