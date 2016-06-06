//
//  YYTimer.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


// MARK: - block方式回调的timer
public class YYTimer {
    public var isValid: Bool {
        return timer.valid
    }
    public var timeInterval: NSTimeInterval {
        return timer.timeInterval
    }
    public var isRunning: Bool = false
    
    var timer: NSTimer!
    var callback: ((timer: YYTimer) -> ())?
    
    var pauseDate: NSDate?
    var previousFireDate: NSDate?
    
    public static func scheduled(delay millisecond: Int64 = 0, timeInterval: NSTimeInterval, repeats: Bool, callback: (timer: YYTimer) -> ()) -> YYTimer {
        let timer = YYTimer(timeInterval: timeInterval, repeats: repeats, callback: callback)
        
        if millisecond > 0 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC) * millisecond), dispatch_get_main_queue()) {
                timer.resume()
            }
        } else {
            timer.resume()
        }
        return timer
    }
    
    public init(timeInterval: NSTimeInterval, repeats: Bool, callback: (timer: YYTimer) -> ()) {
        self.callback = callback
        let timerTarget = YYTimerTarget(timer: self)
        timer = NSTimer(timeInterval: timeInterval, target: timerTarget, selector: #selector(YYTimerTarget.timerCallback), userInfo: nil, repeats: repeats)
    }
    
    public func resume() {
        if !isRunning && isValid {
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            let fireDate: NSDate
            if let previousFireDate = previousFireDate, let pauseDate = pauseDate {
                fireDate = NSDate(timeInterval: -pauseDate.timeIntervalSinceNow, sinceDate: previousFireDate)
            } else {
                fireDate = NSDate()
            }
            timer.fireDate = fireDate
            isRunning = true
        }
    }
    
    public func pause() {
        if isRunning && isValid {
            previousFireDate = timer.fireDate
            pauseDate = NSDate()
            timer.fireDate = NSDate.distantFuture()
            isRunning = false
        }
    }
    
    //调用invalidate后，resume无效
    public func invalidate() {
        timer.invalidate()
        isRunning = false
    }
    
    deinit {
        print("deinit YYTimer")
        timer.invalidate()
    }
}

private class YYTimerTarget {
    weak var timer: YYTimer?
    init(timer: YYTimer) {
        self.timer = timer
    }
    
    @objc func timerCallback() {
        timer?.callback?(timer: timer!);
    }
    deinit {
        print("deinit YYTimerTarget")
    }
}












