//
//  SimpleTimer.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit


public let keyLeftTime = "com.onevcat.simpleTimer.lefttime"
public let keyQuitDate = "com.onevcat.simpleTimer.quitdate"

let timerErrorDomain = "SimpleTimerError"

public enum SimpleTimerError: Int {
    case AlreadyRunning = 1001
    case NegativeLeftTime
    case NotRunning
}

extension NSTimeInterval {
    func toMMSS() -> String {
        let totalSecond = Int(self)
        let minute = totalSecond / 60
        let second = totalSecond % 60
        
        switch (minute, second) {
        case (0...9, 0...9):
            return "0\(minute):0\(second)"
        case (_, 0...9):
            return "\(minute):0\(second)"
        case (0...9, _):
            return "0\(minute):\(second)"
        default:
            return "\(minute):\(second)"
        }
    }
}

public class SimpleTimer {
    public var running = false
    public var leftTime: NSTimeInterval {
        didSet {
            if leftTime < 0 {
                leftTime = 0
            }
        }
    }
    public var leftTimeString: String {
        return leftTime.toMMSS()
    }
    
    private var timerTickHandler: (NSTimeInterval -> Void)? = nil
    private var timerStopHandler: (Bool -> Void)? = nil
    private var timer: NSTimer!
    
    public init(timeInterval: NSTimeInterval) {
        leftTime = timeInterval
    }
    
    public func stop(interrupt: Bool) -> (stopped: Bool, error: NSError?) {
        if !running {
            return (false, NSError(domain: timerErrorDomain, code: SimpleTimerError.NotRunning.rawValue, userInfo:nil))
        }
        running = false
        timer.invalidate()
        timer = nil
        
        if let stopHandler = timerStopHandler {
            stopHandler(!interrupt)
        }
        
        timerStopHandler = nil
        timerTickHandler = nil
        
        return (true, nil)
    }
    
    public func start(updateTick updateTick: (NSTimeInterval -> Void)?, stopHandler: (Bool -> Void)?) -> (start: Bool, error: NSError?) {
        if running {
            return (false, NSError(domain: timerErrorDomain, code: SimpleTimerError.AlreadyRunning.rawValue, userInfo:nil))
        }
        
        if leftTime < 0 {
            return (false, NSError(domain: timerErrorDomain, code: SimpleTimerError.NegativeLeftTime.rawValue, userInfo:nil))
        }
        
        timerTickHandler = updateTick
        timerStopHandler = stopHandler
        
        running = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(countTick), userInfo: nil, repeats: true)
        
        return (true, nil)
    }
    
    dynamic private func countTick() {
        leftTime = leftTime - 1
        if let tickHandler = timerTickHandler {
            tickHandler(leftTime)
        }
        if leftTime <= 0 {
            stop(false)
        }
    }
}





















