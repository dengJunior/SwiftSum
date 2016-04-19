//
//  ViewGuideDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/18.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class ViewGuideDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = AutoresizingMaskDemo()
        view.center = self.view.center;
        self.view.addSubview(view)
        
        var buttonCount = 1;
        
        self.addButtonToView("改变view大小", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) {  (button) in
            var width = 180;
            if view.bounds.size.width == 180 {
                width = 300;
            }
            view.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        }
        buttonCount += 1
        
        self.addButtonToView("改变view的subView的mask", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) {  (button) in
            view.changeSubViewMask()
        }
        buttonCount += 1
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
