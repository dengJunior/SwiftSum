//
//  AlbumView.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    //coverImage属性用来展示专辑封面，indicator是当正在下载封面图片时转动的菊花。
    private var coverImage: UIImageView!
    private var indicator: UIActivityIndicatorView!

    /**
     AlbumView真正的初始化方法是另外一个init方法，在这个方法中设置了一些默认的属性，比如将背景色设置为黑色、实例化了coverImage属性，并让它与父容器有5px的四周间距、实例化indicator并设置位置及风格。
     */
    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        commonInit()
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["imageView":coverImage, "coverUrl" : albumCover])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        coverImage.removeObserver(self, forKeyPath: "image")
    }
    
    func hightlight(didHighlightView: Bool) -> Void {
        backgroundColor = didHighlightView ? UIColor.whiteColor() : UIColor.blackColor()
    }
    
    func commonInit() {
        backgroundColor = UIColor.blackColor()
        coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(coverImage)
        coverImage.addObserver(self, forKeyPath: "image", options: .New, context: nil)
        
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" {
            indicator.stopAnimating()
        }
    }
}




























