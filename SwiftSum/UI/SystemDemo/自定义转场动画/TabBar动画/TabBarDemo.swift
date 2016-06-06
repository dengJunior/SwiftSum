//
//  TabBarDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

// MARK: - UITabBarController手势左右滑动
class TabBarDemo: UITabBarController {

    var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    let tabBarTransitionDelegate = YYTabBarTransitionDelegate()
    var subViewControllerCount: Int {
        return viewControllers != nil ? viewControllers!.count : 0
    }
    
    let tabBarItemsInfo = [
        TabBarItemInfo(storyBoardName: "SystemDemo", titleTab: "SystemDemo", imageName: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "YYLibDemo", titleTab: "YYLibDemo", imageName: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "ThirdLibDemo", titleTab: "ThirdLibDemo", imageName: nil, imageNameSelected: nil),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }
    
    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        self.appendViewControllers(tabBarItemsInfo)
        
        delegate = tabBarTransitionDelegate
        tabBar.tintColor = UIColor.greenColor()
        panGesture.addTarget(self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func handlePan(panGesture: UIPanGestureRecognizer) {
        let translationX = panGesture.translationInView(view).x
        let translationAbs = abs(translationX)
        let progress = translationAbs / view.frame.width
        
        switch panGesture.state {
        case .Began:
            tabBarTransitionDelegate.interactive = true
            /*
             velocityInView:这个方法，这个方法是获取手势在指定视图坐标系统的移动速度，结果发现这个速度是具有方向的，
             
             CGPoint velocity = [recognizer velocityInView:recognizer.view];
             if(velocity.x > 0) {//向右滑动}
             else { //向左滑动 }
             */
            let velocityX = panGesture.velocityInView(view).x
            let direction = panGesture.direction
            if direction == .Left  {
                if selectedIndex < subViewControllerCount - 1 {
                    selectedIndex += 1
                }
            } else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }
        case .Changed:
            tabBarTransitionDelegate.interactionController.updateInteractiveTransition(progress)
        case .Ended, .Cancelled:
            /*这里有个小问题，转场结束或是取消时有很大几率出现动画不正常的问题。在8.1以上版本的模拟器中都有发现，7.x 由于缺乏条件尚未测试，
             但在我的 iOS 9.2 的真机设备上没有发现，而且似乎只在 UITabBarController 的交互转场中发现了这个问题。在 NavigationController 暂且没发现这个问题，
             Modal 转场尚未测试，因为我在 Demo 里没给它添加交互控制功能。
             
             测试不完整，具体原因也未知，不过解决手段找到了。多谢 @llwenDeng 发现这个 Bug 并且找到了解决手段。
             解决手段是修改交互控制器的 completionSpeed 为1以下的数值，这个属性用来控制动画速度，我猜测是内部实现在边界判断上有问题。
             这里其修改为0.99，既解决了 Bug 同时尽可能贴近原来的动画设定。
             */
            if progress > 0.3 {
                tabBarTransitionDelegate.interactionController.completionSpeed = 0.99
                tabBarTransitionDelegate.interactionController.finishInteractiveTransition()
            } else{
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                tabBarTransitionDelegate.interactionController.completionSpeed = 0.99
                tabBarTransitionDelegate.interactionController.cancelInteractiveTransition()
            }
            tabBarTransitionDelegate.interactive = false
        default:
            break
        }
    }
}
























