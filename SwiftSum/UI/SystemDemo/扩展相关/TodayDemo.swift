//
//  TodayDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

// MARK: - 为这个 app 做一个 Today 扩展，来在通知中心中显示并更新当前的剩余时间，并且在计时完成后显示一个按钮，点击后可以回到 app 本体，并弹出一个完成的提示。

class TodayDemo: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    let userDefaultsSuitName = "group.simpleTimerSharedDefaults"
    let maxCount = 15
    var count = 0
    lazy var timer: YYTimer = {
        // MARK: - 注意 这里如果用unowned self，会crash
        let timer = YYTimer(timeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.updateLabel()
        }
        return timer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        self.addButtonToViewWithTitle("start") { [unowned self] (button) in
            self.timer.resume()
        }
        self.addButtonToViewWithTitle("pause") { [unowned self] (button) in
            self.timer.pause()
        }
        self.addButtonToViewWithTitle("stop") { [unowned self] (button) in
            self.timer.invalidate()
        }
        
        //程序失去前台的监听
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillResignActiveNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (_) in
            //在应用切到后台时，如果正在计时，我们就将当前的剩余时间和退出时的日期存到了 NSUserDefaults 中。
            if self.timer.isRunning {
                self.saveDefaults(self.maxCount - self.count)
            } else {
                self.clearDefaults()
            }
        }
    }
    
    func updateLabel() {
        label.text = "00:" + String(count)
        if count >= maxCount {
            showFinishAlert(finished: true)
            timer.invalidate()
            return
        }
        count += 1
    }
    
    private func showFinishAlert(finished  finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[weak ac] action in ac!.dismissViewControllerAnimated(true, completion: nil)}))
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit TodayDemo")
    }
}


extension TodayDemo {
     func saveDefaults(leftTime: Int) {
        
        //这里我们需要这两个数据能够被扩展访问到的话，我们必须使用在 App Groups 中定义的名字来使用 NSUserDefaults。
        let userDefault = NSUserDefaults(suiteName: userDefaultsSuitName)
        userDefault!.setInteger(leftTime, forKey: "com.onevcat.simpleTimer.lefttime")
        userDefault!.setInteger(Int(NSDate().timeIntervalSince1970), forKey: "com.onevcat.simpleTimer.quitdate")
        
        userDefault!.synchronize()
    }
    
      func clearDefaults() {
        let userDefault = NSUserDefaults(suiteName: userDefaultsSuitName)
        userDefault!.removeObjectForKey("com.onevcat.simpleTimer.lefttime")
        userDefault!.removeObjectForKey("com.onevcat.simpleTimer.quitdate")
        
        userDefault!.synchronize()
    }
}
