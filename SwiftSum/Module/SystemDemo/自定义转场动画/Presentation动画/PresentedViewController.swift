//
//  PresentedViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/16.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let widthConstraint = inputTextField.constraints.filter { (constraint) -> Bool in
            constraint.identifier == "Width"
        }.first
        widthConstraint?.constant = view.frame.width * 2 / 3
        
        UIView.animateWithDuration(0.3) { 
            self.dismissButton.alpha = 1
            self.inputTextField.layoutIfNeeded()
        }
    }

    @IBAction func dismiss(sender: AnyObject) {
        var applyTransform = CGAffineTransformMakeRotation(3 * CGFloat(M_PI))
        applyTransform = CGAffineTransformScale(applyTransform, 0.1, 0.1)
        
        let widthContraint = inputTextField.constraints.filter({constraint in
            constraint.identifier == "Width"
        }).first
        widthContraint?.constant = 0
        
        UIView.animateWithDuration(0.4, animations: {
            self.dismissButton.transform = applyTransform
            self.inputTextField.layoutIfNeeded()
            }, completion: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}


























