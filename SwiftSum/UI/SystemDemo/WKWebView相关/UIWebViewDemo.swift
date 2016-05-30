//
//  UIWebViewDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/20.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import JavaScriptCore

/*
 关于UIWebView类，你需要知道的一些属性和方法
 
 属性：
 
 loading：是否处于加载中
 canGoBack：A Boolean value indicating whether the receiver can move backward. (只读)
 canGoForward：A Boolean value indicating whether the receiver can move forward. (只读)
 request：The URL request identifying the location of the content to load. (read-only)
 方法：
 
 loadData：Sets the main page contents, MIME type, content encoding, and base URL.
 loadRequest：加载网络内容
 loadHTMLString：加载本地HTML文件
 stopLoading：停止加载
 goBack：后退
 goForward：前进
 reload：重新加载
 stringByEvaluatingJavaScriptFromString：执行一段js脚本，并且返回执行结果
 
 */
class UIWebViewDemo: UIViewController {
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    lazy var webView: UIWebView = {
        
        let webView = UIWebView()
        webView.delegate = self
        return webView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }
    
    // MARK: - Initialization
    
    func setupContext() {
        setupUI()
        requestData()
    }
    
    func setupUI() {
        title = "商品详情"
        view.addSubview(webView)
        webView.addConstraintFillSuperView()
        
        //在这里注入的话，自定义的click2和click3方法不起作用，因为这2个函数被html中自带的js替换掉了
        injectionJS()
        injectionNativeMethodToJS()
        
        buttonCount = 6
        addButtonToViewWithTitle("返回") { [unowned self] (button) in
            if self.webView.canGoBack {
                self.webView.goBack()
            }
        }
        addButtonToViewWithTitle("前进") { [unowned self] (button) in
            if self.webView.canGoForward {
                self.webView.goForward()
            }
        }
        
        // MARK: - 五、webView 执行JS代码
        //用户调用用JS写过的代码，一般指服务端开发的：
        addButtonToViewWithTitle("调用js，异步获取返回值") { [unowned self] (button) in
            //Native调用Javascript语言，是通过UIWebView组件的stringByEvaluatingJavaScriptFromString方法来实现的，该方法返回js脚本的执行结果。

            let tripleNum: JSValue = self.webView.currentJSContext.evaluateScript("JSExportDemo.test0()")
            //像JavaScript这类动态语言需要一个动态类型（Dynamic Type）， 所以正如代码最后一行所示，JSContext里不同的值均封装在JSValue对象中，包括字符串、数值、数组、函数等，甚至还有Error以及null和undefined。self.webView.stringByEvaluatingJavaScriptFromString("Math.random()")
            
            self.webView.currentJSContext.evaluateScript("JSExportDemo.test2('参数A','参数B')")
            self.webView.currentJSContext.evaluateScript("testJs('参数A','参数B')")
        }
    }
    
    // MARK: - Network
    
    func requestData() {
        if let htmlPath = NSBundle.mainBundle().pathForResource("ExampleApp.html", ofType: nil) {
            let appHtml = try! String(contentsOfFile: htmlPath, encoding: NSUTF8StringEncoding)
            let baseUrl = htmlPath.toNSURL()
            //baseUrl = "/Users/sihuan/Library/Developer/CoreSimulator/Devices/535705F5-E5E0-42BE-97AD-12449DDA7676/data/Containers/Bundle/Application/3DCAF7E1-603C-4529-83ED-3E89AD2ED388/SwiftSum.app/ExampleApp.html"
            webView.loadHTMLString(appHtml, baseURL: baseUrl)
        }
    }
    
    
    // MARK: - Private
    
    // MARK: - ## 四、动态加载并运行JS代码
    //用于在客户端内部加入JS代码，并执行，示例如下：
    func injectionJS() {
        // js代码
        let jsString = "ExampleApp.js".contentsOfRescource()
        
        webView.currentJSContext.evaluateScript(jsString!)
    }
    
    // MARK: - ## 六、JS调用App注册过的方法
    func injectionNativeMethodToJS() {
        
        let jsContext = webView.currentJSContext
        
        let simplifyString: String -> String = { input in
            for value in JSContext.currentArguments() {
                print(value)
            }
            return "testJs"
        }
        
        /**
         *  其中testJs就是js的方法名称，赋给是一个block 里面是iOS代码
         此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
         */
//        jsContext.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "testJs")
        
        JSBridgeManager.addMethod("JSExportDemo.test0", toJSContext: jsContext, methodObject: self)
    }
    
}

extension UIWebViewDemo: JSExportProtocol {
    func test0() {
        print(#function)
    }
    func test1(para: String) {
        print(#function + " " + para)
    }
    func test2(para: String, _ para2: String) {
        print(#function + " " + para + " " + para2)
    }
}

extension UIWebViewDemo: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        //在这里注入也不行
        injectionJS()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        //必须在这里或之后的时间点才行
        injectionJS()
    }
}










