//
//  iOS6AndiOS7.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class iOS6Feature: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - ## iOS6新特性
    
    // MARK: ### 一、关于内存警告
    //ios6中废除了viewDidUnload，viewWillUnload这两个系统回调，收到内存警告时在didReceiveMemoryWarning中进行相关的处理。
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: ### 二、关于屏幕旋转
    /**
     ios6 废除了shouldAutorotateToInterfaceOrientation这个旋转屏幕的设置接口。
     必须在两个新接口中设置旋转属性:shouldAutorotate、supportedInterfaceOrientations。
     */
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .AllButUpsideDown
    }
    //收到旋转事件后的处理,同样在willRotateToInterfaceOrientation和didRotateFromInterfaceOrientation中进行。
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    }
    
    func apiDemo() {
        // MARK: ### 三、UISwitch
        //ios6下，新增了以下几个属性，可以设置开关的颜色以及背景图。
//        let uiswitch = UISwitch()
//        uiswitch.tintColor
//        uiswitch.thumbTintColor
//        uiswitch.onImage
//        uiswitch.offImage
//        
        // MARK: ### 四、UINavigationBar
        //ios6新增了，设置阴影图片的属性。
        let navBar = self.navigationController?.navigationBar
        navBar?.shadowImage
        
        // MARK: ### 五、UIImage
        //可以在ios6下设置图片的scale比例尺寸了。
//        let image = UIImage(data: NSData(), scale: 1)
        
        // MARK: ### 七、UICollectionView
        //全新的集合控件，应用场景有类似照片墙，瀑布流等。
    }
    
    // MARK: ### 六、UIRefreshControl
    func addHeaderRefresh() {
        //之前苹果官方是没有现成的下拉刷新的控件，都是自己实现或者使用比较成熟的开源库。ios6苹果加入了UIRefreshControl，配合UITableView直接实现下拉刷新。
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "加载中...")
        refreshControl.tintColor = UIColor.grayColor()
        refreshControl.addTarget(self, action: #selector(refreshAction), forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
    }
    func refreshAction() {
        self.refreshControl?.endRefreshing()
    }
}


















