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
        
        // MARK: - ## 观察者模式 - Observer
        
//        在观察者模式里，一个对象在状态变化的时候会通知另一个对象。参与者并不需要知道其他对象的具体是干什么的 - 这是一种降低耦合度的设计。这个设计模式常用于在某个属性改变的时候通知关注该属性的对象。
        
//        常见的使用方法是观察者注册监听，然后再状态改变的时候，所有观察者们都会收到通知。
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




























