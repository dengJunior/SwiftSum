//
//  PhotoManager.swift
//  SwiftSum
//
//  Created by sihuan on 16/5/24.
//  Copyright © 2016年 sihuan. All rights reserved.
//

import UIKit
import YYKit

/// Notification when new photo instances are added
let PhotoManagerAddedContentNotification = "com.raywenderlich.GooglyPuff.PhotoManagerAddedContent"
/// Notification when content updates (i.e. Download finishes)
let PhotoManagerContentUpdateNotification = "com.raywenderlich.GooglyPuff.PhotoManagerContentUpdate"

typealias PhotoProcessingProgressClosure = (completionPercentage: CGFloat) -> Void
typealias BatchPhotoDownloadingCompletionClosure = (error: NSError?) -> Void

class PhotoManager: NSObject {
    static let sharedManager = PhotoManager()
    
    // MARK: - 临界资源，读写问题
    
    // create read-only stored property https://books.google.com/books?id=Dq3TBQAAQBAJ&pg=PT200&lpg=PT200&dq=private+var+underscore+swift&source=bl&ots=XLknAbsDCv&sig=1BFc4NVNyUgbXdChpMYlexvn0Q0&hl=en&sa=X&ved=0CFIQ6AEwCGoVChMIu8z6oJbWyAIVDBo-Ch3VzA27#v=onepage&q=private%20var%20underscore%20swift&f=false
    private var _photos = [Photo]()
    
    /*
     创建一个自己的队列去处理你的障碍函数并分开读和写函数。
     所有的调度队列（dispatch queues）自身都是线程安全的，你能从多个线程并行的访问它们。
     */
    private let concurrentPhotoQueue = dispatch_queue_create("com.raywenderlich.GooglyPuff.photoQueue", DISPATCH_QUEUE_CONCURRENT)
    
    // MARK: - 处理读者与写者问题
    
    /**
     在写者打扰的情况下，要确保线程安全，你需要在 concurrentPhotoQueue 队列上执行读操作。
     既然你需要从函数返回，你就不能异步调度到队列，因为那样在读者函数返回之前不一定运行。在这种情况下，dispatch_sync 就是一个绝好的候选。
     
     dispatch_sync() 同步地提交工作并在返回前等待它完成。使用 dispatch_sync 跟踪你的调度障碍工作，或者当你需要等待操作完成后才能使用 Block 处理过的数据。如果你使用第二种情况做事，你将不时看到一个 __block 变量写在 dispatch_sync 范围之外，以便返回时在 dispatch_sync 使用处理过的对象。
     
     注意：如果你调用 dispatch_sync 并放在你已运行着的当前队列。这会导致死锁，因为调用会一直等待直到 Block 完成，但 Block 不能完成（它甚至不会开始！），直到当前已经存在的任务完成，而当前任务无法完成！这将迫使你自觉于你正从哪个队列调用——以及你正在传递进入哪个队列。
     
     下面是一个快速总览，关于在何时以及何处使用 dispatch_sync ：
     1. 自定义串行队列：在这个状况下要非常小心！如果你正运行在一个队列并调用 dispatch_sync 放在同一个队列，那你就百分百地创建了一个死锁。
     2. 主队列（串行）：同上面的理由一样，必须非常小心！这个状况同样有潜在的导致死锁的情况。
     3. 并发队列：这才是做同步工作的好选择，不论是通过调度障碍，或者需要等待一个任务完成才能执行进一步处理的情况。
     */
    
    var photos: [Photo] {
        var photoCopy: [Photo]!
        // 在 concurrentPhotoQueue 上同步调度来执行读操作。
        dispatch_sync(concurrentPhotoQueue) {
            photoCopy = self._photos
        }
        return photoCopy
    }
    
