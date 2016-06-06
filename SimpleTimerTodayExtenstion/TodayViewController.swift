//
//  TodayViewController.swift
//  SimpleTimerTodayExtenstion
//
//  Created by sihuan on 16/6/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var label: UILabel!
    
    let userDefaultsSuitName = "group.simpleTimerSharedDefaults"
    let maxCount = 15
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitData()
    }
    
    
    func setupInitData() {
        let userDefaults = NSUserDefaults(suiteName: "group.simpleTimerSharedDefaults")!
        let leftTimeWhenQuit = userDefaults.integerForKey("com.onevcat.simpleTimer.lefttime")
        let quitDate = userDefaults.integerForKey("com.onevcat.simpleTimer.quitdate")
        
        let passedTimeFromQuit = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: NSTimeInterval(quitDate)))
        
        let leftTime = leftTimeWhenQuit - Int(passedTimeFromQuit)
        
        label.text = "\(leftTime)"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
