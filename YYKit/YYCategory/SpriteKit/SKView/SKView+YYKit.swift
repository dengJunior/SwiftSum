//
//  YY.swift
//  SwiftSum
//
//  Created by sihuan on 2016/6/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import SpriteKit

public extension SKView {
    //打开诊断信息
    func showDiagnosticInfo(isShow: Bool = true) {
        showsDrawCount = isShow
        showsNodeCount = isShow
        showsFPS = isShow
    }
}
