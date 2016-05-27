//
//  YYRunLoop.m
//  SwiftSum
//
//  Created by sihuan on 16/4/10.
//  Copyright © 2016年 sihuan. All rights reserved.
//

#import "YYRunLoop.h"
#import <CoreFoundation/CoreFoundation.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>


/**
 *  RunLoop 与线程的关系
 首先，iOS 开发中能遇到两个线程对象: pthread_t 和 NSThread。过去苹果有份文档标明了 NSThread 只是 pthread_t 的封装，但那份文档已经失效了，现在它们也有可能都是直接包装自最底层的 mach thread。
 
 苹果并没有提供这两个对象相互转换的接口，但不管怎么样，可以肯定的是 pthread_t 和 NSThread 是一一对应的。比如，你可以通过 pthread_main_thread_np() 或 [NSThread mainThread] 来获取主线程；也可以通过 pthread_self() 或 [NSThread currentThread] 来获取当前线程。CFRunLoop 是基于 pthread 来管理的。
 
 苹果不允许直接创建 RunLoop，它只提供了两个自动获取的函数：CFRunLoopGetMain() 和 CFRunLoopGetCurrent()。 这两个函数内部的逻辑大概是下面这样:
 */


/**
 
 /// 全局的Dictionary，key 是 pthread_t， value 是 CFRunLoopRef
 static CFMutableDictionaryRef loopsDic;
 /// 访问 loopsDic 时的锁, CFSpinLock_t
 static OSSpinLock loopsLock;
 
 /// 获取一个 pthread 对应的 RunLoop。
 CFRunLoopRef _CFRunLoopGet(pthread_t thread) {
 OSSpinLockLock(&loopsLock);
 
 if (!loopsDic) {
 // 第一次进入时，初始化全局Dic，并先为主线程创建一个 RunLoop。
 loopsDic = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
 CFRunLoopRef mainLoop = _CFRunLoopGet(pthread_main_thread_np());
 CFDictionarySetValue(loopsDic, pthread_main_thread_np(), mainLoop);
 }
 /// 直接从 Dictionary 里获取。
 CFRunLoopRef loop = CFDictionaryGetValue(loopsDic, thread);
 
 //线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。
 if (!loop) {
 /// 取不到时，创建一个
 loop = _CFRunLoopCreate();
 CFDictionarySetValue(loopsDic, thread, loop);
 /// 注册一个回调，当线程销毁时，顺便也销毁其对应的 RunLoop。
 _CFSetTSD(..., thread, loop, __CFFinalizeRunLoop);
 }
 
 OSSpinLockUnLock(&loopsLock);
 return loop;
 }
 
 CFRunLoopRef CFRunLoopGetMain() {
 return _CFRunLoopGet(pthread_main_thread_np());
 }
 
 CFRunLoopRef CFRunLoopGetCurrent() {
 return _CFRunLoopGet(pthread_self());
 }
 
 *  从上面的代码可以看出:
 
 1. 线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。
 2. 线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。
 3. RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。
 4. 你只能在一个线程的内部获取其 RunLoop（主线程除外）。
 */

//typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
//    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
//    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
//    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
//    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
//    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
//};

struct _CFRunLoopMode {
    CFStringRef _name;          // Mode Name, 例如 @"kCFRunLoopDefaultMode"
    CFMutableSetRef _source0;
    CFMutableSetRef _source1;
    CFMutableArrayRef _observers;
    CFMutableArrayRef _timers;
};

struct _CFRunLoop {
    CFMutableSetRef _commonModes;
    CFMutableSetRef _commonModeItems;
    struct _CFRunLoopMode _currentMode;
    CFMutableSetRef _modes;
};

//CFRunLoop对外暴露的管理 Mode 接口只有下面2个:
//CFRunLoopAddCommonMode(CFRunLoopRef runloop, CFStringRef modeName);
//CFRunLoopRunInMode(CFStringRef modeName, ...)

