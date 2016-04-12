//
//  YYLoggerDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYLoggerDemo: UIViewController {

    var count = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YYLogger.start()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(giveLog), userInfo: nil, repeats: true)
    }

    func giveLog() -> Void {
        print("this is NO.\(count)")
        count += 1
    }
    

    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake {
            YYLogger.boardVisbilitySwitch()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
