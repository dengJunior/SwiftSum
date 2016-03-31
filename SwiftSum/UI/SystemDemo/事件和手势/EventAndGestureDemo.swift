//
//  EventAndGestureDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

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
