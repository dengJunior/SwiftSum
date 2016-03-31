//
//  GestureTestView.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import SnapKit


class GestureTestView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    var dataArray = []

    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
        self.addSingleTapGesture()
        
        if let view = SimpleGestureRecognizers.newInstanceFromNib() {
            self.addSubview(view)
            view.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
                make.right.equalTo(0)
            })
        }
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
    }
    
    // MARK: - Private
    
    func addSingleTapGesture() -> Void {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.singleTap))
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        self.addGestureRecognizer(singleTap);
    }
    
    func singleTap(tap: UITapGestureRecognizer) -> Void {
        print("singleTap")
    }
    
    // MARK: - Public
    
    
    // MARK: - Delegate
    

}

