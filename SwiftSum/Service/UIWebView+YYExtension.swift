//
//  UIWebView+YYExtension.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import JavaScriptCore

extension UIWebView {
    var currentJSContext: JSContext {
        return self.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
    }
}