    /**
     GCD 通过用 dispatch barriers 创建一个读者写者锁 提供了一个优雅的解决方案。
     
     下面是你何时会——和不会——使用障碍函数的情况：
     1. 自定义串行队列：一个很坏的选择；障碍不会有任何帮助，因为不管怎样，一个串行队列一次都只执行一个操作。
     2. 全局并发队列：要小心；这可能不是最好的主意，因为其它系统可能在使用队列而且你不能垄断它们只为你自己的目的。
     3. 自定义并发队列：这对于原子或临界区代码来说是极佳的选择。任何你在设置或实例化的需要线程安全的事物都是使用障碍的最佳候选。
     */
    func addPhoto(photo: Photo) {
        //线程安全的实现
        
        //1. 添加写操作到你的自定义队列。当临界区在稍后执行时，这将是你队列中唯一执行的条目。
        dispatch_barrier_async(concurrentPhotoQueue) {
            //2. 这是添加对象到数组的实际代码。由于它是一个障碍 Block ，这个 Block 永远不会同时和其它 Block 一起在 concurrentPhotoQueue 中执行。
            self._photos.append(photo)
            
            //3. 最后你发送一个通知说明完成了添加图片。这个通知将在主线程被发送因为它将会做一些 UI 工作，所以在此为了通知，你异步地调度另一个任务到主线程。
            YYGCD.dispatchInMainQueue {
                self.postContentAddedNotification()
            }
        }
    }
    
    private func postContentAddedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(PhotoManagerAddedContentNotification, object: nil)
    }
    
    var storedError: NSError?
    
    let OverlyAttachedGirlfriendURLString = "http://i.imgur.com/UvqEgCv.png"
    let SuccessKidURLString = "http://i.imgur.com/dZ5wRtb.png"
    let LotsOfFacesURLString = "http://i.imgur.com/tPzTg7A.jpg"
}

// MARK: - 错误的实现
extension PhotoManager {
    func downloadPhotosCompletionError(completion: BatchPhotoDownloadingCompletionClosure) {
        var addresses = [OverlyAttachedGirlfriendURLString,
                         SuccessKidURLString,
                         LotsOfFacesURLString]
        
        for i in 0 ..< addresses.count {
            let url = NSURL(string: addresses[i])
            let photo = DownloadPhoto(url: url!, completion: { (image, error) in
                if let error = error {
                    self.storedError = error
                }
            })
            PhotoManager.sharedManager.addPhoto(photo)
        }
        
        completion(error: storedError)
        /**
         这里调用了 completionBlock —— 因为此时你假设所有的照片都已下载完成。但很不幸，此时并不能保证所有的下载都已完成。
         
         Photo 类的实例方法用某个 URL 开始下载某个文件并立即返回，但此时下载并未完成。换句话说，当 downloadPhotoWithCompletionBlock: 在其末尾调用 completionBlock 时，它就假设了它自己所使用的方法全都是同步的，而且每个方法都完成了它们的工作。
         
         然而，-[Photo initWithURL:withCompletionBlock:] 是异步执行的，会立即返回——所以这种方式行不通。
         
         因此，只有在所有的图像下载任务都调用了它们自己的 Completion Block 之后，downloadPhotoWithCompletionBlock: 才能调用它自己的 completionBlock 。
         
         问题是：你该如何监控并发的异步事件？你不知道它们何时完成，而且它们完成的顺序完全是不确定的。
         
         幸运的是，解决这种对多个异步任务的完成进行监控的问题，恰好就是设计 dispatch_group 的目的。
         */
    }
}

// MARK: - 正确的实现 Dispatch Groups（调度组）

