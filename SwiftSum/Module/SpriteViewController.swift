//
//  ViewController.swift
//  SpriteWalkthrouch
//
//  Created by sihuan on 2016/6/23.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
import SpriteKit
import YYKit

class SpriteViewController: UIViewController {

    override func loadView() {
        view = SKView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSpriteView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setupSpriteView() {
        if let spriteView = view as? SKView {
            /**
             打开诊断信息，这些诊断信息描述了场景是怎样渲染视图的。
             最重要的代码段时帧率显示设置（spriteView.showFPS）。
             任何情况下你都希望游戏按照一个固定的帧率运行。
             其他的代码设置了要显示其他一些信息。
             */
            spriteView.showDiagnosticInfo()
            
            let hello = HelloScene(size: UIScreen.mainScreen().bounds.size)
            spriteView.presentScene(hello)
        }
    }


}

