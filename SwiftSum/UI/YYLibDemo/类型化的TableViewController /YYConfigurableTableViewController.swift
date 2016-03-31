//
//  YYConfigurableTableViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

protocol CellConfiguratorType {
    
    var reuseIdentifier: String { get }
    var cellClass: AnyClass { get }
    
    func updateCell(cell: UITableViewCell)
}

/*
声明 Updatable 协议

我们的 cell 是根据 view data 来呈现不同界面的，因此我们定义一个 Updatable 协议，
同时让它和一个类型 ViewData 进行绑定：
*/
protocol Updatable: class {
    typealias ViewData
    
    func updateWithViewData(viewdata: ViewData)
}


/*
定义 CellConfigurator 结构

1. 找出要使用哪一种 cell 类

2. 找出要使用哪一个重用 Identifier

3. 用 veiw data 渲染 cell

Cell 有两个约束：首先必须实现了 Updatable 协议，其次它必须是 UITableViewCell 子类。
*/
struct CellConfigurator<Cell where Cell: Updatable, Cell: UITableViewCell> {
    
    let viewData: Cell.ViewData
    let reuseIdentifier: String = NSStringFromClass(Cell)
    let cellClass: AnyClass = Cell.self
    
    func updateCell(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.updateWithViewData(viewData)
        }
    }
}

extension CellConfigurator: CellConfiguratorType {
    
}


class YYConfigurableTableViewController: UIViewController {

    weak var tableView: UITableView!
    
    var items: [CellConfiguratorType]
    
    init(items: [CellConfiguratorType]) {
        self.items = items;
        super.init(nibName: nil, bundle: nil)
    }

    required init?(
        coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: view.bounds)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.dataSource = self
        registerCells()
    }

    func registerCells() {
        for cellConfigurator in items {
            tableView.registerClass(cellConfigurator.cellClass, forCellReuseIdentifier: cellConfigurator.reuseIdentifier)
        }
    }
    

}

extension YYConfigurableTableViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellConfigurator = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellConfigurator.reuseIdentifier, forIndexPath: indexPath)
        cellConfigurator.updateCell(cell)
        return cell
    }
}

