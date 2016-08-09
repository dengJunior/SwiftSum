//
//  TodoFooter.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

enum TodoFooterFilter: Int {
    case all, completed, active
}

struct TodoFooterModel {
    var filter = TodoFooterFilter.all
}

class TodoFooter: YYXibView, YYComponent {
    var model = TodoFooterModel()
    var buttons = [UIButton]()

    var buttonDidTapCallback: ((_ : TodoFooterFilter) -> Void)?
    
    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    
    func initialization() {
        allButton.tag = TodoFooterFilter.all.rawValue
        completedButton.tag = TodoFooterFilter.completed.rawValue
        activeButton.tag = TodoFooterFilter.active.rawValue
        buttons.append(allButton)
        buttons.append(completedButton)
        buttons.append(activeButton)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
        updateButtonState()
    }
    
    func updateButtonState() {
        for button in buttons {
            button.enabled = model.filter.rawValue != button.tag
        }
    }
    
    func render(model: Any? = nil) {
        if let outModel = model as? TodoFooterModel {
            self.model = outModel
        }
        updateButtonState()
    }
    
    @IBAction func buttonDidTap(sender: UIButton) {
        let filter = TodoFooterFilter(rawValue: sender.tag)!
        model.filter = filter
        updateButtonState()
        buttonDidTapCallback?(filter)
    }
}












