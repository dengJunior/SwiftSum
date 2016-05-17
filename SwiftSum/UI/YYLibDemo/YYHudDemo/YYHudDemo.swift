//
//  YYHudDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/11.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class YYHudDemo: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonCount = 1;
        
        buttonCount += 1
        self.addButtonToView("showLoading", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.showLoading(options: nil)
        }
        
        buttonCount += 1
        self.addButtonToView("showLoading text", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.showLoading(text: "showLoading", options: [.Dim])
        }
        
        buttonCount += 1
        self.addButtonToView("dismiss", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.dismiss()
        }
        
        buttonCount += 1
        self.addButtonToView("showSuccess", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.showSuccess(text: "showSuccess")
        }
        
        buttonCount += 1
        self.addButtonToView("showError", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.showError(text: "showError")
        }
        
        buttonCount += 1
        self.addButtonToView("showInfo", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.showInfo(text: "showInfo")
        }
        
        buttonCount += 1
        self.addButtonToView("showTip", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 200, height: 40)) { (button) in
            YYHud.showTip(text: "showTip")
        }

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
