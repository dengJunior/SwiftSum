//
//  AnimationsDemo.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/19.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

func DegreesToRadians(degrees: Double) -> Double {
    return degrees * M_PI / 180.0;
}
class AnimationsDemo: NSObject {
    func launch() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.alpha = 0.1;
        view.backgroundColor = UIColor.redColor()
        
        let view2 = UIView(frame: CGRect(x: 25, y: 25, width: 50, height: 30))
        view2.backgroundColor = UIColor.greenColor()
        view.addSubview(view2)
        
        if let keyWindow = UIApplication.sharedApplication().keyWindow {
            keyWindow.addSubview(view)
            
            /**
             UIViewAnimationOptionLayoutSubviews //提交动画的时候布局子控件，表示子控件将和父控件一同动画。
             
             UIViewAnimationOptionAllowUserInteraction //动画时允许用户交流，比如触摸
             
             //使用该方法来立即停止所有先前的动画并在停止点启动各种新的动画。如果你给该方法传递NO，而不是YES，新动画直到以前的动画停止后才开始执行。
             UIViewAnimationOptionBeginFromCurrentState //从当前状态开始动画
             
             UIViewAnimationOptionRepeat //动画无限重复
             UIViewAnimationOptionAutoreverse //执行动画回路,前提是设置动画无限重复
             
             UIViewAnimationOptionOverrideInheritedDuration //忽略外层动画嵌套的执行时间
             
             UIViewAnimationOptionOverrideInheritedCurve //忽略外层动画嵌套的时间变化曲线
             
             UIViewAnimationOptionAllowAnimatedContent //通过改变属性和重绘实现动画效果，如果key没有提交动画将使用快照
             
             UIViewAnimationOptionShowHideTransitionViews //用显隐的方式替代添加移除图层的动画效果
             
             UIViewAnimationOptionOverrideInheritedOptions //忽略嵌套继承的选项
             
             //设置动画的时间曲线(timing curve)。 该值控制动画是被线性执行还是在特定时候改变速度。
             UIViewAnimationOptionCurveEaseInOut //时间曲线函数，由慢到快
             UIViewAnimationOptionCurveEaseIn //时间曲线函数，由慢到特别快
             UIViewAnimationOptionCurveEaseOut //时间曲线函数，由快到慢
             UIViewAnimationOptionCurveLinear //时间曲线函数，匀速
             
             //转场动画相关的
             
             UIViewAnimationOptionTransitionNone //无转场动画
             
             UIViewAnimationOptionTransitionFlipFromLeft //转场从左翻转
             
             UIViewAnimationOptionTransitionFlipFromRight //转场从右翻转
             
             UIViewAnimationOptionTransitionCurlUp //上卷转场
             
             UIViewAnimationOptionTransitionCurlDown //下卷转场
             
             UIViewAnimationOptionTransitionCrossDissolve //转场交叉消失
             
             UIViewAnimationOptionTransitionFlipFromTop //转场从上翻转
             
             UIViewAnimationOptionTransitionFlipFromBottom //转场从下翻转
             */
            UIView.animateWithDuration(1, delay: 0, options: [
                UIViewAnimationOptions.CurveEaseIn,
                UIViewAnimationOptions.CurveEaseOut,
                UIViewAnimationOptions.LayoutSubviews,
                UIViewAnimationOptions.Repeat
                ], animations: {
                    
                    //下面是可以动画的属性
                    view.frame = CGRect(x: 100, y:400, width: 80, height: 200)
                    view.center = keyWindow.center
                    view.bounds = CGRect(x: 0, y: 0, width: 200, height: 120)
                    view.backgroundColor = UIColor.blueColor()
                    view.alpha = 1;
                    
                    /**
                     CGAffineTransformMakeRotation( )貌似指定的是绝对角度，90度和360+90度是一个位置，输入450度不会导致转一圈又1/4圈，仅以最小角度旋转至指定位置就停
                     所以180和-180度也是一个位置，符号没有表示方向信息，系统逆时针选择。
                     */
                    /**
                     //这样写，后面会覆盖前面
                     view.transform = CGAffineTransformMakeRotation(CGFloat(DegreesToRadians(180.1)))
                     view.transform = CGAffineTransformMakeScale(2, 2)
                     
                     下面的写法，可以一起动画，缩放同时旋转
                     */
                    
                    view.transform = CGAffineTransformRotate(view.transform, CGFloat(DegreesToRadians(180.1)))
                    view.transform = CGAffineTransformScale(view.transform, 2, 2)
                    
                    //                view.contentStretch deprecated
                    
                    
                    /*同时设置CALayer和view往相反的方向旋转
                     动画在顺时针旋转层的同时逆时针旋转视图。因为旋转方向相反，层相对于屏幕保持其初始方向，不会发生显著旋转。 然而，在那个层之下的视图旋转了360度，返回到它的初始方向。
                     */
                    let layerAnimation = CABasicAnimation(keyPath: "transform")
                    layerAnimation.duration = 2
                    layerAnimation.beginTime = 0
                    layerAnimation.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
                    layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                    layerAnimation.fromValue = NSNumber(double: 0)
                    layerAnimation.toValue = NSNumber(double: DegreesToRadians(360))
                    layerAnimation.byValue = NSNumber(double: DegreesToRadians(180))
                    view.layer.addAnimation(layerAnimation, forKey: "layerAnimation")
                    
                    /**
                     通过嵌套额外的动画块给一个动画的各个部分分配不同的时间(timing)和配置选项
                     嵌套的动画跟父动画同时启动，默认情况下，嵌套动画继承了父类的持续时间以及动画曲线。
                     */
                    
                    
                }, completion: { (finished) in
//                    view.removeFromSuperview()
            })
        }
    }
    
    /**
     *  发起一个视图的过渡动画。
     传递给该方法的动画块里，发生的改变只跟动画显示，隐藏，添加或删除子视图等相关的通常行为。
     把动画限制在该行为集允许视图创建视图的前一个版本和后一个版本的快照图片，然后动画这两张图片，这样更有效率。
     然而，如果你需要动画其它改变，你可以在调用该方法时包含UIViewAnimationOptionAllowAnimatedContent 选项。包含此选项阻止视图创建快照并直接动画所有改变。
     */
    func transitionTest() {
        /**
         *  举个例子，新建一个 someView，然后 someView 左上角添加一个 view1，红色背景色。
         右下角添加蓝色背景色的 view2，然后对 someView 做过渡动画，动画类型为 UIViewAnimationOptionTransitionFlipFromBottom
         */
        if let keyWindow = UIApplication.sharedApplication().keyWindow {
            let view = UIView(frame: CGRect(x: 20, y: 40, width: 100, height: 100))
            view.alpha = 1;
            view.backgroundColor = UIColor.greenColor()
            keyWindow.addSubview(view)
            
            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            view1.alpha = 0
            view1.backgroundColor = UIColor.redColor()
            view.addSubview(view1)
            
            let view2 = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
            view2.backgroundColor = UIColor.blueColor()
            view.addSubview(view2)
            
            UIView.transitionWithView(view, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
                view2.alpha = 0
                view.center = keyWindow.center
                view1.alpha = 1
                }, completion: { (finished) in
                    view.removeFromSuperview()
            })
        }
        /**
         *  UIView 还提供了一个过渡 API：
         
         + (void)transitionFromView:(UIView *)fromView
         toView:(UIView *)toView
         duration:(NSTimeInterval)duration
         options:(UIViewAnimationOptions)options
         completion:(void (^ __nullable)(BOOL finished))completion
         这是一个便捷的视图过渡 API，在动画过程中，首先将 fromView 从父视图中删除，然后将 toView 添加，就是做了一个替换操作。
         */
    }
    
}



























