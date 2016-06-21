//
//  GithubSignupViewModel.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/4.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation
import RxSwift


class GithubSignupViewModel {
    
    //验证输入
    let validatedUsername: Observable<ValidationResult>
    let validatedPassword: Observable<ValidationResult>
    let validatedPasswordRepeated: Observable<ValidationResult>
    
    // 设置登录按钮enable
    let signupEnabled: Observable<Bool>
    
    // 登录是否成功
    let signedIn: Observable<Bool>
    
    // 正在登录中。。。
//    let signingIn: Observable<Bool>
    
    init(input: (
        username: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>,
        loginTap: Observable<Void>
        ),
        dependency: (
        API: GitHubAPI,
        validationService: GitHubValidationService,
        wireframe: Wireframe
        )
        ) {
            let API = dependency.API;
            let validationService = dependency.validationService;
            let wireframe = dependency.wireframe;
            
            validatedUsername = input.username
                .flatMapLatest { username in
                    /**
                    *  observeOn将监听事件绑定在了 MainScheduler 上。最后 catchErrorJustReturn(ValidationResult.failed) 表明如果出现异常就返回个 faValidationResult.failedlse 。
                    
                    Scheduler 是一种 Rx 里的任务运行机制，类似的 gcd 里的 dispatch queue 。可以通过 observeOn 切换 scheduler ：
                    
                    
                    shareReplay 会返回一个新的事件序列，它监听底层序列的事件，并且通知自己的订阅者们。
                    不过和传统的订阅不同的是，它是通过『重播』的方式通知自己的订阅者。
                    就像是过目不忘的看书，但是每次都只记得最后几行的内容，在有人询问的时候就背诵出来。
                    
                    从上面的例子可以看到，通过 shareReplay 订阅的 map 并不会调用多次。所以我们也可以把它应用到 validateUsername 上
                    *
                    */
                    return validationService.validateUsername(username)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(ValidationResult.Failed(message: "Error contacting server"))
                }
                .shareReplay(1)
            
            validatedPassword = input.password
                .map { password in
                    return validationService.validatePassword(password)
                }
                .shareReplay(1)
            
            validatedPasswordRepeated = Observable.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword).shareReplay(1)
            
            //            let signingIn =
            let usernameAndPassword = Observable.combineLatest(input.username, input.password) { ($0, $1)
            }
            
            signedIn = input.loginTap.withLatestFrom(usernameAndPassword)
                .flatMapLatest { username, password in
                    return API.signup(username, password: password)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(false)
                }
                .flatMapLatest { loggedIn -> Observable<Bool> in
                    let message = loggedIn ? "Mock: Signed in to GitHub." : "Mock: Sign in to GitHub failed"
                    return wireframe.promtFor(message, cancelAction: "OK", actions: [])
                        .map { _ in
                            loggedIn
                    }
                }
                .shareReplay(1)
            
            signupEnabled = Observable.combineLatest(validatedUsername, validatedPassword, validatedPasswordRepeated) {
                    username, password, repeatPassword in
                    username.isValid &&
                    password.isValid &&
                    repeatPassword.isValid
            }
            .distinctUntilChanged()
            .shareReplay(1)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

