//Mode 暴露的管理 mode item 的接口有下面几个：
//CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
//CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
//CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
//CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFStringRef modeName);
//CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFStringRef modeName);
//CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFStringRef mode);
/**
 *  只能通过 mode name 来操作内部的 mode，当你传入一个新的 mode name 但 RunLoop 内部没有对应 mode 时，RunLoop会自动帮你创建对应的 CFRunLoopModeRef。对于一个 RunLoop 来说，其内部的 mode 只能增加不能删除。
 
 苹果公开提供的 Mode 有两个：kCFRunLoopDefaultMode (NSDefaultRunLoopMode) 
 和 UITrackingRunLoopMode，你可以用这两个 Mode Name 来操作其对应的 Mode。
 
 同时苹果还提供了一个操作 Common 标记的字符串：kCFRunLoopCommonModes (NSRunLoopCommonModes)，
 你可以用这个字符串来操作 Common Items，或标记一个 Mode 为 "Common"。使用时注意区分这个字符串和其他 mode name。
 */

#pragma mark - RunLoop 的内部逻辑

/**
 /// 用DefaultMode启动
 void CFRunLoopRun(void) {
 CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
 }
 
 /// 用指定的Mode启动，允许设置RunLoop超时时间
 int CFRunLoopRunInMode(CFStringRef modeName, CFTimeInterval seconds, Boolean stopAfterHandle) {
 return CFRunLoopRunSpecific(CFRunLoopGetCurrent(), modeName, seconds, returnAfterSourceHandled);
 }
 
 /// RunLoop的实现
 int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {
 
 /// 首先根据modeName找到对应mode
 CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
 /// 如果mode里没有source/timer/observer, 直接返回。
 if (__CFRunLoopModeIsEmpty(currentMode)) return;
 
 /// 1. 通知 Observers: RunLoop 即将进入 loop。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
 
 /// 内部函数，进入loop
 __CFRunLoopRun(runloop, currentMode, seconds, returnAfterSourceHandled) {
 
 Boolean sourceHandledThisLoop = NO;
 int retVal = 0;
 do {
 
 /// 2. 通知 Observers: RunLoop 即将触发 Timer 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
 /// 3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 4. RunLoop 触发 Source0 (非port) 回调。
 sourceHandledThisLoop = __CFRunLoopDoSources0(runloop, currentMode, stopAfterHandle);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
 if (__Source0DidDispatchPortLastTime) {
 Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
 if (hasMsg) goto handle_msg;
 }
 
 /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
 if (!sourceHandledThisLoop) {
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
 }
 
 /// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
 /// • 一个基于 port 的Source 的事件。
 /// • 一个 Timer 到时间了
 /// • RunLoop 自身的超时时间到了
 /// • 被其他什么调用者手动唤醒
 __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
 mach_msg(msg, MACH_RCV_MSG, port); // thread wait for receive msg
 }
 
 /// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
 
 /// 收到消息，处理消息。
 handle_msg:
 
 /// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
 if (msg_is_timer) {
 __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
 }
 
 /// 9.2 如果有dispatch到main_queue的block，执行block。
 else if (msg_is_dispatch) {
 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
 }
 
 /// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
 else {
 CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
 sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
 if (sourceHandledThisLoop) {
 mach_msg(reply, MACH_SEND_MSG, reply);
 }
 }
 
 /// 执行加入到Loop的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 
 if (sourceHandledThisLoop && stopAfterHandle) {
 /// 进入loop时参数说处理完事件就返回。
 retVal = kCFRunLoopRunHandledSource;
 } else if (timeout) {
 /// 超出传入参数标记的超时时间了
 retVal = kCFRunLoopRunTimedOut;
 } else if (__CFRunLoopIsStopped(runloop)) {
 /// 被外部调用者强制停止了
 retVal = kCFRunLoopRunStopped;
 } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
 /// source/timer/observer一个都没有了
 retVal = kCFRunLoopRunFinished;
 }
 
 /// 如果没超时，mode里没空，loop也没被停止，那继续loop。
 } while (retVal == 0);
 }
 
 /// 10. 通知 Observers: RunLoop 即将退出。
 __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
 }
 */

#pragma mark -  App 启动后 RunLoop 的状态：

