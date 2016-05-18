//
//  ExtensionDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - “错误”的使用 Swift 中的 Extension

//大量使用 extension 的主要目的是为了提高代码可读性。

// MARK: - 1. 私有的辅助函数

//在 Objective-C 中，我们有 .h 文件和 .m 文件。同时管理这两个文件（以及在工程中有双倍的文件）是一件很麻烦的事情，好在我们只要快速浏览 .h 文件就可以知道这个类对外暴露的 API，而内部的信息则被保存在 .m 文件中。在 Swift 中，我们只有一个文件。

//为了一眼就看出一个 Swift 类的公开方法（可以被外部访问的方法），我把内部实现都写在一个私有的 extension 中，比如这样：

// 这样可以一眼看出来，这个结构体中，那些部分可以被外部调用
public struct TodoItemModel {
    let name: String
    let id: String
    let indexPath: NSIndexPath
    
    var attributedText: NSAttributedString {
        return itemContent
    }
}

// 把所有内部逻辑和外部访问的 API 区隔开来
// MARK: - 私有的属性和方法
private extension TodoItemModel {
    var itemContent: NSAttributedString {
        let text = NSMutableAttributedString(string: "xxx", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(16)])
        return text
    }
    //假设属性字符串的计算逻辑非常复杂。如果把它写在结构体的主体部分中，我就无法一眼看出这个结构体中哪个部分是重要的（也就是 Objective-C 中写在 .h 文件中的代码）。在这个例子中，使用 extension 使我的代码结构变得更加清晰整洁。
    
    //这样一个很长的 extension 也为日后重构代码打下了良好的基础。
}

// MARK: - 2. 分组
//我最初开始使用 extension 的真正原因是在 Swift 刚诞生时，无法使用 pragma 标记（译注：Objective-C 中的 #pragma mark）。是的，这就是我在 Swift 刚诞生时想做的第一件事。我使用 pragma 来分割 Objective-C 代码，所以当我开始写 Swift 代码时，我需要它。

//所以我在 WWDC Swift 实验室时询问苹果工程师如何在 Swift 中使用 pragma 标记。和我交流的那位工程师建议我使用 extension 来替代 pragma 标记。于是我就开始这么做了，并且立刻爱上了使用 extension。

//用一个 extension 存放 ViewController 或者 AppDelegate 中所有初始化 UI 的函数，比如：
private extension AppDelegate {
    
    func configureAppStyling() {
        styleNavigationBar()
        styleBarButtons()
    }
    
    func styleNavigationBar() {
//        UINavigationBar.appearance().barTintColor = ColorPalette.ThemeColor
//        UINavigationBar.appearance().tintColor = ColorPalette.TintColor
//        
//        UINavigationBar.appearance().titleTextAttributes = [
//            NSFontAttributeName : SmoresFont.boldFontOfSize(19.0),
//            NSForegroundColorAttributeName : UIColor.blackColor()
//        ]
    }
    
    func styleBarButtons() {
//        let barButtonTextAttributes = [
//            NSFontAttributeName : SmoresFont.regularFontOfSize(17.0),
//            NSForegroundColorAttributeName : ColorPalette.TintColor
//        ]
//        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTextAttributes, forState: .Normal)
    }
}

// MARK: - 3. 遵守协议
//这是一种特殊的分组，我会把所有用来实现某个协议的方法放到一个 extension 中。在 Objective-C 中，我习惯使用 pragma 标记。不过我喜欢 extension 更加彻底的分割和更好的可读性：

// MARK: - 4. 模型（Model）
//这是一种我在使用 Objective-C 操作 Core Data 时就喜欢采用的方法。由于模型发生变化时，Xcode 会生成相应的模型，所以函数和其他的东西都是写在 extension 或者 category 里面的。

//在 Swift 中，我尽可能多的尝试使用结构体，但我依然喜欢使用 extension 将 Model 的属性和基于属性的计算分割开来。这使 Model 的代码更容易阅读

class ExtensionDemo: UIViewController {
    
    // MARK: - Const

    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    var dataArray = []
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.CellIdentifier)
        return tableView
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
        self.title = "商品详情"
        self.view.addSubview(tableView)
        tableView.addConstraintFillSuperView()
    }
    
    // MARK: - Network
    
    func requestData() {
        requestData(false)
    }
    
    func requestData(append: Bool) {
        dataArray = ["test1", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2",]
        renderUI()
    }
    
    // MARK: - Private
    
    func renderUI() {
        tableView.reloadData()
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
}

// MARK: - Life cycle
extension ExtensionDemo {
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
extension ExtensionDemo {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

// MARK: - Delegate
extension ExtensionDemo: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row] as? String
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}



























