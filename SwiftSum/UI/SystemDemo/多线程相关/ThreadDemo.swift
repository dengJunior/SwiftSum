//
//  ThreadDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/6.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ThreadDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonCount = 2;
        
        self.addButtonToView("测试NSThread", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            let testThread = TestThread()
            testThread.launchWithNSThread()
        }
        buttonCount += 1

//        self.addButtonToView("RunLoopDemo", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
//            let viewController = RunLoopDemo()
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        buttonCount += 1

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
