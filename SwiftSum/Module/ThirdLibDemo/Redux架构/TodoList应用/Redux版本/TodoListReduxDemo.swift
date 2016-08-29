//
//  TodoListReduxDemo.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/9.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

let TodoStore = Store<TodoState>(
    reducer: TodoReducer(),
    state: nil
)

struct TodoState: StateType {
    var todoListItems = [TodoListItemModel]()
    var filter = TodoFooterFilter.all
    var scrollToBottom = false
    
    init(todoListItems: [TodoListItemModel], filter: TodoFooterFilter, scrollToBottom: Bool) {
        self.todoListItems = todoListItems
        self.filter = filter
        self.scrollToBottom = scrollToBottom
    }
    init(todoListItems: [TodoListItemModel], filter: TodoFooterFilter) {
        self.todoListItems = todoListItems
        self.filter = filter
    }
    init() {
        
    }
}

class TodoListReduxDemo: UIViewController, StoreSubscriber {
    
    @IBOutlet weak var todoHeader: TodoHeader!
    @IBOutlet weak var todoList: TodoList!
    @IBOutlet weak var todoFooter: TodoFooter!
    
    func newState(state: TodoState) {
        var items: [TodoListItemModel]
        switch state.filter {
        case .all:
            items = state.todoListItems
        case .completed:
            items = state.todoListItems.filter{ $0.completed }
        case .active:
            items = state.todoListItems.filter{ !$0.completed }
        }
        todoList.render(items)
        if state.scrollToBottom {
            todoList.scrollToBottomIfNeeded()
        }
    }
    
    func initialization() {
        TodoStore.subscribe(self)
        
        todoHeader.addButtonDicTapCallback = { text in
            TodoStore.dispatch(TodoAction.add(text: text!))
        }
        todoList.todoListDidTapItemCallback = { itemId in
            TodoStore.dispatch(TodoAction.completed(id: itemId))
        }
        todoFooter.buttonDidTapCallback = { filter in
            TodoStore.dispatch(TodoAction.filter(type: filter))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutNone()
        initialization()
    }
    
    deinit {
        print("TodoListReduxDemo deinit")
    }
}
