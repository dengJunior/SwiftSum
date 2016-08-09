//
//  TodoList.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class TodoListDemo: UIViewController {
    
    @IBOutlet weak var todoHeader: TodoHeader!
    @IBOutlet weak var todoList: TodoList!
    @IBOutlet weak var todoFooter: TodoFooter!
    
    var todoHeaderModel = TodoHeaderModel()
    var todoListModel = [TodoListItemModel]()
    var todoFooterModel = TodoFooterModel()
    
    func initialization() {
        func renderTodoList(scrollToBottom: Bool = true) {
            let filter = todoFooterModel.filter
            let newModel: [TodoListItemModel]
            switch filter {
            case .all:
                newModel = todoListModel
            case .completed:
                newModel = todoListModel.filter { $0.completed }
            case .active:
                newModel = todoListModel.flatMap { !$0.completed ? $0 : nil  }
            }
            todoList.render(newModel)
            if scrollToBottom {
                todoList.scrollToBottomIfNeeded()
            }
        }
        todoHeader.addButtonDicTapCallback = { [weak self] text in
            if self == nil {
                return
            }
            if let text = text {
                var item = TodoListItemModel(text: text, completed: false)
                item.hash = self!.todoListModel.count
                self?.todoListModel.append(item)
                renderTodoList()
            }
        }
        todoList.todoListDidTapItemCallback = { [weak self] indexPath in
            if self != nil {
                let hash = self!.todoList.model[indexPath.row].hash
                for index in 0 ..< self!.todoListModel.count {
                    let item = self!.todoListModel[index]
                    if item.hash == hash {
                        self!.todoListModel[index].completed = !item.completed
                        break
                    }
                }
                renderTodoList(false)
            }
        }
        todoFooter.buttonDidTapCallback = { [weak self] filter in
            if self != nil {
                self!.todoFooterModel.filter = filter
                renderTodoList()
            }
        }
        todoHeader.model = todoHeaderModel
        todoList.model = todoListModel
        todoFooter.model = todoFooterModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
}

