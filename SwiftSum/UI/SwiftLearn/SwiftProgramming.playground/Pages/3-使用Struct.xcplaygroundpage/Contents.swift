//: [Previous](@previous)

import UIKit

// MARK: - Thinking in Swift, Part 3: Struct vs. Class

/**
 在我们的例子中，使用一个结构体看起来更为合适，因为它保存了一些值，并且并不会要对它们做什么改变(更适合拷贝而非引用)。
 */

struct ListItem2 {
    var icon: UIImage?
    var title: String
    var url: NSURL
    
    static func listItemsFromJSONData(jsonData: NSData?) -> [ListItem2] {
        guard let nonNilJsonData = jsonData,
            let json = try? NSJSONSerialization.JSONObjectWithData(nonNilJsonData, options: []),
            let jsonItems = json as? Array<NSDictionary> else { return [] }
        
        return jsonItems.flatMap { (itemDesc: NSDictionary) -> ListItem2? in
            guard let title = itemDesc["title"] as? String,
                let urlString = itemDesc["url"] as? String,
                let url = NSURL(string: urlString)
                else { return nil }
            let iconName = itemDesc["icon"] as? String
            let icon = UIImage(named: iconName ?? "")
            return ListItem2(icon: icon, title: title, url: url)
        }
    }
}

//: [Next](@next)
