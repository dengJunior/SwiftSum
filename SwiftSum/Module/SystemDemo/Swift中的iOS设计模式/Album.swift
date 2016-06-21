//
//  Album.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

// MARK: - ## 备忘录模式 - Memento

//备忘录模式捕捉并且具象化一个对象的内在状态。换句话说，它把你的对象存在了某个地方，然后在以后的某个时间再把它恢复出来，而不会打破它本身的封装性，私有数据依旧是私有数据。

// MARK: - ### 归档 - Archiving

//苹果通过归档的方法来实现备忘录模式。它把对象转化成了流然后在不暴露内部属性的情况下存储数据。你可以读一读 《iOS 6 by Tutorials》 这本书的第 16 章，或者看下[苹果的归档和序列化文档][14]。
class Album: NSObject, NSCoding{
    var title : String!
    var artist : String!
    var genre : String!
    var coverUrl : String!
    var year : String!
    
    /**
     通过这个初始化方法，传入专辑名称、演唱者、风格、专辑封面图片的URL以及年份这些属性。
     */
    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        super.init()
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.title = decoder.decodeObjectForKey("title") as! String
        self.artist = decoder.decodeObjectForKey("artist") as! String
        self.genre = decoder.decodeObjectForKey("genre") as! String
        self.coverUrl = decoder.decodeObjectForKey("cover_url") as! String
        self.year = decoder.decodeObjectForKey("year") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(artist, forKey: "artist")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(coverUrl, forKey: "cover_url")
        aCoder.encodeObject(year, forKey: "year")
    }
    
    override var description: String {
        return "title: \(title)" +
            "artist: \(artist)" +
            "genre: \(genre)" +
            "coverUrl: \(coverUrl)" +
            "year: \(year)"
    }
}

extension Album {
    /**
     注意该方法名的开头ae_，它是AlbumExtensions的缩写。
     这是一个约定俗成的扩展方法名的写法，目的在于防止扩展方法与原生方法名产生冲突。
     
     注意：通常类可以重写父类的方法或属性，但是在Extension中不可以。Extension中的方法名、属性名也不能和原生方法名、原生属性名相同。
     */
    func ae_tableRepresentation() -> (titles:[String], values:[String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}