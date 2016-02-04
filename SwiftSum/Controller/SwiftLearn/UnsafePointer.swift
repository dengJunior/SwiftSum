//
//  UnsafePointer.swift
//  MySwiftFrame
//
//  Created by sihuan on 15/4/29.
//  Copyright (c) 2015年 sihuan. All rights reserved.
//

import Foundation

// MARK: - 指针

//Swift 本身从设计上来说是一门非常安全的语言,为了与庞大的 C 系帝国进行合作，Swift 定义了一套指针的访问和转换方法，那就是 UnsafePointer 和它的一系列变体。


//对于使用 C API 时如果遇到接受内存地址作为参数，或者返回是内存地址的情况，在 Swift 里会将它们转为 UnsafePointer<Type> 的类型，比如:

/**
void method(const int *num) {
    printf("%d", *num);
}
*/

// MARK: - 上面的c函数，其对应的 Swift 方法应该是：
func method1(num: UnsafePointer<CInt>) {
    print(num.memory, terminator: "")
}
// num 指针的不可变的 (const)

//普通的可变指针的话，我们可以使用 UnsafeMutablePointer
func method2(num: UnsafeMutablePointer<CInt>) {
    //在 C 中，对某个指针进行取值使用的是 *，而在 Swift 中我们可以使用 memory 属性来读取相应内存中存储的内容。
    print(num.memory, terminator: "")
    
    //C
    //int a = 123;
    //method1(&a)
    
    //Swift 都是在前面加上 & 符号
    var a:CInt = 123
    method1(&a)
}

//UnsafePointer，就是 Swift 中专门针对指针的转换。对于其他的 C 中基础类型，在 Swift 中对应的类型都遵循统一的命名规则：在前面加上一个字母 C 并将原来的第一个字母大写



// MARK: - 另外一个重要的课题是如何在指针的内容和实际的值之间进行转换。

func cfarr() {
    //比如我们如果由于某种原因需要涉及到直接使用 CFArray 的方法来获取数组中元素的时候，我们会用到这个方法：  CFArrayGetValueAtIndex
    
    let arr = NSArray(object: "meow")
    
    //因为 CFArray 中是可以存放任意对象的，所以这里的返回是一个任意对象的指针，相当于 C 中的 void *。这显然不是我们想要的东西。
    
    //Swift 中为我们提供了一个强制转换的方法 unsafeBitCast，通过下面的代码，我们可以看到应当如何使用类似这样的 API，将一个指针强制按位转成所需类型的对象：
    let str = unsafeBitCast(CFArrayGetValueAtIndex(arr, 0), CFString.self)
    //unsafeBitCast 会将第一个参数的内容按照第二个参数的类型进行转换，而不去关心实际是不是可行，这也正是 UnsafePointer 的不安全所在
    
    
}

// MARK: - C 指针内存管理
class CPointClass {
    var a = 1
    deinit {
        print("deinit")
    }
}

func cPointClassDemo() {
    var pointer: UnsafeMutablePointer<CPointClass>!
    pointer = UnsafeMutablePointer.alloc(1)
    pointer.initialize(CPointClass());
    
    print(pointer)
    
    // UnsafeMutablePointer 并不会自动进行内存管理，因此其实 pointer 所指向的内存是没有被释放和回收的
    //pointer = nil
    
    //需要下面手动释放
    pointer.destroy()
    pointer.dealloc(1)
    
}










