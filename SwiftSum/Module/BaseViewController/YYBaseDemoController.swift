//
//  YYBaseDemoController.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

// MARK: - demoController的模型
struct LibDemoInfo {
    var title: String?
    var desc: String?
    var controllerName: String?
    
    init(title:String?, desc:String?, controllerName:String?) {
        self.title = title;
        self.desc = desc;
        self.controllerName = controllerName;
    }
}

// MARK: - 显示demoController列表的模板

class YYBaseDemoController: UITableViewController {

    let cellIdentifier = "reuseIdentifier"
    var dataArray = [LibDemoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 60;
        
        let footerView = UIView();
        footerView.backgroundColor = UIColor.clearColor();
        self.tableView.tableFooterView = footerView;
    }

    // MARK: - UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let item = dataArray[indexPath.row]
        cell?.accessoryType = item.controllerName != nil ? UITableViewCellAccessoryType.DisclosureIndicator : UITableViewCellAccessoryType.None;
        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.desc
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        let item = dataArray[indexPath.row]
        
        if let controllerName = item.controllerName {
            if let vc: UIViewController = getInstanceFromString(controllerName) as? UIViewController {
                vc.title = item.title
                if vc.view.backgroundColor == nil {
                    vc.view.backgroundColor = UIColor.whiteColor()
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
