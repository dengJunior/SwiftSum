//: [Previous](@previous)

import UIKit


class ListItem {
    var icon: UIImage?
    var title: String = ""
    var url: NSURL!
    
    // MARK: - 使用map
    
    /**
     map() 是 Array 提供的方法，通过接收一个函数作为传入参数，对数组中每个元素进行函数变换得到新的结果值。
     这样只需要提供X->Y的映射关系，就能将数组[X]变换到新数组[Y]
     */
    
    static func listItemsFromJSONData3(jsonData: NSData?) -> [ListItem] {
        guard let nonNilJsonData = jsonData,
            let json = try? NSJSONSerialization.JSONObjectWithData(nonNilJsonData, options: []),
            let jsonItems = json as? Array<NSDictionary>
            else {
                return []
        }
        
        var items = jsonItems.map { (itemDictionary) -> ListItem in
            /*
             这里我们应该在NSDictionary不合法的时候返回nil
             而不是一个空对象
             */
            let item = ListItem()
            if let icon = itemDictionary["icon"] as? String {
                item.icon = UIImage(named: icon)
            }
            if let title = itemDictionary["title"] as? String {
                item.title = title
            }
            if let urlString = itemDictionary["url"] as? String, let url = NSURL(string: urlString) {
                item.url = url
            }
            return item
        }
        
        jsonItems.map { (itemDictionary) -> ListItem? in
            
            guard let itemDictionary = itemDictionary as? NSDictionary else {
                return nil
                /*
                 这里我们应该在NSDictionary不合法的时候返回nil
                 但是这样的话，使用map会返回数组[ListItem?],那些原来是不可用 NSDictionary 的位置被替换成了 nil，
                 还是不完美，应该使用flatMap
                 */
            }
            let item = ListItem()
            if let icon = itemDictionary["icon"] as? String {
                item.icon = UIImage(named: icon)
            }
            if let title = itemDictionary["title"] as? String {
                item.title = title
            }
            if let urlString = itemDictionary["url"] as? String, let url = NSURL(string: urlString) {
                item.url = url
            }
            return item
        }
        
        
        // MARK: - 使用flatMap
        
        /**
         flatMap() 与 map() 相似，但 flatMap() 用的是 T->U? 变换而不是 T->U 转化，
         而且倘若变换后的数组元素值为 nil，则不会被添加到最后的结果数组里面。
         flatMap还有其他一些作用。比如把一个二维数组变换为一维数组，比如，[[T]] -> [T]。
         */
        
        items = jsonItems.flatMap{ (itemDictionary: NSDictionary) -> ListItem? in
            guard let title = itemDictionary["title"] as? String,
                let urlString = itemDictionary["url"] as? String,
                let url = NSURL(string: urlString) else {
                    return nil
            }
            let item = ListItem()
            if let icon = itemDictionary["icon"] as? String {
                item.icon = UIImage(named: icon)
            }
            item.title = title
            item.url = url
            //现在flatMap只返回合法的item数组了[ListItem]
            return item
        }
        //我们解决了数据异常的问题，当有错误输入时候，避免了无效的ListItem项添加到数组当中。
        return items
    }

}



//: [Next](@next)
