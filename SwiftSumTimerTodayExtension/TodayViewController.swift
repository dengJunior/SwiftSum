//
//  TodayViewController.swift
//  SwiftSumTimerTodayExtension
//
//  Created by sihuan on 2016/6/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import NotificationCenter
import YYKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var label: UILabel!
    
    let userDefaultsSuitName = "group.yy.SwiftSum"
    let maxCount = 15
    var count = 0
    
    var timer: SimpleTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitData()
    }
    
    
    func setupInitData() {
        let userDefaults = NSUserDefaults(suiteName: userDefaultsSuitName)!
        let leftTimeWhenQuit = userDefaults.integerForKey("com.onevcat.simpleTimer.lefttime")
        let quitDate = userDefaults.integerForKey("com.onevcat.simpleTimer.quitdate")
        
        let passedTimeFromQuit = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: NSTimeInterval(quitDate)))
        
        var leftTime = leftTimeWhenQuit - Int(passedTimeFromQuit)
        leftTime = 10
        if leftTime > 0 {
            timer = SimpleTimer(timeInterval: NSTimeInterval(leftTime))
        }
        
        let (started, error) =  timer.start(updateTick: { (timeInterval) in
            self.updateLabel()
            }, stopHandler: { (stopped) in
                self.showOpenAppButton()
        })
        if started {
            self.updateLabel()
        } else if let error = error {
            print(error)
        }
    }
    
    private func updateLabel() {
        label.text = timer.leftTimeString
    }
    
    private func showOpenAppButton() {
        label.text = "Finished"
        
        //调整一下扩展 widget 的尺寸，以让我们有更多的空间显示按钮，这可以通过设定 preferredContentSize 来做到。
        //在设定 preferredContentSize 时，指定的宽度都是无效的，系统会自动将其处理为整屏的宽度，所以扔个 0 进去就好了。
        preferredContentSize = CGSize(width: 0, height: 100)
        
        //在这里添加按钮时，本来应该使用Auto Layout的
        let button = UIButton(frame: CGRectMake(0, 50, 50, 63))
        button.setTitle("Open", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
    }
    
    
    // MARK: - 通过扩展启动主体应用
    
    /**
     在通知中心计时完毕后，在扩展上呈现一个 "完成啦" 的按钮，并通过点击这个按钮能回到应用，并在应用内弹出结束的 alert。
     
     关键在于我们要如何启动主体容器应用，以及向其传递数据。
     
     - 通过 URL 启动应用，我们一般需要调用 UIApplication 的 openURL 方法。如果细心的刚才看了 NS_EXTENSION_UNAVAILABLE 的同学可能会发现这个方法是被禁用的
     
     - 为了完成同样的操作，Apple 为扩展提供了一个 NSExtensionContext 类来与宿主应用进行交互。用户在宿主应用中启动扩展后，宿主应用提供一个上下文给扩展，里面最主要的是包含了 inputItems 这样的待处理的数据。
     */
    @objc private func buttonPressed() {
        extensionContext?.openURL(NSURL(string: "SwiftSum://finished")!, completionHandler: nil)
    }
    
    /**
     对于通知中心扩展，即使你的扩展现在不可见 (也就是用户没有拉开通知中心)，系统也会时不时地调用实现了 NCWidgetProviding 的扩展的这个方法，来要求扩展刷新界面。
     
     这个机制和[iOS 7 引入的后台机制](http://onevcat.com/2013/08/ios7-background-multitask/)是很相似的。在这个方法中我们一般可以做一些像 API 请求之类的事情，在获取到了数据并更新了界面，或者是失败后都使用提供的 completionHandler 来向系统进行报告。
     
     值得注意的一点是 Xcode  所提供的模板文件的 ViewController 里虽然有这个方法，但是它默认并没有 conform 这个接口，所以要用的话，我们还需要在类声明时加上 NCWidgetProviding。
     */
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}
