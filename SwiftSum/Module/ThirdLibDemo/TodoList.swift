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
    var hash = 0
    var text = ""
    var completed = false
}

class TodoList: YYXibView, UITableViewDataSource, UITableViewDelegate {
    var model = [TodoListItemModel]()
    var todoListDidTapItemCallback: ((_ : NSIndexPath) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
        todoListDidTapItemCallback?(indexPath)
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
            textLabel?.textColor = UIColor.darkGrayColor()
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = self.model.text
            textLabel?.textColor = UIColor.blackColor()
        }
        
    }
}



















