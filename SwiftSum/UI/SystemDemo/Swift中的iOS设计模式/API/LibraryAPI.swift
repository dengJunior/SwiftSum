//
//  LibraryAPI.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(LibraryAPI.downloadImage(_:)), name: "BLDownloadImageNotification", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func downloadImage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let imgageView = userInfo["imageView"] as! UIImageView?
        let coverUrl = userInfo["coverUrl"] as! String
        
        if let imageViewUnWrapped = imgageView {
            imageViewUnWrapped.image = persistencyManager.getImage(coverUrl)
            if imageViewUnWrapped.image == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let donwloadImage = self.httpClient.downloadImage(coverUrl)
                    dispatch_sync(dispatch_get_main_queue(), {
                        imageViewUnWrapped.image = donwloadImage
                        self.persistencyManager.saveImage(donwloadImage, filename: coverUrl)
                    })
                })
            }
        }
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    // MARK: - 外观模式 - Facade
    
    //Facade设计模式为多个子模块或子系统提供统一的、单独的API接口。也就是说，不用给用户暴露一堆乱七八糟的接口，只需要暴露一个简单的、标准的接口即可。

    /**
     现在我们用 PersistencyManager 来管理专辑数据，用 HTTPClient 来处理网络请求，项目中的其他类不应该知道这个逻辑。他们只需要知道 LibraryAPI 这个"外观"就可以了。
     */
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: "\(index)")
        }
    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
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
                           coverUrl: "http://images.meilele.com/images/201407/1405677273360287963.jpg",
                           year: "1992")
        
        let album2 = Album(title: "It's My Life",
                           artist: "No Doubt",
                           genre: "Pop",
                           coverUrl: "http://images.meilele.com/images/201407/1405677273360287963.jpg",
                           year: "2003")
        
        let album3 = Album(title: "Nothing Like The Sun",
                           artist: "Sting",
                           genre: "Pop",
                           coverUrl: "http://images.meilele.com/images/201407/1405677273360287963.jpg",
                           year: "1999")
        
        let album4 = Album(title: "Staring at the Sun",
                           artist: "U2",
                           genre: "Pop",
                           coverUrl: "http://images.meilele.com/images/201407/1405677273360287963.jpg",
                           year: "2000")
        
        let album5 = Album(title: "American Pie",
                           artist: "Madonna",
                           genre: "Pop",
                           coverUrl: "http://images.meilele.com/images/201407/1405677273360287963.jpg",
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
    
    func getImage(filename: String) -> UIImage? {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        
        do {
            let data = try NSData(contentsOfFile: path, options: .UncachedRead)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    func saveImage(image: UIImage, filename: String) {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        let data = UIImagePNGRepresentation(image)
        do {
            try data?.writeToFile(path, options: .AtomicWrite)
        } catch {
            
        }
    }
    
    func saveAlbums() {
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")
        let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
        do {
            try data.writeToFile(filename, options: .AtomicWrite)
        } catch {
            
        }
    }
}

































