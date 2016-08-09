//
//  WKWebViewDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import WebKit

/*
 ### WKWebView 有以下几大主要进步：
 
 1. 将浏览器内核渲染进程提取出 App，由系统进行统一管理，这减少了相当一部分的性能损失。
 2. 在性能、稳定性、功能方面有很大提升（最直观的体现就是加载网页是占用的内存，模拟器加载百度与开源中国网站时，WKWebView占用23M，而UIWebView占用85M）；
 3. 允许JavaScript的Nitro库加载并使用（UIWebView中限制）；
 4. 支持了更多的HTML5特性；
 5. 高达60fps的滚动刷新率以及内置手势；
 6. 将UIWebViewDelegate与UIWebView重构成了14类与3个协议；
 
 
 */

class WKWebViewDemo: UIViewController {
    
    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.minimumFontSize = 10// 默认为0
        preferences.javaScriptEnabled = true// 默认认为true
        preferences.javaScriptCanOpenWindowsAutomatically = true//默认为NO，表示不能自动通过js打开窗口
        
        // web内容处理池
        let processPool = WKProcessPool()
        
        //拥有一些属性来作为原生代码和网页之间沟通的桥梁。
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.processPool = processPool
        
        let webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.navigationDelegate = self
        webView.UIDelegate = self
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
        injectionJS()
        injectionNativeMethodToJS()
        
        buttonCount = 6
        addButtonToView(title: "UIWebView与js交互") { [unowned self] (button) in
            self.navigationController?.pushViewController(UIWebViewDemo(), animated: true)
        }
        
        addButtonToView(title: "返回") { [unowned self] (button) in
            if self.webView.canGoBack {
                self.webView.goBack()
            }
        }
        addButtonToView(title: "前进") { [unowned self] (button) in
            if self.webView.canGoForward {
                self.webView.goForward()
            }
        }
        
