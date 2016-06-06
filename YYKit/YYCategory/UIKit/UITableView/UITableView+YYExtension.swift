//
//  UITableView+Extension.swift
//  YYSummaryiOS
//
//  Created by sihuan on 15/8/19.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import UIKit

extension UITableView {
    
    // MARK: - 清除多余的分割线
    public func clearExtraCellLine() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        self.tableFooterView = footerView
    }
    
    // MARK: - 简化dequeueReusableCellWithIdentifier的使用
    /**
     简化dequeueReusableCellWithIdentifier的使用
     let cell = tableView.dequeueReusableCellWithIdentifier("XxxxxCell") as! XxxxxCell
     
     let cell = tableView.dequeueCell(RankingCell)
     */
    public func dequeueCell<T: UITableViewCell>(cell: T.Type) -> T {
        return dequeueReusableCellWithIdentifier(T.classNameString) as! T
    }
}




