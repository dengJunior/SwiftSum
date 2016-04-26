//
//  GoodsDetailViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/25.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

protocol GoodsDetailGraphicViewControllerDelegate: NSObjectProtocol {
    func goodsDetailGraphicViewController(controller: GoodsDetailGraphicViewController, didTriggerEnent eventType:GoodsDetailPullEventType)
}

class GoodsDetailGraphicViewController: UIViewController {

    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    weak var delegate: GoodsDetailGraphicViewControllerDelegate?
    var dataArray = []
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.clearExtraCellLine()
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
        dataArray = ["test1", "test2", "test2", "test2", ];
        renderUI()
    }
    
    // MARK: - Private
    
    func renderUI() {
        tableView.reloadData()
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
}

extension GoodsDetailGraphicViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.orangeColor()
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

extension GoodsDetailGraphicViewController: UIScrollViewDelegate {
    func trigerEvent(eventType: GoodsDetailPullEventType) {
        delegate?.goodsDetailGraphicViewController(self, didTriggerEnent: eventType)
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if -scrollView.contentOffset.y >=  GoodsPullEventTriggerdOffset {
            trigerEvent(.pullDown)
        }
    }
}
