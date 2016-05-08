//
//  CustomPresentationSecondViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/29.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class CustomPresentationSecondViewController: UIViewController {

    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updatePreferedContentSizeWithTraitCollection(traitCollection)
    }

    func updatePreferedContentSizeWithTraitCollection(traitCollection: UITraitCollection) {
        self.preferredContentSize = CGSize(width: CGRectGetWidth(self.view.bounds), height: traitCollection.verticalSizeClass == .Compact ? 270 : 420)
        slider.maximumValue = Float(self.preferredContentSize.height)
        slider.minimumValue = 220
        slider.value = self.slider.maximumValue
    }

    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(traitCollection, withTransitionCoordinator: coordinator)
        updatePreferedContentSizeWithTraitCollection(traitCollection)
    }
}

// MARK: - 对视图上的基本UI控件进行初始化，读者可以忽略
extension CustomPresentationSecondViewController {
    func setupView() {
        view.backgroundColor = UIColor.lightGrayColor()    // 设置背景颜色
        
        /// 创建label
        let label = UILabel()
        label.text = "To"
        label.textAlignment = .Center
        label.font = UIFont(name: "Helvetica", size: 60)
        view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(144)
        }
        
        view.addSubview(slider)
        slider.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.left.equalTo(view).offset(20)
            make.height.equalTo(30)
        }
        slider.addTarget(self, action: #selector(CustomPresentationSecondViewController.sliderValueChange(_:)), forControlEvents: .ValueChanged)
        
        /// 创建button
        let button = UIButton()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.setTitle("Dismiss", forState: .Normal)
        button.addTarget(self, action: #selector(CustomPresentationSecondViewController.buttonDidClicked), forControlEvents: .TouchUpInside)
        view.addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-20)
            make.top.equalTo(slider.snp_bottom).offset(8)
            make.centerX.equalTo(view)
            make.width.equalTo(245)
        }
    }
    
    func buttonDidClicked() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sliderValueChange(sender: UISlider) {
        self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, CGFloat(sender.value))
    }
}

















