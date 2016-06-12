//
//  AppDelegate.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - UI的状态保持和恢复
    /**
     *  为了实现点击Home键使程序退出，可以在设置属性*-info.plist修改Application does not run in background属性值为YES
     
     为实现UI的状态保持和恢复，包括APP层面和storyboard层面，首要条件就是需要在AppDelegate.m文件添加以下两个方法。
     */
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    let lastShutDownTimeKey = "lastShutDownTime"
    func application(application: UIApplication, willEncodeRestorableStateWithCoder coder: NSCoder) {
        let currentDateString = NSDate().stringFromFormatDefault();
        coder.encodeObject(currentDateString, forKey: lastShutDownTimeKey)
        print("application willEncodeRestorableStateWithCoder 时间为:\(currentDateString)")
    }
    
    func application(application: UIApplication, didDecodeRestorableStateWithCoder coder: NSCoder) {
        if let currentDateString = coder.decodeObjectForKey(lastShutDownTimeKey) as? String {
            let alert = UIAlertView(title: "上次关闭时间", message: currentDateString, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // MARK: - 和Extension的交互
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        print(#function)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print(#function)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(#function)
        return handleUrl(url)
    }
    
    func handleUrl(url: NSURL) -> Bool {
        if url.scheme == "SwiftSum" {
            if url.host == "finished" {
                SimpleTimerNotification.postNotification(.taskDidFinishedInWidget)
            }
            return true
        }
        return false
    }
    
    // MARK: - 3DTouch
    
    func add3DTouch() {
        
        // MARK: dynamic quick actions的集成
        
        /**
         注意：需要强调的是，快捷操作项最多定义4个。就像苹果官方的比喻一样：这里一共就有4个插槽，也就是最多显示4个快捷操作项。程序优先加载Info.plist文件中定义的静态快捷操作项，如果Info.plist中的静态快捷操作项不足4个才会去加载代码定义的动态快捷操作项（前提是代码中定义了动态快捷操作项）来补充剩余的插槽。
         */
        
        //使用系统提供的ShortcutIcon类型
        if #available(iOS 9.0, *) {
            let addOpportunityIcon = UIApplicationShortcutIcon(type: .Add)
            let addOpportunityItem = UIMutableApplicationShortcutItem(type: "addOpportunity", localizedTitle: "添加机会", localizedSubtitle: "tianjiajihui", icon: addOpportunityIcon, userInfo: nil)
            
            let bookMarkIcon = UIApplicationShortcutIcon(type: .Compose)
            let bookMarkItem = UIMutableApplicationShortcutItem(type: "bookMark", localizedTitle: "添加小记", localizedSubtitle: "xiaoji", icon: bookMarkIcon, userInfo: nil)
            
            let searchGuestIcon = UIApplicationShortcutIcon(type: .Compose)
            let searchGuestItem = UIMutableApplicationShortcutItem(type: "bookMark", localizedTitle: "搜索客户", localizedSubtitle: "通过关键字搜索感兴趣客户", icon: searchGuestIcon, userInfo: nil)
            
            //自定义ShortcutIcon
            // 如果设置了自定义的icon，那么系统自带的就不生效
            let myGuestIcon = UIApplicationShortcutIcon(templateImageName: "myGuestImage")
            let myGuestItem = UIMutableApplicationShortcutItem(type: "myGuest", localizedTitle: "我的客户", localizedSubtitle: nil, icon: myGuestIcon, userInfo: nil)
            UIApplication.sharedApplication().shortcutItems = [addOpportunityItem,bookMarkItem,searchGuestItem,myGuestItem]
        }
        
    }
    
    // MARK: - 作用：点击快速启动项菜单上的某个快速启动项跳转到指定界面
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        // 方式一：type
        if shortcutItem.type == "addOpportunity" {
            print("点击了添加机会item")
        }
        
        // 方式二：title或者subtitle
        if shortcutItem.localizedTitle == "添加小记" {
            print("点击了添加小记item")
        }
    }
}























