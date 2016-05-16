//
//  PresentDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/13.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

class PresentDemo: UIViewController {
    
    let presentTransitionDelegate = YYPresentationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        var buttonCount = 1;
        
        buttonCount += 1
        self.addButtonToView("自定义present动画，正确的处理", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            let vc = TableViewController1()
            vc.modalPresentationStyle = .Custom
            // 设置动画代理，
            vc.transitioningDelegate = self.presentTransitionDelegate
            self.presentViewController(vc, animated: true, completion: {
                
            })
        }
        
        buttonCount += 1
        self.addButtonToView("Custom模式，会黑屏", frame: CGRect.init(x: 10, y: 40*buttonCount, width: 300, height: 40)) { [unowned self] (button) in
            /*
             1. FullScreen 模式：
             - presentation 结束后，presentingView 被主动移出视图结构，不过，在 dismissal 转场中希望其出现在屏幕上并且在对其添加动画怎么办呢？
             - 实际上，你按照容器类 VC 转场里动画控制器里那样做也没有问题，就是将其加入 containerView 并添加动画。
             - 不用担心，转场结束后，UIKit 会自动将其恢复到原来的位置。虽然背后的机制不一样，但这个模式下的 Modal 转场和容器类 VC 的转场的动画控制器的代码可以通用，你不必记住背后的差异。
             2. Custom 模式：
             - presentation 结束后，presentingView(fromView) 未被主动移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 presentingView(toView) 加入 containerView 中，否则 dismissal 结束后本来可见的 presentingView 将会随着 containerView 一起被移除。
             - <mark>如果你在 Custom 模式下没有注意到这点，很容易出现黑屏之类的现象而不知道问题所在。
             */
            self.presentDemo(.Custom)
        }
    }
}

extension PresentDemo: UIViewControllerTransitioningDelegate {
    func presentDemo(style: UIModalPresentationStyle) {
        let vc = TableViewController1()
        vc.modalPresentationStyle = style
        // 设置动画代理，
        vc.transitioningDelegate = self.presentTransitionDelegate
        self.presentViewController(vc, animated: true, completion: {
            
        })
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYPresentationAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YYPresentationAnimator()
    }
}