/**
 Dispatch Group 会在整个组的任务都完成时通知你。这些任务可以是同步的，也可以是异步的，即便在不同的队列也行。而且在整个组的任务都完成时，Dispatch Group 可以用同步的或者异步的方式通知你。因为要监控的任务在不同队列，那就用一个 dispatch_group_t 的实例来记下这些不同的任务。
 
 当组中所有的事件都完成时，GCD 的 API 提供了两种通知方式。
 
 第一种是 dispatch_group_wait ，它会阻塞当前线程，直到组里面所有的任务都完成或者等到某个超时发生。这恰好是你目前所需要的。
 
 在我们转向另外一种使用 Dispatch Group 的方式之前，先看一个简要的概述，关于何时以及怎样使用有着不同的队列类型的 Dispatch Group ：
 1. 自定义串行队列：它很适合当一组任务完成时发出通知。
 2. 主队列（串行）：它也很适合这样的情况。但如果你要同步地等待所有工作地完成，那你就不应该使用它，因为你不能阻塞主线程。然而，异步模型是一个很有吸引力的能用于在几个较长任务（例如网络调用）完成后更新 UI 的方式。
 3. 并发队列：它也很适合 Dispatch Group 和完成时通知。
 */

extension PhotoManager {
    // MARK: Dispatch Group，第一种方式
    func downloadPhotosCompletion1(completion: BatchPhotoDownloadingCompletionClosure) {
        var addresses = [OverlyAttachedGirlfriendURLString,
                         SuccessKidURLString,
                         LotsOfFacesURLString]
        
        //1. 因为使用的是同步的 dispatch_group_wait ，它会阻塞当前线程，所以你要用 dispatch_async 将整个方法放入后台队列以避免阻塞主线程。
        YYGCD.dispatchInGlobalQueue {
            //2. 创建一个新的 Dispatch Group，它的作用就像一个用于未完成任务的计数器。
            let downloadGroup = YYGCDGroup()
            
            for i in 0 ..< addresses.count {
                let url = NSURL(string: addresses[i])
                
                //3. dispatch_group_enter 手动通知 Dispatch Group 任务已经开始。你必须保证 dispatch_group_enter 和 dispatch_group_leave 成对出现，否则你可能会遇到诡异的崩溃问题。
                downloadGroup.enter()
                let photo = DownloadPhoto(url: url!, completion: { (image, error) in
                    if let error = error {
                        self.storedError = error
                    }
                    //4. 手动通知 Group 它的工作已经完成。再次说明，你必须要确保进入 Group 的次数和离开 Group 的次数相等。
                    downloadGroup.leave()
                })
                PhotoManager.sharedManager.addPhoto(photo)
            }
            
            //5. dispatch_group_wait 会一直等待，直到任务全部完成或者超时。如果在所有任务完成前超时了，该函数会返回一个非零值。你可以对此返回值做条件判断以确定是否超出等待周期；然而，你在这里用 DISPATCH_TIME_FOREVER 让它永远等待。它的意思，勿庸置疑就是，永－远－等－待！这样很好，因为图片的创建工作总是会完成的。
            downloadGroup.waitForever()
            
            YYGCD.dispatchInMainQueue {
                //6. 此时此刻，你已经确保了，要么所有的图片任务都已完成，要么发生了超时。然后，你在主线程上运行 completionBlock 回调。这会将工作放到主线程上，并在稍后执行。
                completion(error: self.storedError)
            }
        }
    }
    
    // MARK: Dispatch Group，第二种方式
    
    //上面的一切都很好，但在另一个队列上异步调度然后使用 dispatch_group_wait 来阻塞实在显得有些笨拙。是的，还有另一种方式……
    func downloadPhotosCompletion2(completion: BatchPhotoDownloadingCompletionClosure) {
        var addresses = [OverlyAttachedGirlfriendURLString,
                         SuccessKidURLString,
                         LotsOfFacesURLString]
        let downloadGroup = YYGCDGroup()
        
        for i in 0 ..< addresses.count {
            let url = NSURL(string: addresses[i])
            
            //同样的 enter 方法，没做任何修改。
            downloadGroup.enter()
            let photo = DownloadPhoto(url: url!, completion: { (image, error) in
                if let error = error {
                    self.storedError = error
                }
                // 3同样的 leave 方法，也没做任何修改。
                downloadGroup.leave()
            })
            PhotoManager.sharedManager.addPhoto(photo)
        }
        
        //4. dispatch_group_notify 以异步的方式工作。当 Dispatch Group 中没有任何任务时，它就会执行其代码，那么 completionBlock 便会运行。你还指定了运行 completionBlock 的队列，此处，主队列就是你所需要的。
        downloadGroup.notifyInMainQueue { 
            completion(error: self.storedError)
        }
    }
    
