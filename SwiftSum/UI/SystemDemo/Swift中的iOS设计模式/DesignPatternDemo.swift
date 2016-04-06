//
//  DesignPatternDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class DesignPatternDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var buttonCount = 2;
        
        self.addButtonToView("一个音乐仓库Demo", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { [unowned self] (button) in
            if let viewController = MusicController.newInstanceFromStoryboard("Music") {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        buttonCount += 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
