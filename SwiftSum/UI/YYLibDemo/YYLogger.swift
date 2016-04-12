//
//  YYLogger.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

/// 显示log的黑板
class YYLoggerBoard: UIView {
    /*
     * 追加要显示的log
     */
    func appendLog(text: String) {
        self.updateLog(textView.text + text)
    }
    func updateLog(text: String) {
        textView.text = text
        if textView.contentSize.height - (textView.contentOffset.y+CGRectGetHeight(bounds)) <= 30 {
            textView.scrollRangeToVisible(NSRange(location: textView.text.characters.count, length: 1))
        }
    }
    
    var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContext()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContext() {
        backgroundColor = UIColor.clearColor()
        
        textView = UITextView(frame: bounds)
        textView.backgroundColor = UIColor.darkGrayColor()
        textView.textColor = UIColor.whiteColor()
        textView.font = UIFont.systemFontOfSize(15)
        textView.editable = false
        //default is YES  will reset scoll contentoffset
        textView.layoutManager.allowsNonContiguousLayout = false
        addSubview(textView)
    }
}

/// 实时显示Log日志在手机屏幕上。
class YYLogger: NSObject {
    static let sharedInstance = YYLogger()
    
    /**
     *  描述：初始化Logger
     */
    static func start() {
        YYLogger.sharedInstance.startSaveLog()
    }
    
    /**
     *  描述：改变Log面板状态(隐藏->显示 or 显示->隐藏)
     */
    static func boardVisbilitySwitch() {
        (YYLogger.sharedInstance.timer != nil) ? YYLogger.sharedInstance.hide() : YYLogger.sharedInstance.show()
    }
    
    /**
     *  描述：显示Log面板
     */
    static func showBoard() {
        YYLogger.sharedInstance.show()
    }
    /**
     *  描述：隐藏Log面板
     */
    static func hideBoard() {
        YYLogger.sharedInstance.hide()
    }
    
    var loggerBoard: YYLoggerBoard!
    
    var timer: NSTimer!
    
    let logPath: String = {
        return String.documentPath() + "YYLogger.log"
    }()
    
    func startSaveLog() {
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(logPath)
            
            //export log to file
            let cPath = logPath.cStringUsingEncoding(NSASCIIStringEncoding)
            freopen(unsafeBitCast(cPath, UnsafePointer<Int8>.self), "a+", stdout)
            freopen(unsafeBitCast(cPath, UnsafePointer<Int8>.self), "a+", stderr)
        } catch {
            
        }
    }
    
    func loadLog() {
        if let logData = NSData(contentsOfFile: logPath) {
            let logText = String.init(data: logData, encoding: NSUTF8StringEncoding)
            self.loggerBoard.updateLog(logText!)
        }
    }
    
    func show() {
        loggerBoard = YYLoggerBoard(frame: UIScreen.mainScreen().bounds)
        loggerBoard.alpha = 0
        UIApplication.sharedApplication().keyWindow?.addSubview(loggerBoard)
        UIView.animateWithDuration(0.2) {
            self.loggerBoard.alpha = 1
        }
        loadLog()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(loadLog), userInfo: nil, repeats: true)
    }
    
    func hide() {
        UIView.animateWithDuration(0.2, animations: { self.loggerBoard.alpha = 0 }) { completion in
            self.loggerBoard = nil
        }
        timer.invalidate()
        timer = nil
    }
    
    
}









