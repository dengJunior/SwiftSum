//
//  TodoListReducer.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

class TodoReducer: Reducer {
    
    func handleAction(action: Action, state: TodoState?) -> TodoState {
        guard let action = action as? TodoAction else {
            return TodoState()
        }
        
        return TodoState(
            todoListItems: handleToDo(action, state: state?.todoListItems),
            filter: handleFilter(action, state: state?.filter),
            scrollToBottom: handleScrollToBottom(action, state: state?.scrollToBottom)
        )
    }
    
    // MARK: - 拆分 Reducer
    /*
     开发一个函数来做为主 reducer，它调用多个子 reducer 分别处理 state 中的一部分数据，
     然后再把这些数据合成一个大的单一对象。
     主 reducer 并不需要设置初始化时完整的 state。
     初始时，如果传入 undefined, 子 reducer 将负责返回它们的默认值。
     */
    func handleToDo(action: TodoAction, state: [TodoListItemModel]?) -> [TodoListItemModel] {
        var newState = state ?? [TodoListItemModel]()
        switch action {
        case .add(let text):
            var item = TodoListItemModel(text: text, completed: false)
            item.id = newState.count
            newState.append(item)
        case .completed(let itemId):
            for index in 0 ..< newState.count {
                let item = newState[index]
                if item.id == itemId {
                    newState[index].completed = !item.completed
                }
            }
        default:
            break
        }
        return newState
    }
    
    func handleFilter(action: TodoAction, state: TodoFooterFilter?) -> TodoFooterFilter {
        var newState = state ?? TodoFooterFilter.all
        switch action {
        case .filter(let type):
            newState = type
        default:
            break
        }
        return newState
    }
    
    func handleScrollToBottom(action: TodoAction, state: Bool?) -> Bool {
        var newState = true
        switch action {
        case .completed(_):
            newState = false
        default:
            break
        }
        return newState
    }
}

