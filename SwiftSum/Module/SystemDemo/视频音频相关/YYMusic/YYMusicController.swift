//
//  YYMusicController.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

/*
 SUMusic：电台律动 http://www.jianshu.com/p/819fbc4934d2
 
 在线音乐电台类APP，采用豆瓣电台接口，gitHub地址：电台律动
 
 功能
 1、登录功能（豆瓣接口）
 2、电台频道切换功能（豆瓣接口）
 3、跳过当前歌曲、红心歌曲、ban掉歌曲功能（豆瓣接口）
 4、显示歌词功能（豆瓣接口）
 5、收藏频道功能（本地储存）
 6、离线歌曲功能（本地储存）
 7、分享歌曲到微博、朋友圈功能
 8、Play Center
 9、Remote Control
 10、事件打断处理
 11、网络状态处理
 */

class YYMusicController: UITabBarController {

    // MARK: - UITabBarController手势左右滑动
    var panGesture = UIPanGestureRecognizer()
    let tabBarTransitionDelegate = YYTabBarTransitionDelegate()
    var subViewControllersCount: Int {
        return viewControllers != nil ? viewControllers!.count : 0
    }
    
    let tabBarItems = [
        TabBarItemInfo(storyBoardName: "YYMusicHome", titleTab: "主页", imageName: nil, imageNameSelected: nil),
        TabBarItemInfo(storyBoardName: "YYMusicMine", titleTab: "我的", imageName: nil, imageNameSelected: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }
    
    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        self.appendViewControllers(tabBarItems)
        
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
            switch panGesture.direction {
            case .left:
                if selectedIndex < subViewControllersCount - 1 {
                    selectedIndex += 1
                }
            default:
                if selectedIndex > 0  {
                    selectedIndex -= 1
                }
            }
        case .Changed:
            tabBarTransitionDelegate.interactionController.updateInteractiveTransition(progress)
        case .Ended, .Cancelled:
            if progress > 0.3 {
                tabBarTransitionDelegate.interactionController.completionSpeed = 0.99
                tabBarTransitionDelegate.interactionController.finishInteractiveTransition()
            } else {
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















