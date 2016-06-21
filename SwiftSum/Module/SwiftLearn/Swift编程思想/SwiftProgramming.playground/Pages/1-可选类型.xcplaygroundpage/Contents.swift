//: Playground - noun: a place where people can play

import UIKit


//在这一系列的文章中，我们会拿一个ObjC代码做例子，然后在把它转成Swift代码的全程中引入越来越多的对新概念的讲解。

//本文的第一部分内容：可选类型（optionals），对可选类型的强制拆包，小马，if let，guard和🍰。

/**
 ObjC代码
 假设你想创建一个条目列表（比如过会儿要显示在一个TableView里）- 每个条目都有一个图标，标题和网址 - 这些条目都通过一个JSON初始化。下面是ObjC代码看起来的样子：
 */

//@interface ListItem : NSObject
//@property(strong) UIImage* icon;
//@property(strong) NSString* title;
//@property(strong) NSURL* url;
//@end
//
//@implementation ListItem
//+(NSArray*)listItemsFromJSONData:(NSData*)jsonData {
//    NSArray* itemsDescriptors = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
//    NSMutableArray* items = [NSMutableArray new];
//    for (NSDictionary* itemDesc in itemsDescriptors) {
//        ListItem* item = [ListItem new];
//        item.icon = [UIImage imageNamed:itemDesc[@"icon"]];
//        item.title = itemDesc[@"title"];
//        item.url = [NSURL URLWithString:itemDesc[@"title"]];
//        [items addObject:item];
//    }
//    return [items copy];
//}
//@end

// MARK: - 直译成Swift
//想象一下有多少Swift的新手会把这段代码翻译成这样：

class ListItem {
    var icon: UIImage?
    var title: String = ""
    var url: NSURL!
    
    //到处使用隐式解析可选类型（value!），强制转型（value as! String）和强制使用try（try!）。
    
    //你绝不应该对一个值进行强制拆包，除非你真的知道你在干什么。记住，每次你加一个!去安抚编译器的时候，你就屠杀了一匹小马🐴。
    static func listItemsFromJSONData(jsonData: NSData?) -> NSArray {
        let jsonItems: NSArray = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: []) as! NSArray
        let items: NSMutableArray = NSMutableArray()
        for itemDesc in jsonItems {
            let item: ListItem = ListItem()
            item.icon = UIImage(named: itemDesc["icon"] as! String)
            item.title = itemDesc["title"] as! String
            item.url = NSURL(string: itemDesc["url"] as! String)!
            items.addObject(item)
        }
        return items.copy() as! NSArray
    }
    
    
    /**
     那么我们该怎样去避开这些无处不在的糟糕的!呢？这儿有一些技巧：
     
     1. 使用可选绑定（optional binding）if let x = optional { /* 使用 x */ }
     2. 用as?替换掉as!,前者在转型失败的时候返回nil；你当然可以把它和if let结合使用
     3. 你也可以用try?替换掉try!，前者在表达式失败时返回nil1。
     4. 将多个if let语句合并为一个：if let x = opt1, y = opt2
     5. 使用guard语句，在某个条件不满足的情况下能让我们尽早的从一个函数中跳出来，避免了再去运行函数体剩下的部分。
     */
    
    
    static func listItemsFromJSONData2(jsonData: NSData?) -> [ListItem] {
        guard let nonNilJsonData = jsonData,
            let json = try? NSJSONSerialization.JSONObjectWithData(nonNilJsonData, options: []),
            let jsonItems = json as? Array<NSDictionary>
            else {
                return []
        }
        
        var items = [ListItem]()
        for itemDesc in jsonItems {
            let item = ListItem()
            if let icon = itemDesc["icon"] as? String {
                item.icon = UIImage(named: icon)
            }
            if let title = itemDesc["title"] as? String {
                item.title = title
            }
            if let urlString = itemDesc["url"] as? String, let url = NSURL(string: urlString) {
                item.url = url
            }
            items.append(item)
        }
        return items
    }
    
    // MARK: - Swift难道不应该比ObjC更简洁么？
    
    /**
     这代码好像是比它的ObjC版本更复杂。但更重要的是，这段代码比它ObjC的版本更加安全。
     
     实际上ObjC的代码更短只是因为我们忘了去执行一大堆的安全测试。因为ObjC没有引导我们去考虑这些情况，而Swift迫使我们去考虑。
     
     在即将到来的本文第二部分中，我们会看到怎么让这个Swift代码更加简洁，并延续Swift的编程思想：将for循环和if-let搬走，替换成map和flatmap。
     */
    
}















