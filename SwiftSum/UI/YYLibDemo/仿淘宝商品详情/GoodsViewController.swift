//
//  GoodsViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public enum GoodsDetailPullEventType {
    case pullUp
    case pullLeft
    case pullDown
}

public let GoodsPullEventTriggerdOffset = CGFloat(80)


// MARK: - 仿淘宝商品详情交互
class GoodsViewController: UIPageViewController {
    
    // MARK: - Const
    
    
    let CellIdentifier = "CellIdentifier"

    // MARK: - Property
    lazy var goodsDetailViewController: GoodsDetailViewController = {
        let viewController = GoodsDetailViewController()
        viewController.delegate = self
        return viewController
    }()
    
    lazy var goodsDetailGraphicViewController: GoodsDetailGraphicViewController = {
        let viewController = GoodsDetailGraphicViewController()
        viewController.delegate = self
        return viewController
    }()
    
    var dataArray = []
    weak var innerScrollView: UIScrollView!
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContext()
    }
    
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
    
    // MARK: - Initialization
    
    init() {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        self.title = "商品详情"
        dataSource = self
        delegate = self
        for subView in self.view.subviews {
            if let scrollView = subView as? UIScrollView {
                innerScrollView = scrollView
            }
        }
        showGoodsController()
    }
    
    // MARK: - Network
    
    func requestData() {
        requestData(false)
    }
    
    func requestData(append: Bool) {
        dataArray = ["test1", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2", "test2",];
    }
    
    // MARK: - Override
    
    
    // MARK: - Private
    
    func showGoodsController() {
        setViewControllers([goodsDetailViewController], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
//        innerScrollView.scrollEnabled = true
    }
    
    func showGoodsGrapicController() {
        setViewControllers([goodsDetailGraphicViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//        innerScrollView.scrollEnabled = false
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
}

// MARK: - GoodsDetailViewControllerDelegate, GoodsDetailGraphicViewControllerDelegate

extension GoodsViewController: GoodsDetailViewControllerDelegate, GoodsDetailGraphicViewControllerDelegate {
    func goodsDetailViewController(controller: GoodsDetailViewController, didTriggerEnent eventType: GoodsDetailPullEventType) {
        switch eventType {
        case .pullUp:
            showGoodsGrapicController()
        case .pullLeft:
            showGoodsController()
        case .pullDown:
            break
        }
    }
    
    func goodsDetailGraphicViewController(controller: GoodsDetailGraphicViewController, didTriggerEnent eventType: GoodsDetailPullEventType) {
        switch eventType {
        case .pullUp:
            showGoodsGrapicController()
        case .pullLeft:
            break
        case .pullDown:
            showGoodsController()
        }
    }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension GoodsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return viewController == goodsDetailGraphicViewController ? goodsDetailViewController : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return viewController == goodsDetailViewController ? goodsDetailGraphicViewController : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            innerScrollView.scrollEnabled = previousViewControllers.first == goodsDetailGraphicViewController ? true : false
        }
    }
}
