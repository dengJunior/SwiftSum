//
//  ViewControllerGuideDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ViewControllerGuideDemo: UIViewController {

    lazy var vc1: ViewController1 = {
        return ViewController1();
    }()
    
    lazy var vc2: TableViewController1 = {
        return TableViewController1();
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  让子视图控制器指定自己的大小。灵活布局的容器可以使用子视图自己的preferredContentSize属性，以帮助决定子视图的大小。
         
         用于UIModalPresentationPopover
         */
        self.preferredContentSize = CGSize(width: 300, height: 400);
        
        
        /**
         *  UIKit只保存你告诉它要保存的视图控制器。
         每个视图控制器有一个restorationIdentifier属性，这个属性的默认值为nil。
         设置这个属性值为有效字符串，告诉UIKit视图控制器和视图应该要保存。
         
         当分配恢复标示符时，在视图层级结构中的所有的父视图控制器必须有恢复标示符。
         如果该层级结构中一个视图控制器没有恢复标示符，该视图控制器和其所有子视图控制器和present的视图控制器都会被忽略。
         */
        self.restorationIdentifier = "ViewControllerGuideDemo"
//        self.restorationClass = ViewControllerGuideDemo.self
        
        self.view.backgroundColor = UIColor.redColor()
        
        self.addChildViewController(vc1, toSubView: true, fillSuperViewConstraint: true)
        let titles = ["vc1", "vc2"];
        let segment = UISegmentedControl(items: titles)
        segment.selectedSegmentIndex = 0;
        segment.addTarget(self, action: #selector(segmentValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = segment
    }
    
    func segmentValueChanged(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        
        let oldVc = index == 0 ? vc2 : vc1
        let newVc = index == 1 ? vc2 : vc1
        
        self.changeFromViewController(oldVc, toViewController: newVc)
    }
    
    func changeFromViewController(oldVc: UIViewController, toViewController newVc: UIViewController) {
        oldVc.willMoveToParentViewController(nil)
        self.addChildViewController(newVc)
        
        self.transitionFromViewController(oldVc, toViewController: newVc, duration: 0.6, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            //需要重新加约束，因为transitionFromViewController会调用oldVc.view.removeFromSuperView清除约束
            newVc.view.addConstraintFillSuperView()
        }) { (finished) in
            oldVc.removeFromParentViewController()
            newVc.didMoveToParentViewController(self)
        }
    }

    // MARK: - 让子视图控制器决定状态栏风格。
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.childViewControllers.first
    }
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.childViewControllers.first
    }
    
    // MARK: - 实现UI的状态保持和恢复
    
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeObject("hh", forKey: "key")
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
        let string = coder.decodeObjectForKey("key")
        if (string != nil) {
            
        }
    }
}

// MARK: - ios8后旋转相关
extension ViewControllerGuideDemo {
    /**
     1. 告诉每个相关视图控制器，trait即将改变。
     */
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    /**
     2. 告诉每个相关视图控制器，size即将改变。
     */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    /**
     3. 告诉每个相关视图控制器，trait已经发生改变。
     */
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        
    }
}





























