//
//  YYBaseDemoController.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/3.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class LibDemoInfo {
    var title:String!
    var desc:String!
    var controllerName:String!
    
    init(title:String, desc:String, controllerName:String) {
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
        if item.controllerName == nil {
            return
        }
        if let vc:UIViewController = getInstanceFromString(item.controllerName) as? UIViewController {
            vc.title = item.title
            vc.view.backgroundColor = UIColor.whiteColor()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - 根据类名来实例化对象
    func getInstanceFromString(className: String) ->AnyObject? {
        let classType:AnyClass = swiftClassFromString(className)
        
        return (classType as! NSObject.Type).init()
    }
    
    //NSClassFromString 在Swift中已经 no effect
    func swiftClassFromString(className: String) -> AnyClass! {
        
        if  let appName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            // generate the full name of your class (take a look into your "SHCC-swift.h" file)
            let classStringName = "_TtC\(appName!.characters.count)\(appName!)\(className.characters.count)\(className)"
            let cls: AnyClass?  = NSClassFromString(classStringName)
            //            cls = NSClassFromString("\(appName).\(className)")
            assert(cls != nil, "class notfound,please check className")
            return cls
        }
        return nil;
    }
}