    // MARK: iOS8特有方式 CANCELLING DISPATCH BLOCKS-new for iOS8
    func downloadPhotosCompletion(completion: BatchPhotoDownloadingCompletionClosure) {
        var addresses = [OverlyAttachedGirlfriendURLString,
                         SuccessKidURLString,
                         LotsOfFacesURLString]
        //6个任务
        addresses += addresses
        let downloadGroup = YYGCDGroup()
        
        //保存block，稍后使用
        var blocks: [dispatch_block_t] = []
        
        for i in 0 ..< addresses.count {
            
            //enter 方法，在外面
            downloadGroup.enter()
            
            // creates a new block object
            // first parameter is a flag defining various block traits
            // flag used here makes the block inherit its QoS class from the queue it is dispatched to
            let block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
                let url = NSURL(string: addresses[i])
                let photo = DownloadPhoto(url: url!, completion: { (image, error) in
                    if let error = error {
                        self.storedError = error
                    }
                    // 同样的 leave 方法，也没做任何修改。
                    downloadGroup.leave()
                })
                
                PhotoManager.sharedManager.addPhoto(photo)
            }
            
            blocks.append(block)
            //将block放到主线程中执行
            YYGCD.dispatchInMainQueue(task: block)
        }
        
        if let lastBlock = blocks.last {
            /**
             将最后一个block取消掉
             注意，在执行中的block是不能取消的，所以这里只取消最后一个
             */
            dispatch_block_cancel(lastBlock)
            
            //注意，取消了一个block，还需要把它从group中移除
            downloadGroup.leave()
        }
        
        //同样的dispatch_group_notify
        downloadGroup.notifyInMainQueue {
            completion(error: self.storedError)
        }
    }
}

// MARK: - 太多并发带来的风险

/**
 看看 PhotoManager 中的 downloadPhotosWithCompletionBlock 方法。你可能已经注意到这里的 for 循环，它迭代三次，下载三个不同的图片。你的任务是尝试让 for 循环并发运行，以提高其速度。
 dispatch_apply 刚好可用于这个任务。
 
 dispatch_apply 表现得就像一个 for 循环，但它能并发地执行不同的迭代。这个函数是同步的，所以和普通的 for 循环一样，它只会在所有工作都完成后才会返回。
 
 当在 Block 内计算任何给定数量的工作的最佳迭代数量时，必须要小心，因为过多的迭代和每个迭代只有少量的工作会导致大量开销以致它能抵消任何因并发带来的收益。而被称为跨越式（striding）的技术可以在此帮到你，即通过在每个迭代里多做几个不同的工作。
 
 译者注：大概就能减少并发数量吧，作者是提醒大家注意并发的开销，记在心里！
 */

// MARK: - dispatch_apply注意事项

/**
 实际上，在这个例子里并不值得。下面是原因：
 
 1. 你创建并行运行线程而付出的开销，很可能比直接使用 for 循环要多。若你要以合适的步长迭代非常大的集合，那才应该考虑使用 dispatch_apply。
 2. 你用于创建应用的时间是有限的——除非实在太糟糕否则不要浪费时间去提前优化代码。如果你要优化什么，那去优化那些明显值得你付出时间的部分。你可以通过在 Instruments 里分析你的应用，找出最长运行时间的方法。看看 如何在 Xcode 中使用 Instruments 可以学到更多相关知识。
 3. 通常情况下，优化代码会让你的代码更加复杂，不利于你自己和其他开发者阅读。请确保添加的复杂性能换来足够多的好处。
 
 记住，不要在优化上太疯狂。你只会让你自己和后来者更难以读懂你的代码。
 */













