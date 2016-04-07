//
//  Album.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import Foundation

struct Album {
    var title : String!
    var artist : String!
    var genre : String!
    var coverUrl : String!
    var year : String!
    
    /**
     通过这个初始化方法，传入专辑名称、演唱者、风格、专辑封面图片的URL以及年份这些属性。
     */
    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    func description() -> String {
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