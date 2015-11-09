//
//  CollectionTypesDemo.swift
//  SwiftSum
//
//  Created by sihuan on 15/11/5.
//  Copyright © 2015年 sihuan. All rights reserved.
//

import UIKit

class CollectionTypesDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func collectionTypesDemo() {
        
        /*
        Swift 语言提供Arrays、Sets和Dictionaries三种基本的集合类型用来存储集合数据。
        数组（Arrays）是有序数据的集。集合（Sets）是无序无重复数据的集。字典（Dictionaries）是无序的键值对的集。
        */
        
        // MARK: - 数组
        /**
        *  Swift 数据值在被存储进入某个数组之前类型必须明确,这与 Objective-C 的 NSArray 和 NSMutableArray 不同
        */
        var shoppingList:[String] = ["eggs", "milk"]
        // shoppingList 已经被构造并且拥有两个初始项。
        
        shoppingList.count
        let item = shoppingList[0]
        //使用布尔项isEmpty来作为检查count属性的值是否为 0 的捷径。
        if shoppingList.isEmpty {
            
        }
        shoppingList.append("floutr")
        
        //直接在数组后面添加一个或多个拥有相同类型的数据项
        shoppingList += ["power"]
        
        //还可以利用下标来一次改变一系列数据值，即使新数据和原有数据的数量是不一样的。
        shoppingList[0...2] = ["Bananas", "Apples"]
        
        shoppingList.insert("Maple Syrup", atIndex: 0)
        // "Maple Syrup" 现在是这个列表中的第一项
        
        shoppingList.removeAtIndex(0)
        
        //数据项被移除后数组中的空出项会被自动填补，所以现在索引值为0的数据项的值再次等于"Six eggs"：
        
        let firstItem = shoppingList[0]
        // firstItem 现在等于 "Six eggs"
        
        //最后一项移除
        shoppingList.removeLast()
        
        // MARK: - 数组的遍历
        
        for item in shoppingList {
            print(item)
        }
        
        /**
        *  如果我们同时需要每个数据项的值和索引值，可以使用enumerate()方法来进行数组遍历。
        enumerate()返回一个由每一个数据项索引值和数据值组成的元组。我们可以把这个元组分解成临时常量或者变量来进行遍历：
        */
        for (index, value) in shoppingList.enumerate() {
            print("Item \(String(index + 1)): \(value)")
        }
        // Item 1: Six eggs
        // Item 2: Milk
        // Item 3: Flour
        // Item 4: Baking Powder
        // Item 5: Bananas
        
        
        // MARK: - 集合（Sets）
        
        /**
        *  集合(Set)用来存储相同类型并且没有确定顺序的值。当集合元素顺序不重要时或者希望确保每个元素只出现一次时可以使用集合而不是数组。
        */
        
        // MARK: 集合类型的哈希值
        
        /**
        *  一个类型为了存储在集合中，该类型必须是可哈希化的--也就是说，该类型必须提供一个方法来计算它的哈希值。
        一个哈希值是Int类型的，相等的对象哈希值必须相同，比如a==b,因此必须a.hashValue == b.hashValue。
        
        
        Swift 的所有基本类型(比如String,Int,Double和Bool)默认都是可哈希化的，可以作为集合的值的类型或者字典的键的类型。
        没有关联值的枚举成员值(在枚举有讲述)默认也是可哈希化的。
        */
        
        
        /**
        *  注意：
        你可以使用你自定义的类型作为集合的值的类型或者是字典的键的类型，但你需要使你的自定义类型符合 Swift 标准库中的Hashable协议。
        符合Hashable协议的类型需要提供一个类型为Int的可读属性hashValue。由类型的hashValue属性返回的值不需要在同一程序的不同执行周期或者不同程序之间保持相同。
        */
        
        
        /**
        *  因为Hashable协议符合Equatable协议，所以符合该协议的类型也必须提供一个"是否相等"运算符(==)的实现。
        这个Equatable协议要求任何符合==实现的实例间都是一种相等的关系。也就是说，对于a,b,c三个值来说，==的实现必须满足下面三种情况：
        
        a == a(自反性)
        a == b意味着b == a(对称性)
        a == b && b == c意味着a == c(传递性)
        */
        
