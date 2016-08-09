//
//  Reducer.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

struct CounterReducer: Reducer {
    //获取最新的应用状态，并且对相应的动作进行处理。
    func handleAction(action: Action, state: CounterState?) -> CounterState {
        var state = state ?? CounterState()
        switch action {
        case _ as CounterActionIncrease:
            state.counter += 1
        case _ as CounterActionDecrease:
            state.counter -= 1
        default:
            break
        }
        return state
    }
}
