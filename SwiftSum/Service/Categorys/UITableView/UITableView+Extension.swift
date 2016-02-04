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
    func clearExtraCellLine() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clearColor()
        self.tableFooterView = footerView
    }
}