        var letters = Set<Character>()
        letters.insert("a")
        // letters 现在含有1个 Character 类型的值
        letters = []
        // letters 现在是一个空的 Set, 但是它依然是 Set<Character> 类型
        
        
        // MARK: - 访问和修改一个集合
        var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
        if favoriteGenres.isEmpty {
            print("As far as music goes, I'm not picky.")
        } else {
            print("I have particular music preferences.")
        }
        // 打印 "I have particular music preferences."
        
        /**
        *  你可以通过调用Set的remove(_:)方法去删除一个元素，如果该值是该Set的一个元素则删除该元素并且返回被删除的元素值，
        否则如果该Set不包含该值，则返回nil。另外，Set中的所有元素可以通过它的removeAll()方法删除。
        */
        favoriteGenres.remove("Roc")
        
        //使用contains(_:)方法去检查Set中是否包含一个特定的值：
        
        if favoriteGenres.contains("Funk") {
            print("I get up on the good foot.")
        } else {
            print("It's too funky in here.")
        }
        // 打印 "It's too funky in here."
        
        //遍历一个集合
        
        for genre in favoriteGenres {
            print("\(genre)")
        }
        // Classical
        // Jazz
        // Hip hop
        
        //Swift 的Set类型没有确定的顺序，为了按照特定顺序来遍历一个Set中的值可以使用sort()方法，它将根据提供的序列返回一个有序集合.
        for genre in favoriteGenres.sort() {
            print("\(genre)")
        }
        // prints "Classical"
        // prints "Hip hop"
        // prints "Jazz
        
        
        // MARK: - 集合操作
        
        /**
        *  你可以高效地完成Set的一些基本操作，比如把两个集合组合到一起，判断两个集合共有元素，或者判断两个集合是否全包含，部分包含或者不相交。
        
        
        使用intersect(_:)方法根据两个集合中都包含的值创建的一个新的集合。
        使用exclusiveOr(_:)方法根据在一个集合中但不在两个集合中的值创建一个新的集合。
        使用union(_:)方法根据两个集合的值创建一个新的集合。
        使用subtract(_:)方法根据不在该集合中的值创建一个新的集合。
        */
        
        let oddDigits: Set = [1,3,5,7,9]
        let evenDigits: Set = [0,2,4,6,8];
        let singleDigitPrimeNumbers: Set = [2, 3, 5, 7];
        
        //并集
        let union = oddDigits.union(evenDigits).sort()
        // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        //交集
        let intersect = oddDigits.intersect(evenDigits).sort()
        // []
        
        //在集合A中，不在集合B中的数据
        let subtrct = oddDigits.subtract(singleDigitPrimeNumbers).sort()
        // [1, 9]
        
        //在A，B中，而不在他们的交集中的数据
        let exclusiver = oddDigits.exclusiveOr(singleDigitPrimeNumbers).sort()
        // [1, 2, 9]
        
        
        /**
        *  使用“是否相等”运算符(==)来判断两个集合是否包含全部相同的值。
        使用isSubsetOf(_:)方法来判断一个集合中的值是否也被包含在另外一个集合中。
        使用isSupersetOf(_:)方法来判断一个集合中包含另一个集合中所有的值。
        使用isStrictSubsetOf(_:)或者isStrictSupersetOf(_:)方法来判断一个集合是否是另外一个集合的子集合或者父集合并且两个集合并不相等。
        使用isDisjointWith(_:)方法来判断两个集合是否不含有相同的值。
        */
        
        let houseAnimals: Set = ["🐶", "🐱"]
        let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
        let cityAnimals: Set = ["🐦", "🐭"]
        
        houseAnimals.isSubsetOf(farmAnimals)
        // true
        farmAnimals.isSupersetOf(houseAnimals)
        // true
        farmAnimals.isDisjointWith(cityAnimals)
        // true
        
        
        // MARK: - 字典类型快捷语法
        
