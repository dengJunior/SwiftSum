//
//  TodoAdd.swift
//  SwiftSum
//
//  Created by sihuan on 2016/8/8.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

struct TodoHeaderModel {
    var text: String? = nil
}

class TodoHeader: YYXibView, UITextFieldDelegate, YYComponent {
    // MARK: - Initialization
    
    func initialization() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        textField.text = self.model.text
        addButton.enabled = textField.text?.characters.count > 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
    }
    
    // MARK: - Public
    
    var model = TodoHeaderModel()
    var addButtonDicTapCallback: ((_ : String?) -> Void)?
    
    func render(model: Any? = nil) {
        if let outModel = model as? TodoHeaderModel {
            self.model = outModel
        }
        textField.text = self.model.text
    }
    
    // MARK: - Private
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    
    @IBAction private func addButtonDidTap(sender: UIButton) {
        if textField.text?.characters.count > 0 {
            addButtonDicTapCallback?(textField.text)
            textField.text = nil
            model.text = nil
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addButtonDidTap(addButton)
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        addButton.enabled = textField.text?.characters.count > 0
    }
}
