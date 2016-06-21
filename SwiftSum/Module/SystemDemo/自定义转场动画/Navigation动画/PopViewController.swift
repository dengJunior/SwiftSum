//
//  PopViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/17.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - ## 实现交互化
/*
 在非交互转场的基础上将之交互化需要两个条件：
 
 - 由转场代理提供交互控制器，这是一个遵守<UIViewControllerInteractiveTransitioning>协议的对象，不过系统已经打包好了现成的类UIPercentDrivenInteractiveTransition供我们使用。我们不需要做任何配置，仅仅在转场代理的相应方法中提供一个该类实例便能工作。
	- 另外交互控制器必须有动画控制器才能工作。
 - 交互控制器还需要交互手段的配合，最常见的是使用手势，或是其他事件，来驱动整个转场进程。
 */
class PopViewController: UIViewController {
    //演示如何利用屏幕边缘滑动手势UIScreenEdgePanGestureRecognizer在 NavigationController 中控制 Slide 动画控制器提供的动画来实现右滑返回的效果
    
    let edgePanGesture = UIScreenEdgePanGestureRecognizer()
    var navigationDelegate = YYNavigationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "stackTop"
        edgePanGesture.edges = .Left
        edgePanGesture.addTarget(self, action: #selector(handleEdgePanGesture(_:)))
        view.addGestureRecognizer(edgePanGesture)
        
        view.backgroundColor = UIColor.greenColor()
        self.navigationController?.delegate = navigationDelegate
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //只在处于交互转场过程中才可能取消效果。
        if let coordinator = self.transitionCoordinator() where coordinator.initiallyInteractive() == true {
            //UIViewController 可以通过transitionCoordinator()获取转场协调器，该方法的文档中说只有在 Modal 转场过程中，该方法才返回一个与当前转场相关的有效对象。实际上，NavigationController 的转场中 fromVC 和 toVC 也能返回一个有效对象，TabBarController 有点特殊，fromVC 和 toVC 在转场中返回的是 nil，但是作为容器的 TabBarController 可以使用该方法返回一个有效对象。
            coordinator.notifyWhenInteractionEndsUsingBlock({ (controllerTransitionCoordinatorContext) in
                if controllerTransitionCoordinatorContext.isCancelled() {
                    //当转场由交互状态转变为非交互状态(在手势交互过程中则为手势结束时)，无论转场的结果是完成还是被取消，该方法都会被调用；
                    print("notifyWhenInteractionEndsUsingBlock over")
                }
            })
        }
    }
    
    func handleEdgePanGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        let translationX = gesture.translationInView(view).x
        let translationBase: CGFloat = view.frame.width / 3
        let translationAbs = translationX > 0 ? translationX : -translationX
        let percent = min(1.0, translationAbs / translationBase)//根据移动距离计算交互过程的进度。
        
        switch gesture.state {
        case .Began:
            //一旦转场开始，VC 将脱离控制器栈，此后 self.navigationController 返回的是 nil。
            navigationDelegate.interactive = true
            
            //1.交互控制器没有 start 之类的方法，当下面这行代码执行后，转场开始；
            //如果转场代理提供了交互控制器，它将从这时候开始接管转场过程。
            self.navigationController?.popViewControllerAnimated(true)
            
        case .Changed:
            //2.更新进度：
            navigationDelegate.interactionController.updateInteractiveTransition(percent)
        case .Ended, .Cancelled:
            //3.结束转场：
            percent > 0.5 ? navigationDelegate.interactionController.finishInteractiveTransition() : navigationDelegate.interactionController.cancelInteractiveTransition()
            navigationDelegate.interactive = false
        default:
            navigationDelegate.interactionController.cancelInteractiveTransition()
            navigationDelegate.interactive = false
        }
    }
    
    // MARK: - 转场交互化后结果
    /**
     转场交互化后结果有两种：完成和取消。取消后动画将会原路返回到初始状态，但已经变化了的数据怎么恢复？
     
     一种情况是，控制器的系统属性，比如，在 TabBarController 里使用上面的方法实现滑动切换 Tab 页面，中途取消的话，已经变化的selectedIndex属性该怎么恢复为原值；
     上面的代码里，取消转场的代码执行后，self.navigationController返回的依然还是是 nil，怎么让控制器回到 NavigationController 的控制器栈顶。对于这种情况，UIKit 自动替我们恢复了，不需要我们操心(可能你都没有意识到这回事)；
     
     另外一种就是，转场发生的过程中，你可能想实现某些效果，一般是在下面的事件中执行，转场中途取消的话可能需要取消这些效果。
     
     ```
     func viewWillAppear(_ animated: Bool)
     func viewDidAppear(_ animated: Bool)
     func viewWillDisappear(_ animated: Bool)
     func viewDidDisappear(_ animated: Bool)
     ```
     交互转场介入后，视图在这些状态间的转换变得复杂，<mark>WWDC 上苹果的工程师还表示转场过程中 view 的Will系方法和Did系方法的执行顺序并不能得到保证，虽然几率很小，但如果你依赖于这些方法执行的顺序的话就可能需要注意这点。而且，Did系方法调用时并不意味着转场过程真的结束了。另外，fromView 和 toView 之间的这几种方法的相对顺序更加混乱，具体的案例可以参考这里：[The Inconsistent Order of View Transition Events。](http://wangling.me/2014/02/the-inconsistent-order-of-view-transition-events.html)
     */
    
    @IBAction func popMe(sender: AnyObject) {
        print(self.navigationController!.view)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    deinit{
        edgePanGesture.removeTarget(self, action: #selector(PopViewController.handleEdgePanGesture(_:)))
    }
}





