        // MARK: - 五、webView 执行JS代码
        //用户调用用JS写过的代码，一般指服务端开发的：
        addButtonToView(title: "调用js，异步获取返回值") { [unowned self] (button) in
            //javaScriptString是JS方法名，completionHandler是异步回调block
            self.webView.evaluateJavaScript("click1()", completionHandler: { (obj, error) in
                print(obj)
                /** obj是click1()返回的数据
                 Optional({
                 age = 26;
                 name = jack;
                 })
                 */
                if let person = obj as? NSDictionary {
                    for (key, value) in person {
                        print("\(key) \(value)")
                    }
                }
            })
        }
    }
    
    // MARK: - Network
    
    func requestData() {
        //        let str = "http://www.baidu.com"
        //        webView.loadUrlString(str)
        
        loadExamplePage()
    }
    
    
    // MARK: - Private
    
    // MARK: - ## 四、动态加载并运行JS代码
    //用于在客户端内部加入JS代码，并执行，示例如下：
    func injectionJS() {
        // 通过JS与webview内容交互
        //        let userContentController = WKUserContentController()
        
        // js代码
        let jsString = "ExampleApp.js".contentsOfRescource()
        // 根据JS字符串初始化WKUserScript对象
        
        /*
         用.AtDocumentStart的话，自定义的click2和click3方法不起作用，因为这2个函数被html中自带的js替换掉了
         要使用 .AtDocumentEnd
         */
        let script = WKUserScript(source: jsString!, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        //        webView.configuration.userContentController = userContentController
        webView.configuration.userContentController.addUserScript(script)
    }
    
    // MARK: - ## 六、JS调用App注册过的方法
    func injectionNativeMethodToJS() {
        //再WKWebView里面注册供JS调用的方法，是通过WKUserContentController类下面的方法：
        /**
         - parameter <TscriptMessageHandler: 是代理回调，JS调用name方法后，OC会调用scriptMessageHandler指定的对象。
         - parameter name:                   方法名
         */
        webView.configuration.userContentController.addScriptMessageHandler(self, name: "test")
        
        //JS在调用OC注册方法的时候要用下面的方式：
        
        //window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
        //注意，name(方法名)是放在中间的，messageBody只能是一个对象，如果要传多个值，需要封装成数组，或者字典。整个示例如下：
    }
    
    //ios8 设置userAgent
    func setUserAgent() {
        /** http://stackoverflow.com/questions/26994491/set-useragent-in-wkwebview
         self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
         __weak typeof(self) weakSelf = self;
         
         [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         
         NSString *userAgent = result;
         NSString *newUserAgent = [userAgent stringByAppendingString:@" Appended Custom User Agent"];
         
         NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
         [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
         
         strongSelf.wkWebView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
         
         // After this point the web view will use a custom appended user agent
         [strongSelf.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
         NSLog(@"%@", result);
         }];
         }];
         */
    }
    
    
    func loadExamplePage() {
        if let htmlPath = NSBundle.mainBundle().pathForResource("ExampleApp.html", ofType: nil) {
            let appHtml = try! String(contentsOfFile: htmlPath, encoding: NSUTF8StringEncoding)
            let baseUrl = htmlPath.toNSURL()
            //baseUrl = "/Users/sihuan/Library/Developer/CoreSimulator/Devices/535705F5-E5E0-42BE-97AD-12449DDA7676/data/Containers/Bundle/Application/3DCAF7E1-603C-4529-83ED-3E89AD2ED388/SwiftSum.app/ExampleApp.html"
            webView.loadHTMLString(appHtml, baseURL: baseUrl)
        }
    }
    
    // MARK: - 读取本地的HTML
    /*
     当使用loadRequest来读取本地的HTML时，WKWebView是无法读取成功的，后台会出现如下的提示：
     Could not create a sandbox extension for /
     原因是WKWebView是不允许通过loadRequest的方法来加载本地根目录的HTML文件。
     
     而在iOS9的SDK中加入了以下方法来加载本地的HTML文件：[WKWebView loadFileURL:allowingReadAccessToURL:]
     但是在iOS9以下的版本是没提供这个便利的方法的。以下为解决方案的思路，就是在iOS9以下版本时，先将本地HTML文件的数据copy到tmp目录中，然后再使用loadRequest来加载。
     但是如果在HTML中加入了其他资源文件，例如js，css，image等必须一同copy到temp中。
     */
    func fileURLForBuggyWKWebView8(fileUrl: NSURL) {
        //        NSError *error = nil;
        //        if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        //            return nil;
        //        }
        //        // Create "/temp/www" directory
        //        NSFileManager *fileManager= [NSFileManager defaultManager];
        //        NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
        //        [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
        //
        //        NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
        //        // Now copy given file to the temp directory
        //        [fileManager removeItemAtURL:dstURL error:&error];
        //        [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
        //        // Files in "/temp/www" load flawlesly :)
        //        return dstURL;
    }
}

// MARK: - Life cycle
extension WKWebViewDemo {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Override
extension WKWebViewDemo {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

/*
 ###  网页加载的过程。
 
 网页加载由一个动作（Action）触发。这可能是任何导致网页加载的动作，比如：触碰一个链接、点击后退、前进和刷新按钮，JavaScript 设置了window.location属性，子窗口的加载或者对WKWebView的loadRequest（）方法的调用。
 
 然后一个请求被发送到了服务器，我们会得到一个响应（可能是有意义的也可能是错误状态码，比如：404）。最后服务器会发送更多地数据，并结束加载过程。
 
 WebKit允许你的App在动作（Action）和响应（Response）阶段之间注入代码，并决定是否继续加载，取消或是做你想做的事情。
 
 请求http://www.baidu.com成功后调用顺序，会被重定向到m.baidu.com
 webView(_:decidePolicyForNavigationAction:decisionHandler:)
 webView(_:didStartProvisionalNavigation:)
 webView(_:decidePolicyForNavigationAction:decisionHandler:)
 webView(_:didReceiveServerRedirectForProvisionalNavigation:)
 webView(_:didReceiveAuthenticationChallenge:completionHandler:)
 webView(_:decidePolicyForNavigationResponse:decisionHandler:)
 webView(_:didCommitNavigation:)
 webView(_:didFailNavigation:withError:)
 webView(_:decidePolicyForNavigationAction:decisionHandler:)
 webView(_:didStartProvisionalNavigation:)
 webView(_:decidePolicyForNavigationResponse:decisionHandler:)
 webView(_:didCommitNavigation:)
 webView(_:didFinishNavigation:)
 */

// MARK: - Delegate
extension WKWebViewDemo: WKNavigationDelegate {
    // MARK: - 用来追踪加载过程（页面开始加载、加载完成、加载失败）的方法
    
