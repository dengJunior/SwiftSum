//
//  YYXibView.swift
//  SwiftSum
//
//  Created by sihuan on 2016/7/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

public class YYXibView: UIView {
    @IBOutlet public var xibView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXibView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        loadXibView()
    }
    
    override public func layoutSubviews() {
        xibView.frame = self.bounds
    }
    
    func loadXibView() {
        xibView = NSBundle.mainBundle().loadNibNamed(self.classNameString, owner: self, options: nil).first as? UIView
        xibView.backgroundColor = UIColor.clearColor()
        xibView.frame = self.bounds
        addSubview(xibView)
    }

}
