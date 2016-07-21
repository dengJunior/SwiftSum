//
//  iOS7Feature.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import AdSupport
import AVFoundation
import MediaPlayer
import CoreTelephony

// MARK: - ## iOS7新特性

class iOS7Feature: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        network()
        self.addButtonToView(title: "app说话") { [unowned self] (button) in
            self.speak()
        }
        textViewLinkDemo()
    }

    func features() {
        // MARK: - ### 一、已禁用-[UIDevice uniqueIdentifier]
        //生成iOS设备唯一标示符的方法，-[UIDevice uniqueIdentifier]在iOS5实际在iOS5的时候已经被遗弃了，但是iOS7中已经完全的禁用了它。Xcode5甚至不会允许你编译包含了指引到-[UIDevice uniqueIdentifier]的app。
        
        // MARK: - ### 二、UIPasteboard由共享变为沙盒化了
        //UIPasteboard过去是用来做app之间的数据分享的。UIPasteboard本无问题，但是开发者开始使用它来存储标识符，和其他的相关app分享这些标识符的时候问题就出现了。
        
        // MARK: - ### 三、MAC地址不能再用来设别设备
        //还有一个生成iOS设备唯一标示符的方法是使用iOS设备的Media Access Control（MAC）地址。
        //苹果并不希望有人通过MAC地址来分辨用户，所以如果你在iOS7系统上查询MAC地址，它现在只会返回02:00:00:00:00:00。
        
        //identifierForVendor对供应商来说是唯一的一个值，也就是说，由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。<mark>然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致。
        _ = UIDevice.currentDevice().identifierForVendor?.UUIDString
        
        //advertisingIdentifier会返回给在这个设备上所有软件供应商相同的一个值，所以只能在广告的时候使用。这个值会因为很多情况而有所变化，比如说用户初始化设备的时候便会改变。 需导入import AdSupport
        let identifierForAdvertising = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        
        // MARK: - ### 四、iOS现在要求app如需使用麦克风，需要征得用户同意
        
        //第一次调用这个方法的时候，系统会提示用户让他同意你的app获取麦克风的数据
        // 其他时候调用方法的时候，则不会提醒用户
        // 而会传递之前的值来要求用户同意
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                // 用户同意获取数据
            } else {
                // 可以显示一个提示框告诉用户这个app没有得到允许？
            }
            //如果你在获得用户的同意之前使用任何方法来使用麦克风的话，会引起iOS系统弹出警示栏
        }
        
        // MARK: - ### 五、[NSArray firstObject]的实现
        
        // MARK: - ### 六、增加了instancetype
        
        // MARK: - ### 七、设置UIImage的渲染模式：UIImage.renderingMode
        
        /*
         UIImage新增了一个只读属性：renderingMode，对应的还有一个新增方法：imageWithRenderingMode:，
         它使用UIImageRenderingMode枚举值来设置图片的renderingMode属性。该枚举中包含下列值：
         
         // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式
         UIImageRenderingModeAutomatic
         
         // 始终绘制图片原始状态，不使用Tint Color
         UIImageRenderingModeAlwaysOriginal
         
         // 始终根据Tint Color绘制图片，忽略图片的颜色信息
         UIImageRenderingModeAlwaysTemplate
         
         renderingMode属性的默认值是UIImageRenderingModeAutomatic，即UIImage是否使用Tint Color取决于它显示的位置。
         */
        var image = UIImage()
        image = image.imageWithRenderingMode(.Automatic)
        
        // MARK: - ### 八、tintcolor VS barTintColor
        //iOS7中你可以使用一个给定的颜色，甚至是记入颜色主题来给整个app着色,UINaviagtionBar，UISearchBar，UITabBar以及UIToolbar已经有了这么命名的属性。他们现在有了一个新的属性：barTintColor。
        let navBar = self.navigationController?.navigationBar
        if #available(iOS 7, *) {
            navBar?.barTintColor = UIColor.greenColor()
        } else {
            navBar?.tintColor = UIColor.greenColor()
        }
        
        // MARK: - ### 九、去掉了纹理颜色
        //纹理颜色？对，不再使用他们了，不能再创建可以展现纹理的颜色。
        UIColor.groupTableViewBackgroundColor()//不像之前那样返回纹理颜色了
        
        // MARK: - ### 十、UIButtonTypeRoundRect被UIButtonTypeSystem取代了
        
        
        // MARK: - ### 十一、检查无线路由是否可用
        //定制一个视频播放器的能力在iOS版本每次的发布中一直有所进步。比如说，在iOS6之前，你不能在MPVolumeView中改变AirPlay的icon。
        //在iOS7当中，你可以通过AirPlay，蓝牙或是其他的虚线机制了解是否有一个远程的设备可用。了解它的话，就可以让你的app在恰当的时候做恰当的事，比如说，在没有远程设备的时候就不显示AirPlay的icon。
        //以下是新增加到MPVolumeView的新属性和推送
        /**
         @property (nonatomic, readonly) BOOL wirelessRoutesAvailable; //  是否有设备可以连接的无线线路？
         @property (nonatomic, readonly) BOOL wirelessRouteActive; // 设备现在是否连接上了网络
         NSString *const MPVolumeViewWirelessRoutesAvailableDidChangeNotification;
         NSString *const MPVolumeViewWirelessRouteActiveDidChangeNotification;
         */
        
        let mpView =  MPVolumeView()
        mpView.wirelessRoutesAvailable
        mpView.wirelessRouteActive
    }
    
    // MARK: - ### 十二、了解蜂窝网络
    var networkInfo = CTTelephonyNetworkInfo()
    func network() {
        //在iOS7之前，是使用Reachability来检测设备是否连接到WWAN或是Wifi的。
        //iOS7在这个基础上更进了一步，它会告诉你的设备连接上的是那种蜂窝网络，比如说是Edge网络，HSDPA网络，或是LTE网络。告诉用户他们连接上的是哪种网络可以优化用户体验，因为这样他们会知道网速如何，不会去请求需要高网速的网络请求。
        print("Initial cell connection: \(networkInfo.currentRadioAccessTechnology)")
        //如果设备没有连上的话，currentRadioAccessTechnology 则会返回nil。
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(radioAccessChanged), name: CTRadioAccessTechnologyDidChangeNotification, object: nil)
    }
    
    func radioAccessChanged() {
        print("Now you're connected via: \(networkInfo.currentRadioAccessTechnology)")
    }
    
    // MARK: - ### 十三、通过iCloud同步用户设备的密码
    //iOS7以及Mavericks增加了iCloud Keychain来提供密码，以及iCloud中一些敏感数据的同步。开发者可以通过keychain中的kSecAttrSynchronizable key来遍历dictionary对象。
    
    //由于直接处理keychain比较难，封装库提供了一个简单的处理keychain的方法。SSKeychain封装库可能是最有名的的一个，作为一种福利，现在它支持在iCloud同步。
    //以下代码片段显示了如何使用SSKeychain：
    func save() {
    }
    
    
    // MARK: - ### 十四、使用NSAttributedString显示HTML
    
    /**
     你可以从用少量代码在HTML文件中创建一个NSAttributedString，比如：
     */
    func attribute() {
        let html = "<bold>Wow!</bold> Now <em>iOS</em> can create <h3>NSAttributedString</h3> from HTMLs!"
        //>注意：NSHTMLTextDocumentType 只是NSDocumentTypeDocumentAttribute key一种可能的值。你还可以使用NSPlainTextDocumentType，NSRTFTextDocumentType或是NSRTFDTextDocumentType。
        let options = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        let attrString = try? NSAttributedString(data: html.toNSData()!, options: options, documentAttributes: nil)
        
        //你还可以从NSAttributedString中创建一个HTML字符串，如下：
        if attrString {
            let htmlData = try? attrString!.dataFromRange(NSRange(location: 0, length: attrString!.length), documentAttributes: options)
            let htmlString = String(data: htmlData!, encoding: NSUTF8StringEncoding)
            if htmlString {
                
            }
        }
    }
    
    // MARK: - ### 十五、使用原生的Base64
    
    // MARK: - ### 十六、使用UIApplicationUserDidTakeScreenshotNotification来检查截图
    //iOS7提供一个崭新的推送方法：UIApplicationUserDidTakeScreenshotNotification。只要像往常一样订阅即可知道什么时候截图了。
    
    // MARK: - ### 十七、实现多语言语音合成
    /**
     如果可以让app说话会不会很好呢？iOS7加入了两个新类：AVSpeechSynthesizer 以及AVSpeechUtterance。这两个类可以给你的app发声。很有意思不是吗？有多种语言可供选择——Siri不会说的语言也有，比如说巴西葡萄牙语。
     
     使用这两个类给app提供语言合成的功能非常简单。
     
     - AVSpeechUtterance 代表你想说什么，如何说。
     - AVSpeechSynthesizer 用来发出这些声音，见以下代码片段：
     */
    let synthesizer = AVSpeechSynthesizer()
    func speak() {
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            do{
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
                
            }
        }catch{
            
        }
        
        let utterance = AVSpeechUtterance(string: "哈哈")
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
        // defaults to your system language
        //utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speakUtterance(utterance)
    }
    
    // MARK: - ### 十八、使用了新的UIScreenEdgePanGestureRecognizer
    
    // MARK: - ### 十九、使用UIScrollViewKeyboardDismissMode实现了Message app的行为
    
    // MARK: - ### 二十、使用Core Image来检测眨眼以及微笑
    
    
}

extension iOS7Feature: UITextViewDelegate {
    // MARK: - ### 二十一、给UITextView增加了链接
    func textViewLinkDemo() {
        //1. 首先，创建一个NSAttributedString然后增加给它增加一个NSLinkAttributeName 属性
        let attributedString = NSMutableAttributedString(string: "This is an example by @marcelofabri_")
        let range = (attributedString.string as NSString).rangeOfString("@marcelofabri_")
        attributedString.addAttribute(NSLinkAttributeName, value: "username://marcelofabri_", range: range)
        
        let linkAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.orangeColor(),
            NSUnderlineColorAttributeName: UIColor.lightGrayColor(),
            NSUnderlineStyleAttributeName: NSNumber(long: NSUnderlineStyle.PatternSolid.rawValue)
        ]
        
        let textView = UITextView(frame: CGRect(x: 20, y: 200, width: 200, height: 80))
        textView.linkTextAttributes = linkAttributes
        textView.attributedText = attributedString
        textView.delegate = self
        self.view.addSubview(textView)
    }
    
    //控制当链接被点击的时候会发生什么
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if URL.scheme == "username" {
            let username = URL.host
            print(username)
            return false
        }
        return true // let the system open this URL
    }
}


















