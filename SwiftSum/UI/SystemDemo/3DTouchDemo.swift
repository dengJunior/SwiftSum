//
//  3DTouchDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/12.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ThreeDTouchDemo: UIViewController {
    
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
extension ThreeDTouchDemo {
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


// MARK: - Delegate
extension ThreeDTouchDemo: UITableViewDelegate, UITableViewDataSource {
    
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
        
        // 检测3D Touch可用性
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == .Available {
                self.registerForPreviewingWithDelegate(self, sourceView: cell)
            }
        } 
        
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

extension ThreeDTouchDemo: UIViewControllerPreviewingDelegate {
    /**
     *previewingContext:被预览的视图控制器的内容对象
     *location：源视图的左边系上的触摸点的坐标位置
     *调用时间：进入peek预览阶段时会调用这个方法。
     *作用：返回一个配置好的以供预览的视图控制器。
     *需要的操作：把源视图坐标系上的点转换为当前控制器的视图上的点。
     *返回一个控制器。
     */
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        print(#function)
        return self
    }
    
    /**
     *previewingContext：被预览的视图控制器的内容对象 == 上面代理方法中的previewingContext，内存中是同一个对象
     *viewControllerToCommit：被present（pop）的视图控制器 == 上面代理方法中返回的控制器，内存中是同一个对象
     *调用时间：pop阶段调用这个方法
     *作用：配置并且present一个commit（pop）视图控制器。
     */
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        print(#function)
    }
    
    //另外，如果希望实现peek Quick Actions功能需要在被peek的控制器内实现以下方法，在此例中，也就是需要在WSTableViewController中实现这个方法。
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let like = UIPreviewAction(title: "喜欢", style: .Default) { (previewAction, viewController) in
            print("点击了喜欢")
        }
        let comment = UIPreviewAction(title: "评论", style: .Default) { (previewAction, viewController) in
            print("点击了评论")
        }
        let complaint = UIPreviewAction(title: "投诉", style: .Default) { (previewAction, viewController) in
            print("点击了投诉")
        }
        
        return [like,comment,complaint];
    }
    
    //调用时间：当该系统界面环境发生变化的时候会调用代理方法 - traitCollectionDidChange:
    
    /**
     UITraitEnvironment是声明在UIKit框架中的一个协议，继承自NSObject协议，起始于iOS8.0。界面环境包括水平和垂直方向的size class、呈现比例、以及用户界面语言(见文章末尾)。可以通过UITraitEnvironment协议来使用UITraitEnvironment。也就是说，iPhone和iPad设备的横屏和竖屏状态、缩放比例等都是界面环境。采用了UITraitEnvironment协议的类有：UIScreen、UIWindow、UIViewController、UIPresentationController和UIView。
     
     一个采用了UITraitEnvironment协议的对象通过使用traitCollection属性来访问环境特征。同时这个协议也提供了一个可以重写的方法，当界面环境发生改变时以供系统调用。这个方法就是我们上面所说的 - (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection。实现这个方法可以提高iOS app的自适应性。
     */
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        print(#function)
    }
}







