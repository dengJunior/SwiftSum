//
//  GoodsDetailController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

protocol GoodsDetailViewControllerDelegate: NSObjectProtocol {
    func goodsDetailViewController(controller: GoodsDetailViewController, didTriggerEnent eventType:GoodsDetailPullEventType)
    
    func goodsDetailViewControllerDidBeginDragOver(controller: GoodsDetailViewController)
    func goodsDetailViewController(controller: GoodsDetailViewController, didDragOver offset:CGFloat)
    func goodsDetailViewControllerDidEndDragOver(controller: GoodsDetailViewController)
}

class GoodsDetailViewController: UIViewController {

    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    var scrollBegin = false
    weak var delegate: GoodsDetailViewControllerDelegate?
    var dataArray = []
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.clearExtraCellLine()
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
    
    // MARK: - Override
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Initialization
    
    func setupContext() {
        setupUI()
        requestData()
    }
    
    func setupUI() {
        self.title = "商品详情"
        self.extendedLayoutNone()
        self.view.addSubview(tableView)
        tableView.addConstraintFillParent()
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

extension GoodsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension GoodsDetailViewController: UIScrollViewDelegate {
    func trigerEvent(eventType: GoodsDetailPullEventType) {
        delegate?.goodsDetailViewController(self, didTriggerEnent: eventType)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        delegate?.goodsDetailViewControllerDidBeginDragOver(self)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height)
        if offset == 0 {
//            if !scrollBegin {
//                scrollBegin = true
//                delegate?.goodsDetailViewControllerDidBeginDragOver(self)
//            } else {
//                
//            }
            
        } else if offset > 0 {
            delegate?.goodsDetailViewController(self, didDragOver: offset)
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.goodsDetailViewControllerDidEndDragOver(self)
//        scrollBegin = false
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height + GoodsPullEventTriggerdOffset {
//            trigerEvent(.pullUp)
//        }
    }
}













