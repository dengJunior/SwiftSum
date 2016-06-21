//
//  CollectionTextCell.swift
//  SwiftSum
//
//  Created by sihuan on 16/6/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

class CollectionTextCell: UICollectionViewCell, YYCellRenderable {

    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        backgroundColor = UIColor.randomColor()
        contentView.backgroundColor = UIColor.randomColor()
    }
    
    func rederWithMode(model: AnyObject, indexPath: NSIndexPath?, containerView: UIView?) {
        textLabel.text = model as? String
    }

}
