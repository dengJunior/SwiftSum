//
//  LibraryAPI.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

// MARK: - 创建单例模式的3种方式，都支持延迟初始化和线程安全。
class LibraryAPI: NSObject {
    // MARK: - 方式一 1.2中不能使用
    static let sharedInstance = LibraryAPI()
    
    // MARK: - 方式二
    class var sharedInstance2: LibraryAPI {
        /*
         1.创建一个类变量的计算属性。类变量类似Objective-C中的类方法，也就是说在任何时候你访问sharedInstance属性时，都不需要对LibraryAPI进行实例化，关于属性类型更多的知识请参阅Swift文档 – properties。
         2.在类变量中内嵌一个结构体，名为Singleton。
         3.Singleton中包含一个名为instance的静态常量属性。用static申明属性意味着该属性只能存在一份。这里要注意的是Swift中的静态属性都会延迟加载，也就是说只有instance被使用时，才会初始化它。还要注意的一点是，一旦instance被初始化了，那么它就是一个常量属性，不会有第二次初始化的机会了。这就是Singleton模式的精髓所在。
         4.返回该计算属性的值。
         */
        struct Singleton {
            static let instance = LibraryAPI()
        }
        return Singleton.instance
    }
    
    // MARK: - 方式三,OC方式，使用dispatch_once
    class var sharedInstance3: LibraryAPI {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LibraryAPI? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LibraryAPI()
        }
        return Static.instance!
    }
    
    private let persistencyManager: PersistencyManager
    private let httpClient: HTTPClient
    private let isOnline: Bool
    /*
     isOnline属性决定了是否向远程服务器上更新专辑数据的变化，比如添加或删除专辑。
     因为本篇教程中的示例应用只是为了向大家介绍如何运用各种设计模式，所以没有远程服务器的需求，
     HTTPClient自然不会用到。所以这里isOnline属性总是设置为false。
     */
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = false
        super.init()
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    /**
     添加专辑的方法,在实现时会先更新本地的数据，如果网络连通且需要使用远程服务的时候，再调用远程服务接口更新数据状态。当该模块以外的类调用了LibraryAPI接口的addAlbum方法时，它并不知道添加专辑的具体实现逻辑，并且也不需要知道，这就是Facade设计模式的魅力所在。
     */
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description())
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: "\(index)")
        }
    }

}


class PersistencyManager: NSObject {
    //用于储存专辑数据
    private var albums = [Album]()
    
    override init() {
        //demo 数据
        let album1 = Album(title: "Best of Bowie",
                           artist: "David Bowie",
                           genre: "Pop",
                           coverUrl: "http://www.coversproject.com/static/thumbs/album/album_david%20bowie_best%20of%20bowie.png",
                           year: "1992")
        
        let album2 = Album(title: "It's My Life",
                           artist: "No Doubt",
                           genre: "Pop",
                           coverUrl: "http://www.coversproject.com/static/thumbs/album/album_no%20doubt_its%20my%20life%20%20bathwater.png",
                           year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
                           artist: "Sting",
                           genre: "Pop",
                           coverUrl: "http://www.coversproject.com/static/thumbs/album/album_sting_nothing%20like%20the%20sun.png",
                           year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
                           artist: "U2",
                           genre: "Pop",
                           coverUrl: "http://www.coversproject.com/static/thumbs/album/album_u2_staring%20at%20the%20sun.png",
                           year: "2000")
        
        let album5 = Album(title: "American Pie",
                           artist: "Madonna",
                           genre: "Pop",
                           coverUrl: "http://www.coversproject.com/static/thumbs/album/album_madonna_american%20pie.png",
                           year: "2000")
        
        albums = [album1, album2, album3, album4, album5]
    }
    
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if (albums.count >= index) {
            albums.insert(album, atIndex: index)
        } else {
            albums.append(album)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        albums.removeAtIndex(index)
    }
}

















