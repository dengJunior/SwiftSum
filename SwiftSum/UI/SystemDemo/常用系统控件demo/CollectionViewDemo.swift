//
//  CollectionViewDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class CollectionViewDemo: UIViewController {
    
    // MARK: - Const
    
    let CellIdentifier = "CollectionTextCell"
    
    // MARK: - Property
    
    var dataArray = []
    
    var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        flowLayout.itemSize = CGSizeMake(140, 100)
        flowLayout.headerReferenceSize = CGSize(width: 200, height: 100)
        flowLayout.footerReferenceSize = CGSize(width: 200, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return flowLayout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: CollectionTextCell.classNameString, bundle: nil), forCellWithReuseIdentifier: CollectionTextCell.classNameString)
        return collectionView
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
        self.view.addSubview(collectionView)
        collectionView.addConstraintFillSuperView()
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
        collectionView.reloadData()
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    
}

// MARK: - Life cycle
extension CollectionViewDemo {
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
extension CollectionViewDemo {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

// MARK: - Delegate
extension CollectionViewDemo: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let text = dataArray[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! CollectionTextCell
        cell.rederWithMode(text, indexPath: indexPath, containerView: nil)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    //长事件轻触手势时，collection view尝试给那个单元格显示一个编辑按钮
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        print(action)
    }
}