    // 1.2 页面开始加载时调用
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    // 3.2 当内容开始返回时调用
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print(#function)
    }
    // 3.3 页面加载完成之后调用
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print(#function)
    }
    // 3.3 页面加载失败时调用
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print(#function)
    }
    
    //iOS9
    func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        print(#function)
    }
    
    // MARK: - 页面跳转的代理方法：
    
    // 1.1 在发送请求之前，决定是否跳转，可能调用多次
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print(#function)
        /**
         请求http://www.baidu.com成功后调用顺序，会被重定向到m.baidu.com
         
         第一次 po navigationAction
         <WKNavigationAction: 0x7fe8aaef7770;navigationType=-1;request=<NSMutableURLRequest: 0x7fe8aac939d0>{
         URL: http: //www.baidu.com/
         };sourceFrame=(null);targetFrame=<WKFrameInfo: 0x7fe8aaef1e10;isMainFrame=YES;request=<NSMutableURLRequest: 0x7fe8ad050090>{
         URL: (null)
         }>>
         
         第二次 po navigationAction
         <WKNavigationAction: 0x7fe8aaf25b80;navigationType=-1;request=<NSMutableURLRequest: 0x7fe8ad03ea70>{
         URL: https: //m.baidu.com/?from=844b&vit=fps
         };sourceFrame=(null);targetFrame=<WKFrameInfo: 0x7fe8aaf28050;isMainFrame=YES;request=<NSMutableURLRequest: 0x7fe8ad05ecc0>{
         URL: (null)
         }>>
         */
        
        /**
         使用 webView.loadHTMLString(htmlString, baseURL: nil)加载时
         
         <WKNavigationAction: 0x7fb1b0e30de0;navigationType=-1;request=<NSMutableURLRequest: 0x7fb1b0cbc010>{
         URL: about: blank
         };sourceFrame=(null);targetFrame=<WKFrameInfo: 0x7fb1b0e33840;isMainFrame=YES;request=<NSMutableURLRequest: 0x7fb1b3008530>{
         URL: (null)
         }>>
         */
        decisionHandler(.Allow)
    }
    
    // 2.1 接收到服务器跳转请求之后调用,服务器重定向请求触发
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    // 3.1 在收到响应后，决定是否跳转
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        decisionHandler(.Allow)
    }
    
    //加载网页数据出错时触发
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(#function)
        /**
         (lldb) po error
         Domain=NSURLErrorDomainCode=-1001"The request timed out."UserInfo={
         _WKRecoveryAttempterErrorKey=<WKReloadFrameErrorRecoveryAttempter: 0x7fe8aacab090>,
         NSErrorFailingURLStringKey=http: //www.baidu.com/,
         NSErrorFailingURLKey=http: //www.baidu.com/,
         NSUnderlyingError=0x7fe8ad045ce0{
         ErrorDomain=kCFErrorDomainCFNetworkCode=-1001"The request timed out."UserInfo={
         NSErrorFailingURLStringKey=http: //www.baidu.com/,
         _kCFStreamErrorDomainKey=4,
         _kCFStreamErrorCodeKey=-2102,
         NSErrorFailingURLKey=http: //www.baidu.com/,
         NSLocalizedDescription=Therequesttimedout.
         }
         },
         NSLocalizedDescription=Therequesttimedout.
         }
         */
        
    }
    
