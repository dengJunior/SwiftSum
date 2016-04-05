//
//  EventAndGestureDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

extension UIGestureRecognizerState {
    var stringValue: String {
        switch self {
        case UIGestureRecognizerState.Possible:
            return "UIGestureRecognizerState.Possible"
        case UIGestureRecognizerState.Began:
            return "UIGestureRecognizerState.Began"
        case UIGestureRecognizerState.Changed:
            return "UIGestureRecognizerState.Changed"
        case UIGestureRecognizerState.Ended:
            return "UIGestureRecognizerState.Ended"
        case UIGestureRecognizerState.Cancelled:
            return "UIGestureRecognizerState.Cancelled"
        case UIGestureRecognizerState.Failed:
            return "UIGestureRecognizerState.Failed"
            //        case UIGestureRecognizerState.Recognized:
            //            return "UIGestureRecognizerState.Recognized"
            //        default:
            //            return "unkonwn"
        }
    }
}


class EventAndGestureDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonCount = 2;
        
        self.addButtonToView("GestureDemo", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { [unowned self] (button) in
            if let viewController = GestureDemo.newInstanceFromStoryboard("EventAndGestureDemo") {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        buttonCount += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
