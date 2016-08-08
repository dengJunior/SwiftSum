//
//  Store.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

let counterStore = Store<CounterState>(
    reducer: CounterReducer(),
    state: nil
)
