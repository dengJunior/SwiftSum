//
//  NavigationBarHideDemo.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UINavigationController {
    var statusBarHeight: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height - view.convertRect(view.bounds, toView: nil).minY
    }
    var navBarHeight: CGFloat {
        return navigationBar.frame.size.height
    }
    var navAndStatusBarHeight: CGFloat {
        return statusBarHeight + navBarHeight
    }
    
    var tabBarOffset: CGFloat {
        if let tabBarController = tabBarController {
            return tabBarController.tabBar.translucent ? 0 : tabBarController.tabBar.frame.height
        }
        return 0
    }
}


// MARK: - scrollView delegate
extension NavigationBarHideDemo {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if NavigationBarHideDemo.lastContentOffset == CGPointZero {
            NavigationBarHideDemo.lastContentOffset = scrollView.contentOffset
            return
        }
        
        let offset = NavigationBarHideDemo.lastContentOffset.y - scrollView.contentOffset.y
//        let pullUp = offset > 0
        
        NavigationBarHideDemo.lastContentOffset = scrollView.contentOffset
        if scrollView.contentOffset.y > 64 {
            setNavigationBar(offset)
        }
    }
    
    func setNavigationBar(offset: CGFloat) {
        var frame = navigationController!.navigationBar.frame
        frame.origin.y += offset
        if frame.origin.y <= 20 - 44 {
            frame.origin.y = 20 - 44
        } else if(frame.origin.y > 20) {
            frame.origin.y = 20
        }
        navigationController!.navigationBar.frame = frame
    }
}

class NavigationBarHideDemo: UITableViewController {
    static var lastContentOffset = CGPointZero
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .Top
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    // Enable the navbar scrolling
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.translucent = false
    }
    
    // MARK: - UITableView data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "UINavigationBar逐渐显示和隐藏,上下滑动看效果"
        return cell
    }

}
