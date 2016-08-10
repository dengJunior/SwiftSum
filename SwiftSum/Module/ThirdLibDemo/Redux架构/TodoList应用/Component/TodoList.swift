//
//  TodoList.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

struct TodoListItemModel {
    var id: Int = 0
    var text = ""
    var completed = false
    
    init(text: String, completed: Bool) {
        self.text = text
        self.completed = completed
        
        //不能用该方式来做hash，因为在比较多的值拷贝的时候，可能会复用这块内存
        //id = unsafeAddressOf("\(self)").hashValue
    }
    
    init() {
    }
}

class TodoList: YYXibView, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Initialization
    
    func initialization() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.registerClass(TodoListItem.self, forCellReuseIdentifier: "TodoListItem")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
    }
    
    // MARK: - Public
    
    var model = [TodoListItemModel]()
    var todoListDidTapItemCallback: ((itemId : Int) -> Void)?
    
    func render(model: Any? = nil) {
        if let outModel = model as? [TodoListItemModel] {
            self.model = outModel
        }
        tableView.reloadData()
    }
    
    func scrollToBottomIfNeeded(animated: Bool = true) {
        if self.model.count > 4 {
            tableView.scrollToBottom()
        }
    }
    
    // MARK: - Private
    
    @IBOutlet private weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoListItem", forIndexPath: indexPath) as! TodoListItem
        cell.render(model[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        todoListDidTapItemCallback?(itemId: model[indexPath.row].id)
    }
}

class TodoListItem: UITableViewCell, YYComponent {
    var model = TodoListItemModel()
    
    func render(model: Any? = nil) {
        if let outModel = model as? TodoListItemModel {
            self.model = outModel
        }
        let text = self.model.text
        if self.model.completed {
            textLabel?.text = nil
            textLabel?.attributedText = NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
            textLabel?.textColor = UIColor.orangeColor()
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = self.model.text
            textLabel?.textColor = UIColor.blackColor()
        }
        
    }
}



















