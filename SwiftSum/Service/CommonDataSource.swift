//
//  CommonDataSource.swift
//  MyLibs
//
//  Created by sihuan on 15/2/1.
//  Copyright (c) 2015年 huan. All rights reserved.
//

// MARK: - 通用的适配器

import UIKit

typealias CellConfigureBlock = (view: AnyObject, item: AnyObject) -> Void

class CommonDataSource: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    
    //添加属性观察器
    var dataArr: NSArray! {
        
        didSet {
            
        }
    }
    var cellIdentifier: String!
    var configureBlock:CellConfigureBlock!
    
    init(dataArr:NSArray, cellIdentifier:String, configureBlock:CellConfigureBlock) {
        self.dataArr = dataArr
        self.cellIdentifier = cellIdentifier
        self.configureBlock = configureBlock
    }
    
    func updateDataArr(arr: NSArray) {
        dataArr = arr
    }
   
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
        cell.tag = indexPath.row
        configureBlock(view: cell, item: dataArr[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) 
        cell.tag = indexPath.item
        configureBlock(view: cell, item: dataArr[indexPath.item])
        return cell
    }
    
}