//CFRunLoop {
//    current mode = kCFRunLoopDefaultMode
//    common modes = {
//        UITrackingRunLoopMode
//        kCFRunLoopDefaultMode
//    }
//    
//    common mode items = {
//        
//        // source0 (manual)
//        CFRunLoopSource {order =-1, {
//            callout = _UIApplicationHandleEventQueue}}
//        CFRunLoopSource {order =-1, {
//            callout = PurpleEventSignalCallback }}
//        CFRunLoopSource {order = 0, {
//            callout = FBSSerialQueueRunLoopSourceHandler}}
//        
//        // source1 (mach port)
//        CFRunLoopSource {order = 0,  {port = 17923}}
//        CFRunLoopSource {order = 0,  {port = 12039}}
//        CFRunLoopSource {order = 0,  {port = 16647}}
//        CFRunLoopSource {order =-1, {
//            callout = PurpleEventCallback}}
//        CFRunLoopSource {order = 0, {port = 2407,
//            callout = _ZL20notify_port_callbackP12__CFMachPortPvlS1_}}
//        CFRunLoopSource {order = 0, {port = 1c03,
//            callout = __IOHIDEventSystemClientAvailabilityCallback}}
//        CFRunLoopSource {order = 0, {port = 1b03,
//            callout = __IOHIDEventSystemClientQueueCallback}}
//        CFRunLoopSource {order = 1, {port = 1903,
//            callout = __IOMIGMachPortPortCallback}}
//        
//        // Ovserver
//        CFRunLoopObserver {order = -2147483647, activities = 0x1, // Entry
//            callout = _wrapRunLoopWithAutoreleasePoolHandler}
//        CFRunLoopObserver {order = 0, activities = 0x20,          // BeforeWaiting
//            callout = _UIGestureRecognizerUpdateObserver}
//        CFRunLoopObserver {order = 1999000, activities = 0xa0,    // BeforeWaiting | Exit
//            callout = _afterCACommitHandler}
//        CFRunLoopObserver {order = 2000000, activities = 0xa0,    // BeforeWaiting | Exit
//            callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv}
//        CFRunLoopObserver {order = 2147483647, activities = 0xa0, // BeforeWaiting | Exit
//            callout = _wrapRunLoopWithAutoreleasePoolHandler}
//        
//        // Timer
//        CFRunLoopTimer {firing = No, interval = 3.1536e+09, tolerance = 0,
//            next fire date = 453098071 (-4421.76019 @ 96223387169499),
//            callout = _ZN2CAL14timer_callbackEP16__CFRunLoopTimerPv (QuartzCore.framework)}
//    },
//    
//    modes ＝ {
//        //1. kCFRunLoopDefaultMode: App的默认 Mode，通常主线程是在这个 Mode 下运行的。
//        CFRunLoopMode  {
//            sources0 =  { /* same as 'common mode items' */ },
//            sources1 =  { /* same as 'common mode items' */ },
//            observers = { /* same as 'common mode items' */ },
//            timers =    { /* same as 'common mode items' */ },
//        },
//        
//        //2. UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响。
//        CFRunLoopMode  {
//            sources0 =  { /* same as 'common mode items' */ },
//            sources1 =  { /* same as 'common mode items' */ },
//            observers = { /* same as 'common mode items' */ },
//            timers =    { /* same as 'common mode items' */ },
//        },
//        
//        //3. UIInitializationRunLoopMode: 在刚启动 App 时第进入的第一个 Mode，启动完成后就不再使用。
//        CFRunLoopMode  {
//            sources0 = {
//                CFRunLoopSource {order = 0, {
//                    callout = FBSSerialQueueRunLoopSourceHandler}}
//            },
//            sources1 = (null),
//            observers = {
//                CFRunLoopObserver >{activities = 0xa0, order = 2000000,
//                    callout = _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv}
//                )},
//            timers = (null),
//        },
//        
//        //4: GSEventReceiveRunLoopMode: 接受系统事件的内部 Mode，通常用不到。
//        CFRunLoopMode  {
//            sources0 = {
//                CFRunLoopSource {order = -1, {
//                    callout = PurpleEventSignalCallback}}
//            },
//            sources1 = {
//                CFRunLoopSource {order = -1, {
//                    callout = PurpleEventCallback}}
//            },
//            observers = (null),
//            timers = (null),
//        },
//        
//        //5: kCFRunLoopCommonModes: 这是一个占位的 Mode，没有实际作用。
//        CFRunLoopMode  {
//            sources0 = (null),
//            sources1 = (null),
//            observers = (null),
//            timers = (null),
//        }
//    }
//}

/**
 当 RunLoop 进行回调时，一般都是通过一个很长的函数调用出去 (call out), 当你在你的代码中下断点调试时，通常能在调用栈上看到这些函数。
 下面是这几个函数的整理版本，如果你在调用栈中看到这些长函数名，在这里查找一下就能定位到具体的调用地点了：
 */