        //Swift 的字典使用Dictionary<Key, Value>定义，其中Key是字典中键的数据类型，Value是字典中对应于这些键所存储值的数据类型。
        
        /**
        *  注意：
        一个字典的Key类型必须遵循Hashable协议，就像Set的值类型。
        */
        
        // MARK: - 字典
        /**
        *  Swift 的字典使用Dictionary<KeyType, ValueType>定义,其中KeyType是字典中键的数据类型，ValueType是字典中对应于这些键所存储值的数据类型。
        
        KeyType的唯一限制就是可哈希的，这样可以保证它是独一无二的，所有的 Swift 基本类型（例如String，Int， Double和Bool）都是默认可哈希的，
        并且所有这些类型都可以在字典中当做键使用。未关联值的枚举成员（参见枚举）也是默认可哈希的。
        */
        var airports: [String:String] = ["TYO": "Tokyo", "DUB": "Dublin"]
        
        //和数组一样，如果我们使用字面量构造字典就不用把类型定义清楚。airports的也可以用这种方法简短定义：
        var airports2 = ["TYO": "Tokyo", "DUB": "Dublin"]
        
        //添加
        airports["LHR"] = "London"
        
        
        //修改
        airports["LHR"] = "London Heathrow"
        airports.updateValue("hh", forKey: "LHR")
        
        //移除
        airports["LHR"] = nil
        
        for (airportCode, airportName) in airports {
            print("\(airportCode): \(airportName)")
        }
        
        
        var namesOfIntegers = Dictionary<Int, String>()
        // namesOfIntegers 是一个空的 Dictionary<Int, String>
        //这个例子创建了一个Int, String类型的空字典来储存英语对整数的命名。它的键是Int型，值是String型。
        
        //如果上下文已经提供了信息类型，我们可以使用空字典字面量来创建一个空字典，记作[:]（中括号中放一个冒号）：
        namesOfIntegers[16] = "sixteen"
        // namesOfIntegers 现在包含一个键值对
        namesOfIntegers = [:]
        // namesOfIntegers 又成为了一个 Int, String类型的空字典
        
        
        // MARK: 字典遍历
        
        //我们可以使用for-in循环来遍历某个字典中的键值对。每一个字典中的数据项都以(key, value)元组形式返回，并且我们可以使用临时常量或者变量来分解这些元组：
        
        for (airportCode, airportName) in airports {
            print("\(airportCode): \(airportName)")
        }
        // YYZ: Toronto Pearson
        // LHR: London Heathrow
        
        //通过访问keys或者values属性，我们也可以遍历字典的键或者值：
        
        for airportCode in airports.keys {
            print("Airport code: \(airportCode)")
        }
        // Airport code: YYZ
        // Airport code: LHR
        
        for airportName in airports.values {
            print("Airport name: \(airportName)")
        }
        
        //如果我们只是需要使用某个字典的键集合或者值集合来作为某个接受Array实例的 API 的参数，可以直接使用keys或者values属性构造一个新数组：
        //用keys或者values属性直接构造一个新数组：
        let keys = Array(airports.keys)
        
        let airportCodes = [String](airports.keys)
        // airportCodes 是 ["YYZ", "LHR"]
        
        let airportNames = [String](airports.values)
        // airportNames 是 ["Toronto Pearson", "London Heathrow"]
        //Swift 的字典类型是无序集合类型。为了以特定的顺序遍历字典的键或值，可以对字典的keys或values属性使用sort()方法。
        
        
        // MARK: - 集合的可变性
        
        //对字典来说，不可变性也意味着我们不能替换其中任何现有键所对应的值。不可变字典的内容在被首次设定之后不能更改。
        let airports3: [String:String] = ["TYO": "Tokyo", "DUB": "Dublin"]
        //airports3.updateValue("33", forKey: "TYO") error
        
        //对数组来说有一点不同，当然我们不能试着改变任何不可变数组的大小，但是我们可以重新设定相对现存索引所对应的值。
        //错的.......
        let arr:[String] = ["eggs", "milk"]
        //arr[1] = "dddd"  error

    }
    
    
    
    
    
    
    
    
    
}
