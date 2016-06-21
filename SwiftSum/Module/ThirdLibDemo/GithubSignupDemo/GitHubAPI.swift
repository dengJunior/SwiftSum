//
//  GitHubAPI.swift
//  SwiftSum
//
//  Created by sihuan on 16/2/28.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

extension String {
    var URLEscaped: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) ?? ""
    }
}

protocol GitHubAPI {
    func usernameAvailable(username: String) -> Observable<Bool>
    func signup(username: String, password: String) -> Observable<Bool>
}

protocol GitHubValidationService {
    func validateUsername(username: String) -> Observable<ValidationResult>
    func validatePassword(password: String) -> ValidationResult
    func validateRepeatedPassword(password: String, repeatedPassword: String) -> ValidationResult
}


class GitHubDefaultAPI : GitHubAPI {
    let URLSession: NSURLSession
    
    static let sharedInstance = GitHubDefaultAPI(URLSession: NSURLSession.sharedSession())
    
    init(URLSession: NSURLSession) {
        self.URLSession = URLSession
    }
    
    /**
     注册功能只是一个 mock 而已，并没有真的访问 API ：
     
     在这里可以看到 never() 的正确打开方式：用于无限等待。
     concat 将上面两个序列首尾拼接起来，
     然后 throttle 等价于 debounce ：如果两个事件的时间间隔小于某个特定值，就会忽视掉前面一个。
     通过 never + throttle 伪造了一种等待加载2秒然后返回注册结果的错觉。
     */
    func signup(username: String, password: String) -> Observable<Bool> {
        let sigupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(sigupResult)
            .concat(Observable.never())
            .throttle(1.4, scheduler: MainScheduler.instance)
            .take(1)
    }
    
    /**
     检测用户名是否可用主要是访问用户名对应的 github 地址然后查看是否是 404 ，如果不是那就说明已经被注册了。
     rx_response 是针对 NSURLSession 的扩展。
     通过 observeOn 将监听事件绑定在了 dataScheduler 上。
     最后 catchErrorJustReturn(false) 表明如果出现异常就返回个 false 。
     */
    func usernameAvailable(username: String) -> Observable<Bool> {
        let URL = NSURL(string: "https://github.com/\(username.URLEscaped)")!
        let request = NSURLRequest(URL: URL)
        return self.URLSession.rx_response(request)
            .map{ (maybeData, response) in
                return response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
}

class GitHubDefaultValidationService: GitHubValidationService {
    let API: GitHubAPI
    
    static let sharedInstance = GitHubDefaultValidationService(API: GitHubDefaultAPI.sharedInstance)
    
    init (API: GitHubAPI) {
        self.API = API
    }
    
    let minPasswordCount = 5
    
    // MARK: - 2-validate
    /**
    *  validate
    
    接下来就是验证用户名的阶段了。首先需要一个方法，将用户名转换成一串流。
    为什么是流？为了统一口径，如下：
    
    - 如果用户名为空，返回 (false, nil) 完事儿
    - 如果用户名有非法字符，返回 (false, "Username can only contain numbers or digits") 完事儿
    - 如果本地检查没问题，发给服务器检查，先发送一个事件 loadingValue 表示正在加载，加载成功再发送结果事件
    
    这就是我所理解的『统一口径』。虽然本地检查分分钟就能给你个结果，但是如果统一都用『流』来表述，外部处理起来会简单得多。
    不用管具体的结果是什么，只需要知道是一个 Observable 对象，并且随之而来的是一串事件，就足够了。这一串事件，有可能只有一个，提示用户名不能为空；也有可能有很多，先提示正在加载，然后再提示注册成功。在外部来看，这就是一个事件流。
    
    试想一下如果用 UIKit 的那一套来写这个流程，肯定要监听个 valueChanged 事件然后在委托方法里先判断 A ，如果不符合就刷新 UI ；再判断 B ，不符合就刷新 UI ；最后发请求给服务器，刷新 UI 提示等待，然后加载完了再刷新个 UI 。。。
    */
    func validateUsername(username: String) -> Observable<ValidationResult> {
        if username.characters.count == 0 {
            return Observable.just(.Empty)
        }
        
        if username.rangeOfCharacterFromSet(NSCharacterSet.alphanumericCharacterSet().invertedSet) != nil {
            return Observable.just(ValidationResult.Failed(message: "Username can only contain numbers or digits"))
        }
        
        let loadingValue = ValidationResult.Validating
        
        return API
            .usernameAvailable(username)
            .map { available in
                if available {
                    return ValidationResult.OK(message: "Username available")
                } else {
                    return ValidationResult.Failed(message: "Username already taken")
                }
            }
            .startWith(loadingValue)
    }
    
    func validatePassword(password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return .Empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .Failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .OK(message: "Password acceptable")
    }
    
    func validateRepeatedPassword(password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.characters.count == 0 {
            return ValidationResult.Empty
        }
        
        if repeatedPassword == password {
            return .OK(message: "Password repeated")
        }
        else {
            return .Failed(message: "Password different")
        }
    }
}


