//{
//    /// 1. 通知Observers，即将进入RunLoop
//    /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
//    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
//    do {
//        
//        /// 2. 通知 Observers: 即将触发 Timer 回调。
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
//        /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
//        
//        /// 4. 触发 Source0 (非基于port的) 回调。
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
//        
//        /// 6. 通知Observers，即将进入休眠
//        /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);
//        
//        /// 7. sleep to wait msg.
//        mach_msg() -> mach_msg_trap();
//        
//        
//        /// 8. 通知Observers，线程被唤醒
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);
//        
//        /// 9. 如果是被Timer唤醒的，回调Timer
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);
//        
//        /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
//        __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);
//        
//        /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);
//        
//        
//    } while (...);
//    
//    /// 10. 通知Observers，即将退出RunLoop
//    /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
//    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
//}

#pragma mark - AutoreleasePool

/**
 *  App启动后，苹果在主线程 RunLoop 里注册了两个 Observer，其回调都是 _wrapRunLoopWithAutoreleasePoolHandler()。
 
 第一个 Observer 监视的事件是 Entry(即将进入Loop)，其回调内会调用 _objc_autoreleasePoolPush() 创建自动释放池。其 order 是-2147483647，优先级最高，保证创建释放池发生在其他所有回调之前。
 
 第二个 Observer 监视了两个事件： BeforeWaiting(准备进入休眠) 时调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 释放旧的池并创建新池；Exit(即将退出Loop) 时调用 _objc_autoreleasePoolPop() 来释放自动释放池。这个 Observer 的 order 是 2147483647，优先级最低，保证其释放池子发生在其他所有回调之后。
 
 在主线程执行的代码，通常是写在诸如事件回调、Timer回调内的。这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，开发者也不必显示创建 Pool 了。
 */

#pragma mark - 事件响应

/**
 *  苹果注册了一个 Source1 (基于 mach port 的) 用来接收系统事件，其回调函数为 __IOHIDEventSystemClientQueueCallback()。
 
 当一个硬件事件(触摸/锁屏/摇晃等)发生后，首先由 IOKit.framework 生成一个 IOHIDEvent 事件并由 SpringBoard 接收。这个过程的详细情况可以参考这里。SpringBoard 只接收按键(锁屏/静音等)，触摸，加速，接近传感器等几种 Event，随后用 mach port 转发给需要的App进程。随后苹果注册的那个 Source1 就会触发回调，并调用 _UIApplicationHandleEventQueue() 进行应用内部的分发。
 
 _UIApplicationHandleEventQueue() 会把 IOHIDEvent 处理并包装成 UIEvent 进行处理或分发，其中包括识别 UIGesture/处理屏幕旋转/发送给 UIWindow 等。通常事件比如 UIButton 点击、touchesBegin/Move/End/Cancel 事件都是在这个回调中完成的。
 */

#pragma mark - 手势识别

/**
 *  当上面的 _UIApplicationHandleEventQueue() 识别了一个手势时，其首先会调用 Cancel 将当前的 touchesBegin/Move/End 系列回调打断。随后系统将对应的 UIGestureRecognizer 标记为待处理。
 
 苹果注册了一个 Observer 监测 BeforeWaiting (Loop即将进入休眠) 事件，这个Observer的回调函数是 _UIGestureRecognizerUpdateObserver()，其内部会获取所有刚被标记为待处理的 GestureRecognizer，并执行GestureRecognizer的回调。
 
 当有 UIGestureRecognizer 的变化(创建/销毁/状态改变)时，这个回调都会进行相应处理。
 */

#pragma mark - 界面更新
/**
 *  当在操作 UI 时，比如改变了 Frame、更新了 UIView/CALayer 的层次时，或者手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 就被标记为待处理，并被提交到一个全局的容器去。
 
 苹果注册了一个 Observer 监听 BeforeWaiting(即将进入休眠) 和 Exit (即将退出Loop) 事件，回调去执行一个很长的函数：
 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()。这个函数里会遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面。
 */

/**
 
 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()
 QuartzCore:CA::Transaction::observer_callback:
 CA::Transaction::commit();
 CA::Context::commit_transaction();
 CA::Layer::layout_and_display_if_needed();
 CA::Layer::layout_if_needed();
 [CALayer layoutSublayers];
 [UIView layoutSubviews];
 CA::Layer::display_if_needed();
 [CALayer display];
 [UIView drawRect];
 */

