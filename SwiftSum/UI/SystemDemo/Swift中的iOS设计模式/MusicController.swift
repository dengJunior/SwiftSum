//
//  MusicController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 一个音乐仓库应用，能显示你们收藏的专辑以及相关信息。

class MusicController: UIViewController {

    @IBOutlet var dataTable: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var scroller: HorizontalScroller!
    
    private var allAlbums = [Album]()
    private var currentAlbumData: (titles:[String], values:[String])?
    private var currentAlbumIndex = 0
    
    var undoStack: [(Album, Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        currentAlbumIndex = 0;
        
        //通过API获取所有专辑的列表。这里要记住，要使用符合Facade模式的LibraryAPI而不是直接使用PersisencyManager。
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
        
        self.showDataForAlbum(currentAlbumIndex)
        
        scroller.delegate = self
        reloadScroller()
        
        let undoButton = UIBarButtonItem(barButtonSystemItem: .Undo, target: self, action: #selector(undoAction))
        undoButton.enabled = false
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let trashButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(deleteAlbum))
        toolbar.setItems([undoButton, space, trashButton], animated: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveCurrentState), name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    //从专辑数组中获取到专辑的对象，然后请求并保存专辑的数据。
    func showDataForAlbum(albumIndex: Int) {
        // 保证代码健壮性，确保专辑数至少大于0，避免数组下标越界的错误
        if (albumIndex < allAlbums.count && albumIndex > -1) {
            //获取专辑对象
            let album = allAlbums[albumIndex]
            // 保存专辑的数据，用于一会在tableview中展现
            currentAlbumData = album.ae_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
        // 我们已经获取到了需要的数据，可以刷新tableview来显示数据了
        dataTable!.reloadData()
    }
    
    func reloadScroller() -> Void {
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if currentAlbumIndex >= allAlbums.count {
            currentAlbumIndex = allAlbums.count - 1
        }
        scroller.reload()
        showDataForAlbum(currentAlbumIndex)
    }
    
    func addAlbumAtIndex(album: Album, index: Int) -> Void {
        LibraryAPI.sharedInstance.addAlbum(album, index: index)
        currentAlbumIndex = index
        reloadScroller()
    }
    
    func deleteAlbum() -> Void {
        let deletedAlbum: Album = allAlbums[currentAlbumIndex]
        let undoAction = (deletedAlbum, currentAlbumIndex)
        undoStack.insert(undoAction, atIndex: 0)
        
        LibraryAPI.sharedInstance.deleteAlbumAtIndex(currentAlbumIndex)
        reloadScroller()
        
        let barButtonItems = toolbar.items
        let undoButton = barButtonItems![0]
        undoButton.enabled = true
        
        if allAlbums.count == 0 {
            let trashButton = barButtonItems![2]
            trashButton.enabled = false
        }
    }
    
    func undoAction() {
        let barButtonItems = toolbar.items
        if undoStack.count > 0 {
            let (deletedAlbum, index) = undoStack.removeFirst()
            addAlbumAtIndex(deletedAlbum, index: index)
        }
        
        if undoStack.count == 0 {
            let undoButton = barButtonItems?.first
            undoButton?.enabled = false
        }
        
        let trashButton = barButtonItems?.last
        trashButton?.enabled = true
    }
    
    // MARK: - Memento Pattern
    func saveCurrentState() {
        NSUserDefaults.standardUserDefaults().setInteger(currentAlbumIndex, forKey: "currentAlbumIndex")
        LibraryAPI.sharedInstance.saveAlbums()
    }

}

// MARK: - 装饰者模式 - Decorator

//装饰者模式可以动态的给指定的类添加一些行为和职责，而不用对原代码进行任何修改。当你需要使用子类的时候，不妨考虑一下装饰者模式，可以在原始类上面封装一层。

//在 Swift 里，有两种方式实现装饰者模式：扩展 (Extension) 和委托 (Delegation)。

// MARK: - HorizontalScrollerDelegate
extension MusicController: HorizontalScrollerDelegate {
    func initialViewIndex(scroller: HorizontalScroller) -> Int {
        return currentAlbumIndex
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return allAlbums.count
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), albumCover: album.coverUrl)
        albumView.hightlight(currentAlbumIndex == index)
        return albumView
    }
    
    func horizontalScrollerClickedViewAtIndex(scroll: HorizontalScroller, index: Int) {
        if currentAlbumIndex == index {
            return
        }
        
        let prevView = scroll.viewAtIndex(currentAlbumIndex) as! AlbumView
        prevView.hightlight(false)
        
        currentAlbumIndex = index
        
        let albumView = scroll.viewAtIndex(index) as! AlbumView
        albumView.hightlight(true)
        
        showDataForAlbum(index)
    }
}

extension MusicController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albumData = currentAlbumData {
            return albumData.titles.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if let albumData = currentAlbumData {
            cell.textLabel?.text = albumData.titles[indexPath.row]
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = albumData.values[indexPath.row]
            }
        }
        return cell
    }
}

extension MusicController: UITableViewDelegate {
}

























