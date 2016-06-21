//
//  HorizontalScroller.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

// MARK: - 适配器把自己封装起来然后暴露统一的接口给其他类，这样即使其他类的接口各不相同，也能相安无事，一起工作。

//如果你熟悉适配器模式，那么你会发现苹果在实现适配器模式的方式稍有不同：苹果通过委托实现了适配器模式。委托相信大家都不陌生。举个例子，如果一个类遵循了 NSCoying 的协议，那么它一定要实现 copy 方法。
protocol HorizontalScrollerDelegate: class {
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> UIView
    func horizontalScrollerClickedViewAtIndex(scroll: HorizontalScroller, index: Int)
    func initialViewIndex(scroller: HorizontalScroller) -> Int
}


class HorizontalScroller: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Const
    
    let ViewPadding = 10
    let ViewSize = 100
    let ViewOffset = 100
    
    let CellIdentifier = "CellIdentifier"
    
    // MARK: - Property
    
    weak var delegate: HorizontalScrollerDelegate? = nil

    private var scroller: UIScrollView!
    var viewArray = [UIView]()
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.setContext()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContext()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setContext()
    }
    
    func setContext() {
        scroller = UIScrollView()
        scroller.delegate = self
        addSubview(scroller)
        
        scroller.translatesAutoresizingMaskIntoConstraints = false
        scroller.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped))
        scroller.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
    }
    
    override func didMoveToSuperview() {
        reload()
    }
    
    // MARK: - Private
    
    func scrollerTapped(gesture: UITapGestureRecognizer) -> Void {
        let location = gesture.locationInView(gesture.view)
        
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                let view = scroller.subviews[index] 
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    scroller.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated:true)
                    break
                }
            }
        }
    }
    
    func reload() {
        if let delegate = delegate {
            viewArray = []
            let views = scroller.subviews
            for view in views {
                view.removeFromSuperview()
            }
            
            var xValue = ViewOffset
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                xValue += ViewPadding
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                view.frame = CGRect(x: xValue, y: ViewPadding, width: ViewSize, height: ViewSize)
                scroller.addSubview(view)
                
                xValue += ViewSize + ViewPadding
                viewArray.append(view)
            }
            
            scroller.contentSize = CGSize(width: xValue+ViewOffset, height: Int(frame.size.height))
            
            let initialViewIndex = delegate.initialViewIndex(self)
            scroller.setContentOffset(CGPoint(x: CGFloat(initialViewIndex)*CGFloat((ViewSize + (2 * ViewPadding))), y: 0), animated: true)
        }
    }
    
    func centerCurrentView() {
        var xFinal = Int(scroller.contentOffset.x) + (ViewOffset/2) + ViewPadding
        let viewIndex = xFinal / (ViewSize + (2*ViewSize))
        xFinal = viewIndex * (ViewSize + (2*ViewPadding))
        scroller.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        if let delegate = delegate {
            delegate.horizontalScrollerClickedViewAtIndex(self, index: Int(viewIndex))
        }
    }
    
    // MARK: - Public
    
    func viewAtIndex(index: Int) -> UIView {
        return viewArray[index]
    }
    
    // MARK: - Delegate
    
}

extension HorizontalScroller: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}



































