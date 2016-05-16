//
//  GoodsViewController3.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/15.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 仿淘宝商品详情交互 使用 容器Vc
class GoodsViewController3: UIViewController {
    
    // MARK: - Const
    
    var show = false
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    lazy var goodsDetailViewController: GoodsDetailViewController = {
        let viewController = GoodsDetailViewController()
        viewController.delegate = self
        return viewController
    }()
    
    var goodsDetailGraphicViewController: GoodsDetailGraphicViewController!
    
    var isAnimating: Bool = false
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
    
    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        title = "商品详情"
//        addChildViewControllerWithFillViewConstraint(goodsDetailViewController)
        addChildViewControllerWithView(goodsDetailViewController)
    }
    
    func addGoodsDetailGraphicViewController() {
        let viewController = GoodsDetailGraphicViewController()
        viewController.delegate = self
        goodsDetailGraphicViewController = viewController
        addChildViewControllerWithView(goodsDetailGraphicViewController)
        goodsDetailGraphicViewController.view.frame = frameDown
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
        
        isAnimating = true
        self.transitionFromViewController(goodsDetailGraphicViewController, toViewController: goodsDetailViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.goodsDetailViewController.view.frame = self.frameVisible
            self.goodsDetailGraphicViewController.view.frame = self.frameDown
        }) { (_) in
            self.goodsDetailGraphicViewController.view.frame = self.frameDown
            self.view.addSubview(self.goodsDetailGraphicViewController.view)
            self.isAnimating = false
        }
    }
    
    func showGoodsGrapicController() {
        if goodsDetailGraphicViewController == nil {
            addGoodsDetailGraphicViewController()
        }
        
        isAnimating = true
        self.transitionFromViewController(goodsDetailViewController, toViewController: goodsDetailGraphicViewController, duration: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.goodsDetailViewController.view.frame = self.frameUp
            self.goodsDetailGraphicViewController.view.frame = self.frameVisible
            }) { (_) in
                self.goodsDetailViewController.view.frame = self.frameUp
                self.view.addSubview(self.goodsDetailViewController.view)
                self.isAnimating = false
        }
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
}

// MARK: - GoodsDetailViewControllerDelegate, GoodsDetailGraphicViewControllerDelegate

extension GoodsViewController3: GoodsDetailViewControllerDelegate, GoodsDetailGraphicViewControllerDelegate {
    
    var frameVisible: CGRect { return self.view.bounds }
    var frameUp: CGRect { return CGRectOffset(view.bounds, 0, -view.bounds.size.height) }
    var frameDown: CGRect { return CGRectOffset(view.bounds, 0, view.bounds.size.height) }
    
    func updateGoodsDetailGraphicViewWithOffset(offset: CGFloat) {
        if goodsDetailGraphicViewController != nil && !isAnimating {
            goodsDetailGraphicViewController.view.frame = CGRectOffset(frameDown, 0, -offset)
        }
    }
    
    func goodsDetailViewControllerDidBeginDragOver(controller: GoodsDetailViewController) {
        
    }
    func goodsDetailViewController(controller: GoodsDetailViewController, didDragOver offset: CGFloat) {
        updateGoodsDetailGraphicViewWithOffset(offset)
    }
    func goodsDetailViewControllerDidEndDragOver(controller: GoodsDetailViewController) {
    }
    
    func goodsDetailViewController(controller: GoodsDetailViewController, didTriggerEnent eventType: GoodsDetailPullEventType) {
        switch eventType {
        case .pullUp:
            showGoodsGrapicController()
        case .pullLeft:
            break
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