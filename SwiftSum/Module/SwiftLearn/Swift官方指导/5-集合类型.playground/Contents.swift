//: Playground - noun: a place where people can play

import UIKit

/**
 *  本页包含内容：
 
 - 集合的可变性（Mutability of Collections）
 - 数组（Arrays）
 - 集合（Sets）
 - 字典（Dictionaries）
 */

// MARK: - ## 数组(Arrays)

//数组使用有序列表存储同一类型的多个值。
//注意: Swift 的Array类型被桥接到Foundation中的NSArray类。

var someInts = [Int]()
someInts.append(3)
someInts = []

var threeDoubles = [Double](count: 3, repeatedValue: 2.5)//[2.5, 2.5, 2.5]
threeDoubles = Array(count: 3, repeatedValue: 2.5)//[2.5, 2.5, 2.5]

var shoppingList: [String] = ["Eggs", "Milk"]
shoppingList = ["Eggs", "Milk"]

// MARK: - ### 访问和修改数组

if shoppingList.isEmpty {
    print("The shopping list is empty.")
}

shoppingList += ["Baking Powder", "Five"]
shoppingList[0] = "Six"

print(shoppingList)//["Six", "Milk", "Baking Powder", "Five"]

//修改0和1的值，后面数组是2个，正常情况
shoppingList[0...1] = ["Bananas", "Apples"]
print(shoppingList)//"["Bananas", "Apples", "Baking Powder", "Five"]

/**
 *  修改0,1,2的值，后面数组只有2个值，特殊情况
 结果数组只有3个值了，下标是2的值remove掉了
 */
shoppingList[0...2] = ["Bananas", "Apples"]
print(shoppingList)//"["Bananas", "Apples", "Five"]

shoppingList.insert("Maple Syrup", atIndex: 0)
let mapleSyrup = shoppingList.removeAtIndex(0)

// MARK: - ## 数组的遍历

for item in shoppingList {
    print(item)
}
//numerate()返回一个由每一个数据项索引值和数据值组成的元组。
for (index, value) in shoppingList.enumerate() {
    print("Item \(String(index + 1)): \(value)")
}

// MARK: - ## 集合（Sets）

/**
 *  集合(Set)用来存储相同类型并且没有确定顺序的值。
 >注意：
 Swift的Set类型被桥接到Foundation中的NSSet类。
 */

// MARK: - ### 集合类型的哈希值

//一个类型为了存储在集合中，该类型必须是可哈希化的--也就是说，该类型必须提供一个方法来计算它的哈希值。一个哈希值是Int类型的，相等的对象哈希值必须相同，比如a==b,因此必须a.hashValue == b.hashValue。

//Swift 的所有基本类型(比如String,Int,Double和Bool)默认都是可哈希化的，可以作为集合的值的类型或者字典的键的类型。没有关联值的枚举成员值(在枚举有讲述)默认也是可哈希化的。符合Hashable协议

//因为Hashable协议符合Equatable协议，所以符合该协议的类型也必须提供一个"是否相等"运算符(==)的实现。这个Equatable协议要求任何符合==实现的实例间都是一种相等的关系。

/**
 *  也就是说，对于a,b,c三个值来说，==的实现必须满足下面三种情况：
 
 1. a == a(自反性)
 2. a == b意味着b == a(对称性)
 3. a == b && b == c意味着a == c(传递性)
 */

var letters = Set<Character>()
letters.insert("a")
letters = []
// letters 现在是一个空的 Set, 但是它依然是 Set<Character> 类型

var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
// favoriteGenres 被构造成含有三个初始值的集合

var favoriteGenres2: Set = ["Rock", "Classical", "Hip hop"]

if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}

favoriteGenres.insert("Jazz")

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}

for genre in favoriteGenres {
    print("\(genre)")
}

for genre in favoriteGenres.sort() {
    print("\(genre)")
}

// MARK: - ### 集合操作

/*
 - 使用intersect(_:)方法根据两个集合中都包含的值创建的一个新的集合。
 - 使用exclusiveOr(_:)方法根据在任何一个集合中但不同时在两个集合中的值创建一个新的集合。
 - 使用union(_:)方法根据两个集合的值创建一个新的集合。
 - 使用subtract(_:)方法根据不在该集合中的值创建一个新的集合。
 */
let oddDigits: Set = [1, 3, 5, 7, 9]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

//oddDigits和singleDigitPrimeNumbers的交集 3 5 7
print(oddDigits.intersect(singleDigitPrimeNumbers).sort())

//值在oddDigits或singleDigitPrimeNumbers某个集合中，1 2 9
print(oddDigits.exclusiveOr(singleDigitPrimeNumbers).sort())

//oddDigits和singleDigitPrimeNumbers并集1 2 3 4 7 9
print(oddDigits.union(singleDigitPrimeNumbers).sort())

//在oddDigits中，同时不在singleDigitPrimeNumbers中  1 9
print(oddDigits.subtract(singleDigitPrimeNumbers).sort())

// MARK: - 集合成员关系和相等

/*
 - 使用“是否相等”运算符(==)来判断两个集合是否包含全部相同的值。
 - 使用isSubsetOf(_:) isSupersetOf(_:) 子集 判断
 - 使用isStrictSubsetOf(_:)或者isStrictSupersetOf(_:)真子集 判断
 - 使用isDisjointWith(_:)是否没有交集
 */
let houseAnimals: Set = ["🐶", "🐱"]
let houseAnimals2: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

houseAnimals.isSubsetOf(houseAnimals2)//true
houseAnimals.isStrictSubsetOf(houseAnimals2)//false

houseAnimals.isSubsetOf(farmAnimals)//true
houseAnimals.isStrictSubsetOf(farmAnimals)//true

houseAnimals.isDisjointWith(cityAnimals)//true

//ok
if houseAnimals == houseAnimals2 {
    print("houseAnimals equeal")
}

// MARK: - ## 字典

//Swift 的Dictionary类型被桥接到Foundation的NSDictionary类。
//
//>注意：
//一个字典的Key类型必须遵循Hashable协议，就像Set的值类型。

//创建了一个[Int: String]类型的空字典来储存整数的英语命名。它的键是Int型，值是String型。
var namesOfIntegers = [Int: String]()
namesOfIntegers[10] = "six"
namesOfIntegers = [:]

var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
var airports2 = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary is not empty.")
}
airports["LHR"] = "London"

//updateValue(_:forKey:)方法在这个键不存在对应值的时候会设置新值或者在存在时更新已存在的值。
//和下标方法不同的是，updateValue(_:forKey:)这个方法返回更新值之前的原值。这样使得我们可以检查更新是否成功。
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
    //"The old value for DUB was Dublin.\n"
}

//字典的下标访问会返回对应值的类型的可选值。如果这个字典包含请求键所对应的值，下标会返回一个包含这个存在值的可选值，否则将返回nil：
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}

airports["APL"] = nil
// APL 现在被移除了

//removeValueForKey(_:)方法也可以用来在字典中移除键值对。
airports2.removeValueForKey("APL")

// MARK: - ### 字典遍历

for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}

for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}

for airportName in airports.values {
    print("Airport name: \(airportName)")
}

let airportCodes = [String](airports.keys)
// airportCodes 是 ["YYZ", "LHR"]

let airportNames = [String](airports.values)
// airportNames 是 ["Toronto Pearson", "London Heathrow"]
//Swift 的字典类型是无序集合类型。为了以特定的顺序遍历字典的键或值，可以对字典的keys或values属性使用sort()方法。



