//
//  Provider.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/23.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

struct ChannelInfo {
    var abbr_en: String?
    var channel_id: String?
    var name: String?
    var name_en: String?
    var seq_id: String?
    var jsonString: String?
}

struct Singers {
    var id: String
    var name: String
    var relatedSiteId: Int
    var isSiteArtist: Int
}

struct SongInfo {
    var like: String
    
    var aid: String
    
    var album: String
    
    var sha256: String
    
    var kbps: String
    
    var alert_msg: String
    
    var picture: String
    
    var url: String
    
    var singers: [Singers]
    
    var length: String
    
    var title: String
    
    var sid: String
    
    var albumtitle: String
    
    var file_ext: String
    
    var ssid: String
    
    var artist: String
    
    var  status: String
    
    var subtype: String
    
    var  jsonString: String
}




enum DouApi: String {
    case base = "http://www.douban.com/j"
    /// 登陆
    case login = "http://www.douban.com/j/app/login"
    
    /// 频道（Channels）
    case channels = "http://www.douban.com/j/app/radio/channels"
    
    /// 歌曲列表（未登陆）
    case playList = "http://www.douban.com/j/app/radio/people"
    
    /// 歌曲列表（已登陆）
    case playListLogined = "http://www.douban.com/j/app/radio/people?type=%@&sid=%@&pt=%@&channel=%@&app_name=radio_android&version=100&user_id=%@&expire=%@&token=%@"
    
    /// 歌词
    case lyric = "http://api.douban.com/v2/fm/lyric"
}

enum MusicOperation: String {
    case none = "n"     //n : None                  单纯获取歌曲（比如一开始进入豆瓣）
    case end = "e"      //e : Normally ended a song 正常播放完一首歌
    case unlike = "u"   //u : Unlike（un-heart）     取消该歌曲的红心
    case like = "r"     //r : Like（heart）          对该歌曲加红心
    case skip = "s"     //s : Skip                  下一曲
    case ban = "b"      //b : Ban                   将该歌曲放入垃圾桶
    case play = "p"     //p : 单首歌曲播放开始且播放列表已空时发送, 长报告
}


extension DouApi {
    static func requestChannels(completion: (NSError?, [ChannelInfo]?) -> Void) {
        YYHttp.build(urlString: DouApi.channels.rawValue)
            .responseJSON{ (dictOrArray, response, error) in
                completion(error, nil)
        }
    }
    
    static func requestPlayList(operation: MusicOperation, completion: (NSError?, [ChannelInfo]?) -> Void) {
        let params = [
            "type":operation.rawValue,
            "sid":operation.rawValue,
            "channel":operation.rawValue,
            "app_name":"radio_android",
            "version":"100",
            ]
        YYHttp.build(urlString: DouApi.playList.rawValue)
            .addParams(params)
            .responseJSON { (dictOrArray, response, error) in
                completion(error, nil)
        }
    }
}

class Provider: NSObject {
    
    
}

























