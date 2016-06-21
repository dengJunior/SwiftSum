//: [Previous](@previous)

import UIKit

// MARK: - Thinking in Swift, Part 4: map all the things!

struct ListItem2 {
    var icon: UIImage?
    var title: String
    //更重要的是我们就能把NSURL!转换成NSURL
    var url: NSURL
    
    
    /**
     Array vs. Optional
     
     Array<T>对应的map()和flatMap()函数签名是：
     
     // 作用在Array<T>上的方法
     map( transform: T ->          U  ) -> Array<U>
     flatMap( transform: T ->    Array<U> ) -> Array<U>
     
     
     对于Optional<T>来说，map()和flatMap()的函数签名十分类似：
     
     // 作用在Optional<T>上的方法
     map( transform: T ->          U  ) -> Optional<U>
     flatMap( transform: T -> Optional<U> ) -> Optional<U>
     
     作用在可选类型上的 map()
     
     那么map方法到底对Optional<T>类型(也叫做T?)做了什么？
     其实很简单：和作用在Array<T>上的一样，map方法将Optional<T>中的内容取出来，用指定的transform: T->U方法做出转换，然后把结果包装成一个新的Optional<U>。
     */
    
    static func listItemsFromJSONData2(jsonData: NSData?) -> [ListItem2] {
        guard let jsonData = jsonData,
            let json = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []),
            let jsonItems = json as? Array<NSDictionary> else { return [] }
        
        return jsonItems.flatMap { (itemDesc: NSDictionary) -> ListItem2? in
            guard let title = itemDesc["title"] as? String,
                let urlString = itemDesc["url"] as? String,
                let url = NSURL(string: urlString)
                else { return nil }
            let iconName = itemDesc["icon"] as? String
            
            /*
             回到我们的例子
             
             我们需要在可选型中确实有值时(非nil)将内部的String值传入。
             一种解决方案是使用可选绑定(Optional Binding)：
             */
            let icon1: UIImage?
            if let iconName = itemDesc["icon"] as? String {
                icon1 = UIImage(named: iconName)
            } else {
                icon1 = nil
            }
            //但是对于一个如此简单的操作来说代码量太大。
            
            /*
             来用 map 吧
             
             那么为什么不用map呢？本质上，我们是想要在Optional<String>不是nil的时候将其解包，把里面的值转换成一个UIImage对象然后把这个UIImage返回，这不就是一个绝佳的用例么？
             */
            let icon2 = iconName.map{ imageName in UIImage(named: imageName) }
            
            /*
             但结果icon2是 UIImage?? 类型的，因为iconName是一个可选类型,UIImage(named: …)也返回一个可选类型
             
             再看一下map方法的签名，它想要的是一个T->U类型的闭包，这个闭包会返回一个U?类型。我们的例子中，U代表UIImage?的话，整个map表达式会返回一个U?类型，也就是…一个UIImage??类型…是的，一个双重可选类型
             */
            
            
            let icon3 = iconName.flatMap{ imageName in UIImage(named: imageName) }
            if icon1 != nil && icon2 != nil && icon3 != nil {
                
            }
            
            //最终版
            let icon = iconName.flatMap { UIImage(named: $0) }
            
            // MARK: - flatMap() 来帮忙了
            /**
             实际中flatMap做了如下工作：
             
             1. 如果iconName是nil的话，它就直接返回nil(但返回类型还是UIImage?)
             2. 如果iconName不是nil，它就把transform作用到iconName的实际的值上，尝试用这个String创建一个UIImage并将结果返回——结果本身已经是一个UIImage?类型，因此如果UIImage初始化方法失败的话，返回结果就是nil。
             */
            
            return ListItem2(icon: icon, title: title, url: url)
        }
    }
}


//: [Next](@next)
