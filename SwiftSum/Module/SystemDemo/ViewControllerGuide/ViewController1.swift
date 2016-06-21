//
//  ViewController1.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = "ViewController1"
        self.preferredContentSize = CGSize(width: 0, height: 300);
        self.view.backgroundColor = UIColor.greenColor()
        
        var buttonCount = 2;
        
        self.addButtonToView("present", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { [unowned self] (button) in
            let viewController = TableViewController1()
            
            /**
             *  UIModalPresentationFullScreen代表弹出VC时，presented VC充满全屏，如果弹出VC的wantsFullScreenLayout设置为YES的，则会填充到状态栏下边，否则不会填充到状态栏之下。
             */
            viewController.modalPresentationStyle = .FullScreen
            
            /**
             *  UIModalPresentationPageSheet代表弹出是弹出VC时，presented VC的高度和当前屏幕高度相同，宽度和竖屏模式下屏幕宽度相同，
             剩余未覆盖区域将会变暗并阻止用户点击，这种弹出模式下，竖屏时跟 UIModalPresentationFullScreen的效果一样，横屏时候两边则会留下变暗的区域。
             */
            viewController.modalPresentationStyle = .PageSheet
            
            /**
             *  UIModalPresentationFormSheet这种模式下，presented VC的高度和宽度均会小于屏幕尺寸，presented VC居中显示，四周留下变暗区域。
             */
            viewController.modalPresentationStyle = .FormSheet
            
            /**
             *  UIModalPresentationCurrentContext这种模式下，presented VC的弹出方式和presenting VC的父VC的方式相同。
             */
            viewController.modalPresentationStyle = .CurrentContext
            
            /**
             *  上面四种方式在iPad上面统统有效，但在iPhone和iPod touch上面系统始终已UIModalPresentationFullScreen模式显示presented VC。
             */
            
            
            viewController.modalPresentationStyle = .PageSheet
            
            //画面从下向上徐徐弹出，关闭时向下隐藏（默认方式）。
            viewController.modalTransitionStyle = .CoverVertical
            
            //从前一个画面的后方，以水平旋转的方式显示后一画面。
            viewController.modalTransitionStyle = .FlipHorizontal
            
            //前一画面逐渐消失的同时，后一画面逐渐显示。
            viewController.modalTransitionStyle = .CrossDissolve
            
            //翻页一样显示
            viewController.modalTransitionStyle = .PartialCurl
            /**
             *   presentViewController:animated:completion: 方法总是以模态的方式显示视图控制器。
             视图控制器调用这个方法可能不会最终处理present但总是以模态的方式present。在水平紧凑环境中，该方法采用该present风格。
             */
            self.presentViewController(viewController, animated: true, completion: {
                
            })
//            self.showViewController(viewController, sender: nil)
//            self.showDetailViewController(viewController, sender: nil)
        }
        buttonCount += 1;
        
        self.addButtonToView("present", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { [unowned self] (button) in
            let viewController = TableViewController1()
            viewController.modalPresentationStyle = .Popover
            
            //画面从下向上徐徐弹出，关闭时向下隐藏（默认方式）。
//            viewController.modalTransitionStyle = .CoverVertical
            
//            self.presentViewController(viewController, animated: true, completion: {
//                
//            })
            self.showViewController(viewController, sender: nil)
//            self.showDetailViewController(viewController, sender: nil)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