#pragma mark - 定时器
/**
 *  NSTimer 其实就是 CFRunLoopTimerRef，他们之间是 toll-free bridged 的。
 一个 NSTimer 注册到 RunLoop 后，RunLoop 会为其重复的时间点注册好事件。例如 10:00, 10:10, 10:20 这几个时间点。
 RunLoop为了节省资源，并不会在非常准确的时间点回调这个Timer。
 Timer 有个属性叫做 Tolerance (宽容度)，标示了当时间点到后，容许有多少最大误差。
 
 如果某个时间点被错过了，例如执行了一个很长的任务，则那个时间点的回调也会跳过去，不会延后执行。就比如等公交，如果 10:10 时我忙着玩手机错过了那个点的公交，那我只能等 10:20 这一趟了。
 
 CADisplayLink 是一个和屏幕刷新率一致的定时器（但实际实现原理更复杂，和 NSTimer 并不一样，其内部实际是操作了一个 Source）。如果在两次屏幕刷新之间执行了一个长任务，那其中就会有一帧被跳过去（和 NSTimer 相似），造成界面卡顿的感觉。在快速滑动TableView时，即使一帧的卡顿也会让用户有所察觉。Facebook 开源的 AsyncDisplayLink 就是为了解决界面卡顿的问题，其内部也用到了 RunLoop，这个稍后我会再单独写一页博客来分析。
 */

#pragma mark - PerformSelecter
/**
 *  当调用 NSObject 的 performSelecter:afterDelay: 后，实际上其内部会创建一个 Timer 并添加到当前线程的 RunLoop 中。所以如果当前线程没有 RunLoop，则这个方法会失效。
 
 当调用 performSelector:onThread: 时，实际上其会创建一个 Timer 加到对应的线程去，同样的，如果对应线程没有 RunLoop 该方法也会失效。
 */

#pragma mark - 关于GCD
/**
 *  实际上 RunLoop 底层也会用到 GCD 的东西，比如 RunLoop 是用 dispatch_source_t 实现的 Timer（评论中有人提醒，NSTimer 是用了 XNU 内核的 mk_timer，我也仔细调试了一下，发现 NSTimer 确实是由 mk_timer 驱动，而非 GCD 驱动的）。但同时 GCD 提供的某些接口也用到了 RunLoop， 例如 dispatch_async()。
 
 当调用 dispatch_async(dispatch_get_main_queue(), block) 时，libDispatch 会向主线程的 RunLoop 发送消息，RunLoop会被唤醒，并从消息中取得这个 block，并在回调 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__() 里执行这个 block。但这个逻辑仅限于 dispatch 到主线程，dispatch 到其他线程仍然是由 libDispatch 处理的。
 */

#pragma mark - 关于网络请求
/**
 *  iOS 中，关于网络请求的接口自下至上有如下几层:
 
 CFSocket
 CFNetwork       ->ASIHttpRequest
 NSURLConnection ->AFNetworking
 NSURLSession    ->AFNetworking2, Alamofire
 • CFSocket 是最底层的接口，只负责 socket 通信。
 • CFNetwork 是基于 CFSocket 等接口的上层封装，ASIHttpRequest 工作于这一层。
 • NSURLConnection 是基于 CFNetwork 的更高层的封装，提供面向对象的接口，AFNetworking 工作于这一层。
 • NSURLSession 是 iOS7 中新增的接口，表面上是和 NSURLConnection 并列的，但底层仍然用到了 NSURLConnection 的部分功能 (比如 com.apple.NSURLConnectionLoader 线程)，AFNetworking2 和 Alamofire 工作于这一层。
 
 下面主要介绍下 NSURLConnection 的工作过程。
 
 通常使用 NSURLConnection 时，你会传入一个 Delegate，当调用了 [connection start] 后，这个 Delegate 就会不停收到事件回调。实际上，start 这个函数的内部会会获取 CurrentRunLoop，然后在其中的 DefaultMode 添加了4个 Source0 (即需要手动触发的Source)。CFMultiplexerSource 是负责各种 Delegate 回调的，CFHTTPCookieStorage 是处理各种 Cookie 的。
 
 当开始网络传输时，我们可以看到 NSURLConnection 创建了两个新线程：com.apple.NSURLConnectionLoader 和 com.apple.CFSocket.private。其中 CFSocket 线程是处理底层 socket 连接的。NSURLConnectionLoader 这个线程内部会使用 RunLoop 来接收底层 socket 的事件，并通过之前添加的 Source0 通知到上层的 Delegate。
 
 NSURLConnectionLoader 中的 RunLoop 通过一些基于 mach port 的 Source 接收来自底层 CFSocket 的通知。当收到通知后，其会在合适的时机向 CFMultiplexerSource 等 Source0 发送通知，同时唤醒 Delegate 线程的 RunLoop 来让其处理这些通知。CFMultiplexerSource 会在 Delegate 线程的 RunLoop 对 Delegate 执行实际的回调。
 */

