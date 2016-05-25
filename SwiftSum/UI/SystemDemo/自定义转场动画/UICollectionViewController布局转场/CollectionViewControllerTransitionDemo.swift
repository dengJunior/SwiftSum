//
//  CollectionViewControllerTransitionDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

/*
 布局转场只针对 CollectionViewController 搭配 NavigationController 的组合，且是作用于布局，而非视图。采用这种布局转场时，NavigationController 将会用布局变化的动画来替代 push 和 pop 的默认动画。苹果自家的照片应用中的「照片」Tab 页面使用了这个技术：在「年度-精选-时刻」几个时间模式间切换时，CollectionViewController 在 push 或 pop 时尽力维持在同一个元素的位置同时进行布局转换。
 
 布局转场的实现比三大主流转场要简单得多，只需要满足四个条件：NavigationController + CollectionViewController, 且要求后者都拥有相同数据源， 并且开启useLayoutToLayoutNavigationTransitions属性为真。
 */

class CollectionViewControllerTransitionDemo: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //作为 root VC 的 cvc0 的该属性必须为 false，该属性默认为 false。
//        self.useLayoutToLayoutNavigationTransitions = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let count = self.navigationController!.viewControllers.count
        self.title = "Level \(count)"
    }

    
    /*
     进行布局转场时，数据源的数量(section 和 cell 数量)要保持一致，尽管你可以在中途修改数量，但是回到最初的 CollectionViewController 时会出错。
     如果在某个时刻修改了其中的一个数据源，其他的数据源必须同步，不然会出错。
     */
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        if indexPath.section == 0{
            cell.backgroundColor = UIColor.redColor()
        }else{
            cell.backgroundColor = UIColor.brownColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = UICollectionViewFlowLayout()
        //根据点击 cell 的位置来决定下一级的 CollectionView 的布局
        layout.itemSize = CGSize(width: indexPath.item * 10, height: indexPath.item * 10)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        let nextVc = CollectionViewControllerTransitionDemo(collectionViewLayout: layout)
        //Push 进入控制器栈后，不能更改useLayoutToLayoutNavigationTransitions的值，否则应用会崩溃。
        nextVc.useLayoutToLayoutNavigationTransitions = true
        navigationController?.pushViewController(nextVc, animated: true)
    }

}






















