//
//  GestureTestView.swift
//  SwiftSum
//
//  Created by sihuan on 16/3/31.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import SnapKit


class GestureTestView: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Const
    
    let HeightForCommonCell = 49
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    var dataArray = []

    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    func setContext() {
//        self.addSingleTapGesture()
        
        if let view = SimpleGestureRecognizers.newInstanceFromNib() {
            self.addSubview(view)
            view.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
                make.right.equalTo(0)
            })
        }
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print(#function)
    }
    
    // MARK: - Private
    
    func addSingleTapGesture() -> Void {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.singleTap))
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        self.addGestureRecognizer(singleTap);
    }
    
    func singleTap(tap: UITapGestureRecognizer) -> Void {
        print(#function)
    }
    
    // MARK: - Public
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        print(#function)
        return true
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        return true
    }
    

}


/**

 
 
 这3个属性是作用于GestureRecognizers(手势识别)与触摸事件之间联系的属性。
 
 在默认情况下（即这3个属性都处于默认值的情况下），如果触摸window，首先由window上最先符合条件的控件(该控件记为hit-test view)接收到该touch并触发触摸事件touchesBegan。同时如果某个控件的手势识别器接收到了该touch，就会进行识别。手势识别成功之后发送触摸事件touchesCancelled给hit-testview，hit-test view不再响应touch。
 
 1. BOOL cancelsTouchesInView;       // default is YES. 这种情况下当手势识别器识别到touch之后，会发送touchesCancelled给hit-testview以取消hit-test view对touch的响应，这个时候只有手势识别器响应touch。
 
 当设置成NO时，手势识别器识别到touch之后不会发送touchesCancelled给hit-test，这个时候手势识别器和hit-test view均响应touch。
 
 2. BOOL delaysTouchesBegan;         // default is NO.  正常情况下，窗口在Began 和 Moved 阶段把触摸对象发送给视图和手势识别器。 把delaysTouchesBegan设置为YES,使得窗口不会在Began阶段把触摸对象发送给视图。 这样做确保一个手势识别器识别它的手势时，没有把部分触摸事件传递给相连的视图。 设置该特性时请谨慎，因为它会使你的界面反应迟钝。
 
 @property(nonatomic) BOOL delaysTouchesEnded;         // default is YES. causes touchesEnded or pressesEnded events to be delivered to the target view only after this gesture has failed recognition. this ensures that a touch or press that is part of the gesture can be cancelled if the gesture is recognized
 
 
 @property(nonatomic, copy) NSArray<NSNumber *> *allowedTouchTypes NS_AVAILABLE_IOS(9_0); // Array of UITouchType's as NSNumbers.
 @property(nonatomic, copy) NSArray<NSNumber *> *allowedPressTypes NS_AVAILABLE_IOS(9_0); // Array of UIPressTypes as NSNumbers.
 
 // create a relationship with another gesture recognizer that will prevent this gesture's actions from being called until otherGestureRecognizer transitions to UIGestureRecognizerStateFailed
 // if otherGestureRecognizer transitions to UIGestureRecognizerStateRecognized or UIGestureRecognizerStateBegan then this recognizer will instead transition to UIGestureRecognizerStateFailed
 // example usage: a single tap may require a double tap to fail
 - (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer;
 
 // individual UIGestureRecognizer subclasses may provide subclass-specific location information. see individual subclasses for details
 - (CGPoint)locationInView:(nullable UIView*)view;                                // a generic single-point location for the gesture. usually the centroid of the touches involved
 
 - (NSUInteger)numberOfTouches;                                          // number of touches involved for which locations can be queried
 - (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view; // the location of a particular touch
 
 @end
 
 
 @protocol UIGestureRecognizerDelegate <NSObject>
 @optional
 
 // called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
 当一个手势在识别过程中，可能被其他手势阻塞时调用，
 返回YES，表示允许识别所有类似的手势，默认返回NO，
 
 需要注意，返回NO，不一定就能阻止类似的手势都被识别，因为，其他手势可能在它的代理方法中返回YES
 
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
 
 
 返回NO，不一定就有效，因为，其他手势可能在它的代理方法中返回YES
 //询问是否另外一个手势失败，这个手势才开始执行
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
 
 询问是否这个手势是通过一个指定手势的触发才失败
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
 
 
 
 
 在 pressesBegan:withEvent: 之前调用，表示手势识别器是否能继续接收新的UIPress，iOS9
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;
 
 @end
 
 */












