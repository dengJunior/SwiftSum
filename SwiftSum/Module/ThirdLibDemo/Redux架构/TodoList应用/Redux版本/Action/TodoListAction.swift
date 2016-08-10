//
//  TodoListAction.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

enum TodoAction: Action {
    case add(text: String)
    case completed(id: Int)
    case filter(type: TodoFooterFilter)
}


