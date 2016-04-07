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
    
    private var allAlbums = [Album]()
    private var currentAlbumData: (titles:[String], values:[String])?
    private var currentAlbumIndex = 0
    
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

























