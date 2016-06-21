//
//  MainCollectionViewController.swift
//  SwiftSum
//
//  Created by sihuan on 16/4/7.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

// MARK: - 程序主控制器，启动程序、展示UI及计算UICollectionViewCell透明度的相关方法。
class MainCollectionViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let numberOfCell = 32
    var alphaArray = Array<CGFloat>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let runLoopSourceManager = RunLoopSourceManager.sharedInstance
        runLoopSourceManager.mainCollectionViewController = self
        
    }
    
    @IBAction func start(sender: AnyObject) {
        
        let mainThreadRunLoopSource = MainThreadRunLoopSource()
        
        mainThreadRunLoopSource.addToCurrentRunLoop()
        let secondaryThread = NSThread(target: self, selector: #selector(MainCollectionViewController.startThreadWithRunloop), object: nil)
        secondaryThread.start()
    }
    
    @IBAction func stop(sender: AnyObject) {
        RunLoopSourceManager.sharedInstance.stopSecondaryThreadRunloop()
    }
    
    // MARK: - Run in the secondary thread
    func startThreadWithRunloop() {
        autoreleasepool { 
            var done = false
            let secondaryThreadRunloopSource = SecondaryThreadRunLoopSource()
            /**
             *  当在二级线程中执行完secondaryThreadRunLoopSource.addToCurrentRunLoop()这句代码后，也会触发二级线程自定义事件源的schedule回调函数：
             */
            secondaryThreadRunloopSource.addToCurrentRunLoop()
            
            repeat {
                /*
                 第一个参数是Run Loop模式，
                 第二个参数仍然是超时时间，
                 第三个参数的意思是Run Loop是否在执行完任务后就退出，
                    如果设置为false，那么代表Run Loop在执行完任务后不退出，而是一直等到超时后才退出。
                 
                 该方法返回Run Loop的退出状态：
                 
                 CFRunLoopRunResult.Finished：表示Run Loop已分派执行完任务，并且再无任务执行的情况下退出。
                 CFRunLoopRunResult.Stopped：表示Run Loop通过CFRunLoopStop(_ rl: CFRunLoop!)函数强制退出。
                 CFRunLoopRunResult.TimedOut：表示Run Loop因为超时时间到而退出。
                 CFRunLoopRunResult.HandledSource：表示Run Loop已执行完任务而退出，改状态只有在returnAfterSourceHandled设置为true时才会出现。
                 */
                let result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, true)
                if result == CFRunLoopRunResult.Stopped ||
                    result == CFRunLoopRunResult.Finished {
                    done = true
                }
            } while(!done)
        }
    }
    
    func generateRandomAlpha() {
        alphaArray.removeAll()
        
        for _ in 0 ..< numberOfCell {
            let transparence = randomInRange(0...100)
            alphaArray.append(CGFloat(transparence) * 0.01)
        }
    }
    
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return Int(arc4random_uniform(count)) + range.startIndex
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfCell
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        cell.alpha = alphaArray.count != 0 ? alphaArray[indexPath.row] : 1
        
        return cell
        
    }

}
