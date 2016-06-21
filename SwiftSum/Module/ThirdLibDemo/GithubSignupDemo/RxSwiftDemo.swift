//
//  RxSwiftDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/2/27.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - GitHub 注册账号的例子。输入用户名、密码、重复密码，然后提交注册。

/*
在注册流程中，用户名校验是一个很常见的功能。我们一般需要对用户名做如下检查和流程：

- 是否不为空
- 是否不包含非法字符
- 是否没有被注册过
- 以上均通过，联网注册
- 是否成功连接上服务器
- 服务器是否正确处理并返回结果
要通过 RxSwift 实现以上流程，可以划分成如下几步。
*/


class RxSwiftDemo: UIViewController {
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!
    
    
    @IBAction func confirm(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        // Do any additional setup after loading the view.
        //        self.bindValidationResultToUI()
        self.bindViewModel()
    }
    
    
    // MARK: - 1- rx_text
    /*
    rx_text
    
    如果想监听文字输入，我们最好能有一个 Observable 的对象不断地给我们发送新的输入值。
    rx_text 是 RxSwift 针对 Cocoa 库做的各种封装中的一个
    */
    
    var disposeBag = DisposeBag()
    
    func bindViewModel() {
        let viewModel = GithubSignupViewModel(
            input: (
                username: usernameOutlet.rx_text.asObservable(),
                password: passwordOutlet.rx_text.asObservable(),
                repeatedPassword: repeatedPasswordOutlet.rx_text.asObservable(),
                loginTap: signupOutlet.rx_tap.asObservable()),
            dependency: (
                API: GitHubDefaultAPI.sharedInstance,
                validationService: GitHubDefaultValidationService.sharedInstance,
                wireframe: DefaultWireframe.sharedInstance))
        
        viewModel.signupEnabled
            .subscribeNext { [weak self] valid in
                self?.signupOutlet.enabled = valid
                self?.signupOutlet.alpha = valid ? 1.0 : 0.5
            }
            .addDisposableTo(disposeBag)
        
        viewModel.validatedUsername
        .bindTo(usernameValidationOutlet.ex_validationResult)
        .addDisposableTo(disposeBag)
        
        viewModel.validatedPassword
            .bindTo(passwordValidationOutlet.ex_validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.validatedPasswordRepeated
            .bindTo(repeatedPasswordValidationOutlet.ex_validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.signedIn
            .subscribeNext { signedIn in
                print("User signed in \(signedIn)")
        }
        .addDisposableTo(disposeBag)
        
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(RxSwiftDemo.dismissKeyboard(_:)))
        view.addGestureRecognizer(tapBackground)
    }
    
    func dismissKeyboard(gr: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func bindValidationResultToUI() {
        //        usernameOutlet.rx_text
        //            .map {
        //                $0.characters.count > 0
        //            }
        //            .bindTo(self.signupOutlet.rx_enabled)
        //            .addDisposableTo(disposeBag)
        
        //        let validateUsername = usernameOutlet.rx_text.flatMapLatest { username in
        //            return GitHubDefaultValidationService.sharedInstance.validateUsername(username)
        //        }
        let validateUsername = usernameOutlet.rx_text.map { username in
            return GitHubDefaultValidationService.sharedInstance.validatePassword(username)
        }
        
        let validatePassword = passwordOutlet.rx_text.map { password in
            return GitHubDefaultValidationService.sharedInstance.validatePassword(password)
        }
        
        let validatedPasswordRepeated = Observable.combineLatest(passwordOutlet.rx_text, repeatedPasswordOutlet.rx_text) { password, repeatPassword in
            GitHubDefaultValidationService.sharedInstance.validateRepeatedPassword(password, repeatedPassword: repeatPassword)
        }
        
        let signupEnable = Observable.combineLatest(validateUsername, validatePassword, validatedPasswordRepeated) { username, password, repeatPassword in
            username.isValid && password.isValid && repeatPassword.isValid
            }.distinctUntilChanged();
        
        signupEnable.subscribeNext { [weak self] valid in
            self?.signupOutlet.enabled = valid
            self?.signupOutlet.alpha = valid ? 1.0 : 0.5
            }.addDisposableTo(disposeBag)
        
    }
    
    func showAlert(text: String) {
        let alertView = UIAlertView(
            title: "error",
            message: text,
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        
        alertView.show()
    }
}






