#pragma mark - RunLoop 的实际应用举例

/**
 AFNetworking
 AFURLConnectionOperation 这个类是基于 NSURLConnection 构建的，其希望能在后台线程接收 Delegate 回调。为此 AFNetworking 单独创建了一个线程，并在这个线程中启动了一个 RunLoop：
 
 
 + (void)networkRequestThreadEntryPoint:(id)__unused object {
 @autoreleasepool {
 [[NSThread currentThread] setName:@"AFNetworking"];
 NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
 [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
 [runLoop run];
 }
 }
 
 + (NSThread *)networkRequestThread {
 static NSThread *_networkRequestThread = nil;
 static dispatch_once_t oncePredicate;
 dispatch_once(&oncePredicate, ^{
 _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
 [_networkRequestThread start];
 });
 return _networkRequestThread;
 }

 
 RunLoop 启动前内部必须要有至少一个 Timer/Observer/Source，所以 AFNetworking 在 [runLoop run] 之前先创建了一个新的 NSMachPort 添加进去了。通常情况下，调用者需要持有这个 NSMachPort (mach_port) 并在外部线程通过这个 port 发送消息到 loop 内；但此处添加 port 只是为了让 RunLoop 不至于退出，并没有用于实际的发送消息。
 
 
 - (void)start {
 [self.lock lock];
 if ([self isCancelled]) {
 [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
 } else if ([self isReady]) {
 self.state = AFOperationExecutingState;
 [self performSelector:@selector(operationDidStart) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
 }
 [self.lock unlock];
 }
 
 当需要这个后台线程执行任务时，AFNetworking 通过调用 [NSObject performSelector:onThread:..] 将这个任务扔到了后台线程的 RunLoop 中。
 */

#pragma mark - AsyncDisplayKit
/**
 AsyncDisplayKit 是 Facebook 推出的用于保持界面流畅性的框架，其原理大致如下：
 
 UI 线程中一旦出现繁重的任务就会导致界面卡顿，这类任务通常分为3类：排版，绘制，UI对象操作。
 
 排版通常包括计算视图大小、计算文本高度、重新计算子式图的排版等操作。
 绘制一般有文本绘制 (例如 CoreText)、图片绘制 (例如预先解压)、元素绘制 (Quartz)等操作。
 UI对象操作通常包括 UIView/CALayer 等 UI 对象的创建、设置属性和销毁。
 
 其中前两类操作可以通过各种方法扔到后台线程执行，而最后一类操作只能在主线程完成，并且有时后面的操作需要依赖前面操作的结果 （例如TextView创建时可能需要提前计算出文本的大小）。ASDK 所做的，就是尽量将能放入后台的任务放入后台，不能的则尽量推迟 (例如视图的创建、属性的调整)。
 
 为此，ASDK 创建了一个名为 ASDisplayNode 的对象，并在内部封装了 UIView/CALayer，它具有和 UIView/CALayer 相似的属性，例如 frame、backgroundColor等。所有这些属性都可以在后台线程更改，开发者可以只通过 Node 来操作其内部的 UIView/CALayer，这样就可以将排版和绘制放入了后台线程。但是无论怎么操作，这些属性总需要在某个时刻同步到主线程的 UIView/CALayer 去。
 
 ASDK 仿照 QuartzCore/UIKit 框架的模式，实现了一套类似的界面更新的机制：即在主线程的 RunLoop 中添加一个 Observer，监听了 kCFRunLoopBeforeWaiting 和 kCFRunLoopExit 事件，在收到回调时，遍历所有之前放入队列的待处理的任务，然后一一执行。
 具体的代码可以看这里：_ASAsyncTransactionGroup。
 */

@implementation YYRunLoop

@end


















