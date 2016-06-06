//
//  YYTool.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/3.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYTool: UIView {

    // MARK: - 终止程序
    /*
     比如可以在应用内直接切换正式测试环境。切换后让应用退出
     */
    public static func terminateApplication() {
        //退出代码
        exit(0);
    }
}
