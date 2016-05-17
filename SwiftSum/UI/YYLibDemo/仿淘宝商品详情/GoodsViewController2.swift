//
//  GoodsViewController2.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 仿淘宝商品详情交互 使用自定义过度动画
class GoodsViewController2: UIViewController {

    // MARK: - Const
    
    var show = false
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
        viewController.transitioningDelegate = self.percentTransitionDelegate
        return viewController
    }()
    
    lazy var percentTransitionDelegate: YYPercentTransitionDelegate = {
        return YYPercentTransitionDelegate(targetEdge: .Bottom)
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
    
    func setupContext() {
        setupUI()
    }
    
    func setupUI() {
        self.title = "商品详情"
        addChildViewController(goodsDetailViewController, toSubView: true, fillSuperViewConstraint: true)
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
        percentTransitionDelegate.targetEdge = .Top
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    func showGoodsGrapicController() {
        percentTransitionDelegate.targetEdge = .Bottom
        self.presentViewController(goodsDetailGraphicViewController, animated: true) { 
            
        }
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
}

// MARK: - GoodsDetailViewControllerDelegate, GoodsDetailGraphicViewControllerDelegate

extension GoodsViewController2: GoodsDetailViewControllerDelegate, GoodsDetailGraphicViewControllerDelegate {
    
    func goodsDetailViewControllerDidBeginDragOver(controller: GoodsDetailViewController) {
        showGoodsGrapicController()
    }
    func goodsDetailViewController(controller: GoodsDetailViewController, didDragOver offset: CGFloat) {
        percentTransitionDelegate.offset = offset
    }
    func goodsDetailViewControllerDidEndDragOver(controller: GoodsDetailViewController) {
        percentTransitionDelegate.finish()
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