    // 2.2
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        print(#function)
        completionHandler(.PerformDefaultHandling, nil)
    }
}

extension WKWebViewDemo: WKScriptMessageHandler {
    /**
     *  当收到网页的传递的信息时触发（Invoked when a script message is received from a webpage）
     *
     *  @param userContentController userContentController，WKUserContentController object为 JavaScript提供了一种方式发送消息到WKWebView
     *  @param message               message 网页那边传来的消息，就是一个对象
     */
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print(#function)
        print(message.name)
        print(message.body.description)
        // 打印所传过来的函数名和参数，
        
        
        /*
         反射出对象并执行指定函数
         
         我们使用得到的 className 和 functionName 反射出指定的对象，并执行指定函数：
         */
        if let dic = message.body as? NSDictionary,
            className = dic["className"]?.description,
            functionName = dic["functionName"]?.description {
            if let cls = NSClassFromString(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")!.description + "." + className) as? NSObject.Type{
                let obj = cls.init()
                let functionSelector = Selector(functionName)
                if obj.respondsToSelector(functionSelector) {
                    obj.performSelector(functionSelector)
                } else {
                    print("方法未找到！")
                }
            } else {
                print("类未找到！")
            }
        }
    }
}

extension WKWebViewDemo: WKUIDelegate {
    /**
     *  创建一个新的WKWebView。需要注意的是之前的UIWebView只有一个一个页面，所有的url都是在这个页面上打开的，但是WKWebView不是这样的，当用户需要打开新的页面时，就会调用以下的这个代理方法。
     *
     *  @param webView          webView
     *  @param configuration    用于配置新建的WKWebView
     *  @param navigationAction navigationAction 创建新的web的navigationAction，这个对象中包含两个属性：sourceFrame和targetFrame，分别代表这个action的出处和目标。类型是 WKFrameInfo 。WKFrameInfo，包含一个网页的框架信息，WKFrameInfo有一个 mainFrame 的属性（Bool类型），正是这个属性标记着这个frame是在主frame里还是新开一个frame。如果 targetFrame 的 mainFrame 属性为NO，表明这个 WKNavigationAction 将会新开一个页面，调用以下方法。一般是因为网页中有_blank，即在新窗口显示目标网页。
     *  @param windowFeatures   windowFeatures 当一个新的WKWebView请求时，为包含的window指定一些可选的特性
     *
     *  @return 返回新创建的WKWebView
     */
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print(#function)
        
        //        if let framInfo = navigationAction.targetFrame {
        //            //以下做法就是判断是不是MainFrame，如果不是的话 也强制使用当前的webview来打开，不创建新的WKWebView实例。
        //            if framInfo.mainFrame {
        //                webView.loadRequest(navigationAction.request)
        //            }
        //        }
        
        //强制使用当前的webview来打开
        webView.loadRequest(navigationAction.request)
        return nil
    }
    
    //通知app DOM window object's的close()方法已经成功的调用完成
    func webViewDidClose(webView: WKWebView) {
        print(#function)
    }
    
    //剩下三个代理方法全都是与界面弹出提示框相关的，针对于web界面的三种提示框（警告框、确认框、输入框）分别对应三种代理方法。
    /**
     *  web界面中有弹出警告框时调用
     *
     *  @param webView           实现该代理的webview
     *  @param message           警告框中的内容
     *  @param frame             主窗口
     *  @param completionHandler 警告框消失调用
     */
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        print(#function)
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) in
            completionHandler()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //显示js的确认框的时候触发
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        print(#function)
        let alert = UIAlertController(title: "confirm", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: { (action) in
            completionHandler(false)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //显示js的输入框的时候触发
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        print(#function)
        let alert = UIAlertController(title: "textInput", message: prompt, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.textColor = UIColor.redColor()
        }
        alert.addAction(UIAlertAction(title: "ok", style: .Default, handler: { (action) in
            completionHandler(alert.textFields?.last?.text)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
}




















